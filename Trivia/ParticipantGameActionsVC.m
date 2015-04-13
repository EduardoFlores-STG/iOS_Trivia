//
//  ParticipantGameActionsVC.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "ParticipantGameActionsVC.h"
#import "Macros.h"

@interface ParticipantGameActionsVC ()

@property (weak, nonatomic) IBOutlet UIButton *buttonOutlet_buttonParticipant;
@property (weak, nonatomic) IBOutlet UILabel *label_participantName;
@property (weak, nonatomic) IBOutlet UILabel *label_participantScore;
@property (weak, nonatomic) IBOutlet UILabel *label_currentPlayerTurn;
@end

@implementation ParticipantGameActionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                               object:nil];
    self.label_currentPlayerTurn.text = @"";
    self.label_participantName.text = self.participant.participant_name;
    self.label_participantScore.text = [NSString stringWithFormat:@"$%d", self.participant.participant_score];
    
    [self disableButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_participant:(id)sender
{
    NSString *message = self.participant.participant_name;
    
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

- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo]objectForKey:MC_SESSION_KEY_PEER_ID];
    NSString *peerDisplayName = peerID.displayName;
    
    NSData *receivedData = [[notification userInfo]objectForKey:MC_SESSION_KEY_DATA];
    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if ([receivedMessage isEqualToString:MC_KEY_ENABLE_BUTTONS])
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             [self displayNameOfActivePlayer:nil];
             [self enableButton];
         }];
    }
    else if ([receivedMessage isEqualToString:MC_KEY_DISABLE_BUTTONS])
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             [self displayNameOfActivePlayer:peerDisplayName];
             [self disableButton];
        }];
    }
}

- (void) displayNameOfActivePlayer:(NSString*)peerDisplayName
{
    if (peerDisplayName)
        self.label_currentPlayerTurn.text = [NSString stringWithFormat:@"%@ is answering the question", peerDisplayName];
    else
        self.label_currentPlayerTurn.text = @"";
}

- (void) enableButton
{
    self.buttonOutlet_buttonParticipant.enabled = YES;
    self.buttonOutlet_buttonParticipant.backgroundColor = [UIColor greenColor];
}

- (void) disableButton
{
    self.buttonOutlet_buttonParticipant.enabled = NO;
    self.buttonOutlet_buttonParticipant.backgroundColor = [UIColor grayColor];
}
@end



































