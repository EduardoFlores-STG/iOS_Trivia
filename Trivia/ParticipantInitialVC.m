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
#import "ParticipantGameActionsVC.h"

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

    // remove "wait..." dialog when user gets invited
    // Move to next view once invited and connected
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:MC_NOTIFICATION_DID_CHANGE_STATE
                                               object:nil];
    
    // for UI design
    //[self performSegueWithIdentifier:@"segueParticipantGameAction" sender:nil];

}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    [self.hud hide:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    MCSessionState state = [[[notification userInfo]objectForKey:MC_SESSION_KEY_STATE]intValue];
    
    if (state == MCSessionStateConnected)
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self performSegueWithIdentifier:@"segueParticipantGameAction" sender:nil];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"segueParticipantGameAction"])
    {
        ParticipantGameActionsVC *pgavc = [segue destinationViewController];
        pgavc.participant = self.participant;
        pgavc.appDelegate = self.appDelegate;
    }
}

@end














































