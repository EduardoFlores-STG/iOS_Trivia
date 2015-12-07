//
//  SingleQuestionViewController.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "SingleQuestionViewController.h"
#import "AppDelegate.h"
#import "Macros.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SingleQuestionViewController ()
{
    MCPeerID *currentAnsweringPeerID;
}

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *label_question;
@property (weak, nonatomic) IBOutlet UILabel *label_questionCategory;
@property (weak, nonatomic) IBOutlet UILabel *label_questionValue;
@property (weak, nonatomic) IBOutlet UILabel *label_currentPlayer;
@property (weak, nonatomic) IBOutlet UILabel *label_answerTitle;
@property (weak, nonatomic) IBOutlet UILabel *label_answer;
@property (weak, nonatomic) IBOutlet UIButton *button_incorrectAnswer;
@property (weak, nonatomic) IBOutlet UIButton *button_correctAnswer;
@property (weak, nonatomic) IBOutlet UIButton *button_enableParticipantButtons;
@property (weak, nonatomic) IBOutlet UIButton *button_answerQuestion;

@end

@implementation SingleQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.label_question.text = self.question.question_question;
    self.label_questionCategory.text = self.question.question_category_title;
    self.label_questionValue.text = [NSString stringWithFormat:@"$%@", self.question.question_value];
    self.label_answer.text = self.question.question_answer;
    
    [self.label_currentPlayer setHidden:YES];

    if ( !self.isHost)
    {
        [self.label_answerTitle setHidden:YES];
        [self.label_answer setHidden:YES];
        [self.button_incorrectAnswer setHidden:YES];
        [self.button_correctAnswer setHidden:YES];
        [self.button_enableParticipantButtons setHidden:YES];
        
        [self.button_answerQuestion setHidden:NO];
        [self.button_answerQuestion setBackgroundColor:[UIColor lightGrayColor]];
        [self.button_answerQuestion setEnabled:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveParticipantDataWithNotification:)
                                                     name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                                   object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveHostDataWithNotification:)
                                                     name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                                   object:nil];
        [self.button_incorrectAnswer setHidden:YES];
        [self.button_correctAnswer setHidden:YES];
    }
    
    //[self sendQuestionToParticipants];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) didReceiveHostDataWithNotification:(NSNotification *)notification
{
    currentAnsweringPeerID = [[notification userInfo]objectForKey:MC_SESSION_KEY_PEER_ID];
    NSString *peerDisplayName = currentAnsweringPeerID.displayName;
    
    NSData *receivedData = [[notification userInfo]objectForKey:MC_SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"peerDisplayName = %@", peerDisplayName);
    NSLog(@"receivedMessage = %@", receivedMessage);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:
     ^{

         self.label_currentPlayer.text = peerDisplayName;
         [self.label_currentPlayer setHidden:NO];
     }];
    
    // needs to notify all participants of the participant that's answering the question
    // and needs to disable all buttons
    NSString *message = MC_KEY_DISABLE_BUTTONS;
    message = [message stringByAppendingString:TRIVIA_GENERIC_SEPARATOR];
    message = [message stringByAppendingString:peerDisplayName];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
    
}

- (void) didReceiveParticipantDataWithNotification:(NSNotification *)notification
{
    NSData *receivedData = [[notification userInfo]objectForKey:MC_SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    //currentAnsweringPeerID = [[notification userInfo]objectForKey:MC_SESSION_KEY_PEER_ID];
    NSString *peerDisplayName = currentAnsweringPeerID.displayName;

    if ([receivedMessage isEqualToString:MC_KEY_ENABLE_BUTTONS])
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             UIColor *customGreen = [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0];
             [self.button_answerQuestion setBackgroundColor:customGreen];
             [self.button_answerQuestion setEnabled:YES];
         }];
    }
    else if ([receivedMessage isEqualToString:MC_KEY_ANSWERING_QUESTION])
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             self.label_currentPlayer.text = peerDisplayName;
             [self.label_currentPlayer setHidden:NO];
             
             // vibrate the phone of the person answering
             AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
         }];
    }
    else if ([receivedMessage containsString:MC_KEY_DISABLE_BUTTONS])
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             [self.button_answerQuestion setBackgroundColor:[UIColor lightGrayColor]];
             [self.button_answerQuestion setEnabled:NO];

             // comes from didReceiveHostDataWithNotification
             // MC_KEY_DISABLE_BUTTONS, TRIVIA_GENERIC_SEPARATOR, peerDisplayName
             self.label_currentPlayer.text = [[receivedMessage componentsSeparatedByString:TRIVIA_GENERIC_SEPARATOR]objectAtIndex:1];
             [self.label_currentPlayer setHidden:NO];
         }];
    }
    else if ([receivedMessage containsString:MC_KEY_ANSWER_CORRECT])
    {
        NSNumber *questionValue = (NSNumber *)[[receivedMessage componentsSeparatedByString:TRIVIA_GENERIC_SEPARATOR]objectAtIndex:1];
        [self.participant setParticipant_score:[NSNumber numberWithInt:[self.participant.participant_score intValue] + [questionValue intValue]]];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             NSLog(@"participant score = %@", self.participant.participant_score);
             [self.navigationController popViewControllerAnimated:YES];
         }];
    }
    else if ([receivedMessage containsString:MC_KEY_ANSWER_INCORRECT])
    {
        NSNumber *questionValue = (NSNumber *)[[receivedMessage componentsSeparatedByString:TRIVIA_GENERIC_SEPARATOR]objectAtIndex:1];
        [self.participant setParticipant_score:[NSNumber numberWithInt:[self.participant.participant_score intValue] - [questionValue intValue]]];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             NSLog(@"participant score = %@", self.participant.participant_score);
             [self.navigationController popViewControllerAnimated:YES];
         }];
    }
}

- (IBAction)button_enableParticipantButtons:(id)sender
{
    NSString *message = MC_KEY_ENABLE_BUTTONS;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
    
    [self.button_incorrectAnswer setHidden:NO];
    [self.button_correctAnswer setHidden:NO];
}

// participant only
- (IBAction)button_answerQuestion:(id)sender
{
    NSLog(@"button answering question!");
    NSString *message = MC_KEY_ANSWERING_QUESTION;  // this sends the peer id, which is the participant's name
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
}



- (IBAction)button_correctAnswer:(id)sender
{
    NSString *message = MC_KEY_ANSWER_CORRECT;
    message = [message stringByAppendingString:TRIVIA_GENERIC_SEPARATOR];
    message = [message stringByAppendingString:[self.question.question_value stringValue]];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *currentPeer = @[currentAnsweringPeerID];
    NSLog(@"currentPeer = %@", currentPeer);
    
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:currentPeer
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
    
    [self button_enableParticipantButtons:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_incorrectAnswer:(id)sender
{
    NSString *message = MC_KEY_ANSWER_INCORRECT;
    message = [message stringByAppendingString:TRIVIA_GENERIC_SEPARATOR];
    message = [message stringByAppendingString:[self.question.question_value stringValue]];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *currentPeer = @[currentAnsweringPeerID];
    NSLog(@"currentPeer = %@", currentPeer);
    
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:currentPeer
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
    
    [self button_enableParticipantButtons:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
