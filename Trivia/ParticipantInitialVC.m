//
//  ParticipantInitialVC.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "ParticipantInitialVC.h"
#import "AppDelegate.h"
#import "Macros.h"
#import "MBProgressHUD.h"
#import "Participant.h"
#import "QuestionBoardVC.h"
#import "Question.h"

#define SEGUE_PLAYER_BOARD  @"seguePlayerQuestionBoard"

@interface ParticipantInitialVC ()

@property (weak, nonatomic) IBOutlet UITextField *textfield_participantName;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, weak) MBProgressHUD *hud;
@property (nonatomic, strong) Participant *participant;
@end

@implementation ParticipantInitialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textfield_participantName.text = @"Eduardo";
    self.participant = [[Participant alloc]init];
    self.participant.participant_name = self.textfield_participantName.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_startParticipant:(id)sender
{
    // display "wait to get invited" dialog indefinetely
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Waiting for invitation...";
    
    // Initialize Multipeer connectivity with name of textfield
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [[self.appDelegate mcManager]setupPeerAndSessionWithPlayerName:self.textfield_participantName.text];
    
    // broadcast your device so it can be found by MC browser
    [[self.appDelegate mcManager]advertiseItself:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                               object:nil];
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    [self.hud hide:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    MCSessionState state = [[[notification userInfo]objectForKey:MC_SESSION_KEY_STATE]intValue];
    
    if (state == MCSessionStateConnected)
    {
        NSLog(@"connection acquired");
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:SEGUE_PLAYER_BOARD])
    {
        QuestionBoardVC *qbvc = [segue destinationViewController];
        NSArray *arrayOfBoardData = (NSArray *)sender;
        qbvc.arrayOfBoardDataForPlayer = arrayOfBoardData;
        qbvc.participant = self.participant;
    }
}

- (void) didReceiveDataWithNotification:(NSNotification *)notification
{
    // this should come from QuestionBoardVC sendBoardDataFromHostToPlayer
    NSData *receivedData = [[notification userInfo]objectForKey:MC_SESSION_KEY_DATA];
    
    NSArray *arrayOfBoardData = [[NSArray alloc]init];
    arrayOfBoardData = (NSArray *) [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    if (arrayOfBoardData)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                                      object:nil];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            // GETTING CALLED FROM QUESTIONBOARDVC!!!
            [self performSegueWithIdentifier:SEGUE_PLAYER_BOARD sender:arrayOfBoardData];
        }];
    }
}

@end














































