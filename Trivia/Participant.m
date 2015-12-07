//
//  Participant.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "Participant.h"

#define PARTICIPANT_NAME        @"participant_name"
#define PARTICIPANT_SCORE       @"participant_score"

@implementation Participant

+(Participant *)sharedInstance
{
    // the instance of this class is stored here
    static Participant *myInstance = nil;
    
    // check to see if an instance already exists
    if (myInstance == nil)
    {
        myInstance = [[[self class]alloc]init];
        
        // initialize variables here, if needed
    }
    
    // return instance of this class
    return myInstance;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_participant_name forKey:PARTICIPANT_NAME];
    [encoder encodeObject:_participant_score forKey:PARTICIPANT_SCORE];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        NSLog(@"initWithCoder in UICustomButton object is nil!");
        return nil;
    }
    
    self.participant_name = [decoder decodeObjectForKey:PARTICIPANT_NAME];
    self.participant_score = [decoder decodeObjectForKey:PARTICIPANT_SCORE];
    
    return self;
}



@end
