//
//  Question.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "Question.h"

#define CATEGORY_TITLE          @"category_title"
#define CATEGORY_ID             @"category_id"
#define QUESTION                @"question_question"
#define QUESTION_ANSWER         @"question_answer"
#define QUESTION_VALUE          @"question_value"
#define QUESTION_ID             @"question_id"

@implementation Question

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_question_category_title forKey:CATEGORY_TITLE];
    [encoder encodeObject:_question_category_id forKey:CATEGORY_ID];
    [encoder encodeObject:_question_question forKey:QUESTION];
    [encoder encodeObject:_question_answer forKey:QUESTION_ANSWER];
    [encoder encodeObject:_question_value forKey:QUESTION_VALUE];
    [encoder encodeObject:_question_id forKey:QUESTION_ID];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        NSLog(@"initWithCoder in Question object is nil!");
        return nil;
    }
    
    self.question_category_title = [decoder decodeObjectForKey:CATEGORY_TITLE];
    self.question_category_id = [decoder decodeObjectForKey:CATEGORY_ID];
    self.question_question = [decoder decodeObjectForKey:QUESTION];
    self.question_answer = [decoder decodeObjectForKey:QUESTION_ANSWER];
    self.question_value = [decoder decodeObjectForKey:QUESTION_VALUE];
    self.question_id = [decoder decodeObjectForKey:QUESTION_ID];
    
    return self;
}

@end
