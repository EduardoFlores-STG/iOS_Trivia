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

@interface SingleQuestionViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *label_question;
@property (weak, nonatomic) IBOutlet UILabel *label_questionCategory;
@property (weak, nonatomic) IBOutlet UILabel *label_questionValue;
@property (weak, nonatomic) IBOutlet UILabel *label_currentPlayer;
@property (weak, nonatomic) IBOutlet UILabel *label_answer;

@end

@implementation SingleQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                               object:nil];

    self.label_question.text = self.question.question_question;
    self.label_answer.text = self.question.question_answer;
    self.label_questionCategory.text = self.question.question_category_title;
    self.label_questionValue.text = [NSString stringWithFormat:@"$%@", self.question.question_value];
    [self sendQuestionToParticipants];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo]objectForKey:MC_SESSION_KEY_PEER_ID];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo]objectForKey:MC_SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    NSLog(@"peerDisplayName = %@", peerDisplayName);
    NSLog(@"receivedMessage = %@", receivedMessage);
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:
     ^{
         //self.label_test.text = [NSString stringWithFormat:@"From: %@, %@", peerDisplayName, receivedMessage];
     }];
}

- (void) sendQuestionToParticipants
{
    NSString *message = self.question.question_question;
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
}

- (IBAction)button_correctAnswer:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)button_incorrectAnswer:(id)sender
{
}



@end
