//
//  UICustomButton.h
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@interface UICustomButton : UIButton

@property (nonatomic, retain) Question *question;
@property (nonatomic, assign) int coordinate_x;
@property (nonatomic, assign) int coordinate_y;

@end
