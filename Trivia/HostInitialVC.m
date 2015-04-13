//
//  HostInitialVC.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "HostInitialVC.h"
#import "AppDelegate.h"
#import "Macros.h"
#import "QuestionBoardVC.h"

@interface HostInitialVC ()

@property (weak, nonatomic) IBOutlet UILabel *label_hostInstructions;
@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation HostInitialVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.label_hostInstructions.text = @"Please note there can only be 1 game host in this game. Are you sure you want to be the host?";
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [[self.appDelegate mcManager]setupPeerAndSessionWithPlayerName:[UIDevice currentDevice].name];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:MC_NOTIFICATION_DID_CHANGE_STATE
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)button_startHost:(id)sender
{
    // Initiate the Multipeer connectivity framework
    // Look for available players
    [[self.appDelegate mcManager]setupMCBrowser];
    [[[self.appDelegate mcManager]browser]setDelegate:self];
    [self presentViewController:[[self.appDelegate mcManager]browser]
                       animated:YES
                     completion:nil];
    
    // Invite players
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification
{
    MCPeerID *peerID = [[notification userInfo]objectForKey:MC_SESSION_KEY_PEER_ID];
    MCSessionState state = [[[notification userInfo]objectForKey:MC_SESSION_KEY_STATE]intValue];
    NSLog(@"peer name = %@", peerID.displayName);
    NSLog(@"peer state = %ld", state);
}

- (void) dismissBrowserView
{
    [self.appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"segueQuestionBoard" sender:nil];
}

#pragma mark - MCBrowserViewControllerDelegate Methods
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissBrowserView];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    // for UI design purposes
    [self dismissBrowserView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"segueQuestionBoard"])
    {
    }
}


@end

















































