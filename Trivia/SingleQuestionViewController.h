//
//  SingleQuestionViewController.h
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "Participant.h"

@interface SingleQuestionViewController : UIViewController

@property (nonatomic, retain) Question *question;
@property (nonatomic, assign) BOOL isHost;
@property (nonatomic, retain) Participant *participant;

@end
