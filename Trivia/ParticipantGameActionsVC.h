//
//  ParticipantGameActionsVC.h
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participant.h"
#import "AppDelegate.h"

@interface ParticipantGameActionsVC : UIViewController

@property (nonatomic, retain) Participant *participant;
@property (nonatomic, strong) AppDelegate *appDelegate;

- (void) enableButton;
- (void) disableButton;

@end
