//
//  Participant.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "Participant.h"

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
@end
