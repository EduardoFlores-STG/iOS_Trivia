//
//  TriviaAPI.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "TriviaAPI.h"
#import "AFNetworking.h"
#import "Macros.h"

@implementation TriviaAPI

+ (void) getAllTriviaCategories:(void (^)(id result, NSError *error))completionBlock
{
    // max count is 100
    NSString *urlString = [NSString stringWithFormat:@"%@?count=100", TRIVIA_URL_CATEGORIES];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         completionBlock(responseObject, nil);
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionBlock(nil, error);
     }];
    
    [operation start];
}

+ (void) getTriviaCategoryWithCategoryId:(int)categoryId completionBlock:(void (^)(id result, NSError *error))completionBlock
{
    NSString *urlString = [NSString stringWithFormat:@"%@?id=%d", TRIVIA_URL_CATEGORY, categoryId];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         completionBlock(responseObject, nil);
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         completionBlock(nil, error);
     }];
    
    [operation start];
}

@end





















































