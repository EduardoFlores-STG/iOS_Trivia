//
//  QuestionBoardVC.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "QuestionBoardVC.h"
#import "SingleQuestionViewController.h"
#import "MBProgressHUD.h"
#import "TriviaAPI.h"
#import "Macros.h"
#import "Question.h"

@interface QuestionBoardVC ()
{
    NSMutableArray *arrayCategory_1;
    NSMutableArray *arrayCategory_2;
    NSMutableArray *arrayCategory_3;
    NSMutableArray *arrayCategory_4;
    NSMutableArray *arrayCategory_5;
    NSArray *arrayOfCategories;
}
@end

@implementation QuestionBoardVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    arrayCategory_1 = [[NSMutableArray alloc]init];
    arrayCategory_2 = [[NSMutableArray alloc]init];
    arrayCategory_3 = [[NSMutableArray alloc]init];
    arrayCategory_4 = [[NSMutableArray alloc]init];
    arrayCategory_5 = [[NSMutableArray alloc]init];
    
    [self downloadCategories];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadCategories
{
    // download 5 categories at random
    for (int i = 0; i < 5; i++)
    {
        int random_category_id = rand() % (TRIVIA_CATEGORY_TOTAL_NUMBER - 1) + 1;

        [TriviaAPI getTriviaCategoryWithCategoryId:random_category_id completionBlock:^(id result, NSError *error)
         {
             [self parseCategories:(NSDictionary *)result categoryNumber:i];
             if (i == 4)
                 [self showQuestions];
         }];
    }
}

- (void) parseCategories:(NSDictionary *)category categoryNumber:(int)categoryNumber
{
    NSString *category_title = [category objectForKey:@"title"];
    NSArray *clues = [category objectForKey:@"clues"];
    
    for (NSDictionary *clue in clues)
    {
        Question *question = [[Question alloc]init];
        [question setQuestion_answer:[clue objectForKey:@"answer"]];
        [question setQuestion_category_id:[clue objectForKey:@"category_id"]];
        [question setQuestion_id:[clue objectForKey:@"id"]];
        [question setQuestion_question:[clue objectForKey:@"question"]];
        [question setQuestion_value:[clue objectForKey:@"value"]];
        [question setQuestion_category_title:category_title];
        
        switch (categoryNumber)
        {
            case 0:
                [arrayCategory_1 addObject:question];
                break;
            case 1:
                [arrayCategory_2 addObject:question];
                break;
            case 2:
                [arrayCategory_3 addObject:question];
                break;
            case 3:
                [arrayCategory_4 addObject:question];
                break;
            case 4:
                [arrayCategory_5 addObject:question];
                break;
            default:
                break;
        }
    }
}

- (void) showQuestions
{
    arrayOfCategories = [[NSArray alloc]initWithObjects:arrayCategory_1,
                                                        arrayCategory_2,
                                                        arrayCategory_3,
                                                        arrayCategory_4,
                                                        arrayCategory_5, nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"segueSingleQuestion"])
    {
        //SingleQuestionViewController *sqvc = [segue destinationViewController];
    }
}
@end
















































