//
//  TriviaAPI.h
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TriviaAPI : NSObject

+ (void) getAllTriviaCategories:(void (^)(id result, NSError *error))block;
+ (void) getTriviaCategoryWithCategoryId:(int)categoryId completionBlock:(void (^)(id result, NSError *error))completionBlock;

@end
