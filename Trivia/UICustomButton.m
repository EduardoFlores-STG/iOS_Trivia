//
//  UICustomButton.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "UICustomButton.h"

#define BUTTON_QUESTION             @"button_question"
#define BUTTON_COORDINATE_X         @"button_coordinate_x"
#define BUTTON_COORDINATE_Y         @"button_coordinate_y"



@implementation UICustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_question forKey:BUTTON_QUESTION];
    [encoder encodeInteger:_coordinate_x forKey:BUTTON_COORDINATE_X];
    [encoder encodeInteger:_coordinate_y forKey:BUTTON_COORDINATE_Y];

}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        NSLog(@"initWithCoder in UICustomButton object is nil!");
        return nil;
    }
    
    self.question = [decoder decodeObjectForKey:BUTTON_QUESTION];
    self.coordinate_x = [decoder decodeInt32ForKey:BUTTON_COORDINATE_X];
    self.coordinate_y = [decoder decodeInt32ForKey:BUTTON_COORDINATE_Y];
    
    return self;
}

@end
