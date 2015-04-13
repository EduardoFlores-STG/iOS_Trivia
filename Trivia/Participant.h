//
//  Participant.h
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Participant : NSObject

@property (nonatomic, copy) NSString *participant_name;
@property (nonatomic, assign) int participant_score;

@end
