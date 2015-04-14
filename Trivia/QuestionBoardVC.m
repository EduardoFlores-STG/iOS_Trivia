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
#import "AppDelegate.h"
#import "TriviaAPI.h"
#import "Macros.h"
#import "Question.h"
#import "UICustomButton.h"

#define BOARD_NUMBER_OF_ROWS            6
#define BOARD_NUMBER_OF_COLUMNS         6
#define BOARD_NUMBER_OF_CATEGORIES      6

@interface QuestionBoardVC ()
{
    int numberOfCategoriesDownloaded;
    NSMutableArray *arrayCategory_0;
    NSMutableArray *arrayCategory_1;
    NSMutableArray *arrayCategory_2;
    NSMutableArray *arrayCategory_3;
    NSMutableArray *arrayCategory_4;
    NSMutableArray *arrayCategory_5;
    NSArray *arrayOfCategories;
    UICustomButton *buttons[BOARD_NUMBER_OF_COLUMNS][BOARD_NUMBER_OF_ROWS];

}
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, weak) MBProgressHUD *hud;

@end

@implementation QuestionBoardVC

- (void)loadView
{
    [super loadView];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.labelText = @"Downloading questions...";
    
    arrayCategory_0 = [[NSMutableArray alloc]init];
    arrayCategory_1 = [[NSMutableArray alloc]init];
    arrayCategory_2 = [[NSMutableArray alloc]init];
    arrayCategory_3 = [[NSMutableArray alloc]init];
    arrayCategory_4 = [[NSMutableArray alloc]init];
    arrayCategory_5 = [[NSMutableArray alloc]init];
    
    [self downloadCategories];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *message = MC_KEY_DISABLE_BUTTONS;
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) downloadCategories
{
    // download 5 categories at random
    for (int i = 0; i < 6; i++)
    {
        int random_category_id = arc4random() % (TRIVIA_CATEGORY_TOTAL_NUMBER - 1) + 1;

        [TriviaAPI getTriviaCategoryWithCategoryId:random_category_id completionBlock:^(id result, NSError *error)
         {
             [self parseCategories:(NSDictionary *)result categoryNumber:i];
             numberOfCategoriesDownloaded++;
             if (numberOfCategoriesDownloaded == 6)
             {
                 [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                     [self showQuestions];
                 }];
             }
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
                [arrayCategory_0 addObject:question];
                break;
            case 1:
                [arrayCategory_1 addObject:question];
                break;
            case 2:
                [arrayCategory_2 addObject:question];
                break;
            case 3:
                [arrayCategory_3 addObject:question];
                break;
            case 4:
                [arrayCategory_4 addObject:question];
                break;
            case 5:
                [arrayCategory_5 addObject:question];
                break;
            default:
                break;
        }
    }
}

- (void) showQuestions
{
    arrayOfCategories = [[NSArray alloc]initWithObjects:arrayCategory_0,
                                                        arrayCategory_1,
                                                        arrayCategory_2,
                                                        arrayCategory_3,
                                                        arrayCategory_4,
                                                        arrayCategory_5, nil];
    
    [self.hud hide:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self createButtons];

}

- (void) createButtons
{
    NSInteger intXTile;
    NSInteger intYTile;
    
    float tileWidth = self.view.bounds.size.width / BOARD_NUMBER_OF_COLUMNS;
    float tileHeight = self.view.bounds.size.height / BOARD_NUMBER_OF_ROWS;
    
    for (int x = 0; x < BOARD_NUMBER_OF_COLUMNS; x++)
    {
        for (int y = 0; y < BOARD_NUMBER_OF_ROWS; y++)
        {
            intXTile  = x * tileWidth;
            intYTile = y * tileHeight;
            
            // create a value button, text, or image
            buttons[x][y] = [[UICustomButton alloc] initWithFrame:CGRectMake(intXTile, intYTile, tileWidth, tileHeight)];
            [buttons[x][y] setBackgroundImage:[UIImage imageNamed:@"cell"] forState:UIControlStateNormal];
            [buttons[x][y] addTarget:self action:@selector(askQuestion:) forControlEvents:UIControlEventTouchDown];
            [buttons[x][y] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            buttons[x][y].adjustsImageWhenHighlighted = NO;
            buttons[x][y].adjustsImageWhenDisabled = NO;
            buttons[x][y].titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            buttons[x][y].titleLabel.textAlignment = NSTextAlignmentCenter;
            [buttons[x][y] setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
            if (y == 0)
            {
                Question *question_category = [[arrayOfCategories objectAtIndex:x]objectAtIndex:0];
                [buttons[x][y] setTitle:[question_category question_category_title] forState:UIControlStateNormal];
            }
            else if (y > 0 && y < 6)
            {
                Question *question = [[arrayOfCategories objectAtIndex:x]objectAtIndex:(y-1)];
                [buttons[x][y]setQuestion:question];
                [buttons[x][y] setTitle:[NSString stringWithFormat:@"$%@", question.question_value] forState:UIControlStateNormal];
            }
            
            [self.view addSubview:buttons[x][y]];
        }
    }
}

- (IBAction)askQuestion:(id)sender
{    
    UICustomButton *button = (UICustomButton *)sender;
    
    [self performSegueWithIdentifier:@"segueSingleQuestion" sender:button];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UICustomButton *button = (UICustomButton *)sender;

    if ([[segue identifier]isEqualToString:@"segueSingleQuestion"])
    {
        SingleQuestionViewController *sqvc = [segue destinationViewController];
        sqvc.question = button.question;
    }
}
@end
















































