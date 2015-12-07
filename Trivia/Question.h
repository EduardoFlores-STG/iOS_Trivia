//
//  Question.h
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject <NSCoding>

@property (nonatomic, copy) NSString *question_category_title;
@property (nonatomic, retain) NSNumber *question_category_id;
@property (nonatomic, copy) NSString *question_question;
@property (nonatomic, copy) NSString *question_answer;
@property (nonatomic, retain) NSNumber *question_value;
@property (nonatomic, retain) NSNumber *question_id;

@end
