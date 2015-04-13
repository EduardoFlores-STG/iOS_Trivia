//
//  HostOrParticipantVC.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "HostOrParticipantVC.h"

@interface HostOrParticipantVC ()

@end

@implementation HostOrParticipantVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button_gameHost:(id)sender
{
    [self performSegueWithIdentifier:@"segueToGameHost" sender:nil];
}
- (IBAction)button_gameParticipant:(id)sender
{
    [self performSegueWithIdentifier:@"segueToGameParticipant" sender:nil];
}
@end


















































