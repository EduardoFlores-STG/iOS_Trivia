//
//  QuestionBoardVC.h
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participant.h"

@interface QuestionBoardVC : UIViewController
{
    NSMutableArray *categoryTitles;
}

@property (nonatomic, retain) NSArray *arrayOfBoardDataForPlayer;
@property (nonatomic, retain) Participant *participant;

@end
