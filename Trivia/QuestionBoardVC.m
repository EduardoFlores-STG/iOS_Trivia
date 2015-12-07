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
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define BOARD_NUMBER_OF_ROWS            6
#define BOARD_NUMBER_OF_COLUMNS         6
#define BOARD_NUMBER_OF_CATEGORIES      6

#define ROUND_1_QUESTION_0_VALUE        200
#define ROUND_1_QUESTION_1_VALUE        400
#define ROUND_1_QUESTION_2_VALUE        600
#define ROUND_1_QUESTION_3_VALUE        800
#define ROUND_1_QUESTION_4_VALUE        1000

#define ROUND_2_QUESTION_0_VALUE        400
#define ROUND_2_QUESTION_1_VALUE        800
#define ROUND_2_QUESTION_2_VALUE        1200
#define ROUND_2_QUESTION_3_VALUE        1600
#define ROUND_2_QUESTION_4_VALUE        2000


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
    MCPeerID *currentAnsweringPeerID;
    BOOL isPlayingDoubleJeopardy;
    UIView *questionsBoardView;
    UIView *answersView;
    BOOL isHost;
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
    
    NSLog(@"questions for player = %@", self.arrayOfBoardDataForPlayer);
    
    questionsBoardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * .8, self.view.frame.size.height)];
    [self.view addSubview:questionsBoardView];
    
    arrayCategory_0 = [[NSMutableArray alloc]init];
    arrayCategory_1 = [[NSMutableArray alloc]init];
    arrayCategory_2 = [[NSMutableArray alloc]init];
    arrayCategory_3 = [[NSMutableArray alloc]init];
    arrayCategory_4 = [[NSMutableArray alloc]init];
    arrayCategory_5 = [[NSMutableArray alloc]init];
    categoryTitles = [[NSMutableArray alloc]init];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    if ( !self.arrayOfBoardDataForPlayer)
    {
        // Host workflow
        isHost = YES;
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.labelText = @"Downloading questions...";
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(didReceiveDataWithNotification:)
//                                                     name:MC_NOTIFICATION_DID_RECEIVE_DATA
//                                                   object:nil];
        [self downloadCategories];
    }
    else
    {
        // Participant workflow
        isHost = NO;
        if ([self.arrayOfBoardDataForPlayer isKindOfClass:[NSArray class]])
        {
            arrayCategory_0 = [self.arrayOfBoardDataForPlayer objectAtIndex:0];
            arrayCategory_1 = [self.arrayOfBoardDataForPlayer objectAtIndex:1];
            arrayCategory_2 = [self.arrayOfBoardDataForPlayer objectAtIndex:2];
            arrayCategory_3 = [self.arrayOfBoardDataForPlayer objectAtIndex:3];
            arrayCategory_4 = [self.arrayOfBoardDataForPlayer objectAtIndex:4];
            arrayCategory_5 = [self.arrayOfBoardDataForPlayer objectAtIndex:5];

            
            [self sortArray:arrayCategory_0];
            [self sortArray:arrayCategory_1];
            [self sortArray:arrayCategory_2];
            [self sortArray:arrayCategory_3];
            [self sortArray:arrayCategory_4];
            [self sortArray:arrayCategory_5];
            
            [self hardCodeQuestionValues:arrayCategory_0];
            [self hardCodeQuestionValues:arrayCategory_1];
            [self hardCodeQuestionValues:arrayCategory_2];
            [self hardCodeQuestionValues:arrayCategory_3];
            [self hardCodeQuestionValues:arrayCategory_4];
            [self hardCodeQuestionValues:arrayCategory_5];
            
            [self showQuestions];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!isHost)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveParticipantDataWithNotification:)
                                                     name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                                   object:nil];
    }
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    NSString *message = MC_KEY_DISABLE_BUTTONS;
//    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
//    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
//    NSError *error;
//    
//    [self.appDelegate.mcManager.session sendData:data
//                                         toPeers:allPeers
//                                        withMode:MCSessionSendDataUnreliable
//                                           error:&error];
//    
//    if (error)
//        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
//    
////    [self getAllPartipantsScores];
//}

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
                     [self sortArray:arrayCategory_0];
                     [self sortArray:arrayCategory_1];
                     [self sortArray:arrayCategory_2];
                     [self sortArray:arrayCategory_3];
                     [self sortArray:arrayCategory_4];
                     [self sortArray:arrayCategory_5];
                     
                     [self hardCodeQuestionValues:arrayCategory_0];
                     [self hardCodeQuestionValues:arrayCategory_1];
                     [self hardCodeQuestionValues:arrayCategory_2];
                     [self hardCodeQuestionValues:arrayCategory_3];
                     [self hardCodeQuestionValues:arrayCategory_4];
                     [self hardCodeQuestionValues:arrayCategory_5];

                     [self sendBoardDataFromHostToPlayer];
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
    [categoryTitles addObject:category_title];
    
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

- (void) sortArray:(NSMutableArray*) arrayToBeSorted
{
    [arrayToBeSorted sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"question_value" ascending:YES]]];
}

- (void) hardCodeQuestionValues:(NSMutableArray *) arrayOfQuestions
{
    for (int i = 0; i < [arrayOfQuestions count]; i++)
    {
        Question *question = [arrayOfQuestions objectAtIndex:i];
        switch (i)
        {
            case 0:
                question.question_value = [NSNumber numberWithInt:ROUND_1_QUESTION_0_VALUE];
                break;
            case 1:
                question.question_value = [NSNumber numberWithInt:ROUND_1_QUESTION_1_VALUE];
                break;
            case 2:
                question.question_value = [NSNumber numberWithInt:ROUND_1_QUESTION_2_VALUE];
                break;
            case 3:
                question.question_value = [NSNumber numberWithInt:ROUND_1_QUESTION_3_VALUE];
                break;
            case 4:
                question.question_value = [NSNumber numberWithInt:ROUND_1_QUESTION_4_VALUE];
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
    //[self showScores];
}

- (void) createButtons
{
    NSInteger intXTile;
    NSInteger intYTile;
    
    float tileWidth = questionsBoardView.bounds.size.width / BOARD_NUMBER_OF_COLUMNS;
    float tileHeight = questionsBoardView.bounds.size.height / BOARD_NUMBER_OF_ROWS;
    
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
            [buttons[x][y].titleLabel setFont:[UIFont systemFontOfSize:10]];
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
            
            if (!isHost)
            {
                [buttons[x][y] setEnabled:NO];
            }
            
            [buttons[x][y]setCoordinate_x:x];
            [buttons[x][y]setCoordinate_y:y];
            [questionsBoardView addSubview:buttons[x][y]];
        }
    }
}

//- (void) showScores
//{
//    answersView = [[UIView alloc]initWithFrame:CGRectMake(questionsBoardView.bounds.size.width, 0, self.view.frame.size.width * .2, self.view.frame.size.height)];
//    [answersView setBackgroundColor:[UIColor lightGrayColor]];
//    [self.view addSubview:answersView];
//    
//    UILabel *playerName = [[UILabel alloc]initWithFrame:CGRectMake(answersView.bounds.origin.x, answersView.bounds.origin.y, answersView.bounds.size.width * .9, answersView.bounds.size.height * .2)];
//    [playerName setTextColor:[UIColor whiteColor]];
//    playerName.numberOfLines = 0;
//    playerName.adjustsFontSizeToFitWidth = YES;
//    playerName.lineBreakMode = NSLineBreakByWordWrapping;
//    playerName.textAlignment = NSTextAlignmentCenter;
//    [playerName setFont:[UIFont systemFontOfSize:10]];
//    
//    [playerName setText:@"SOME PLAYER NAME\nSCORE: $1000"];
//    
//    [answersView addSubview:playerName];
//}

- (IBAction)askQuestion:(id)sender
{
    // Host
    UICustomButton *button = (UICustomButton *)sender;
    [button setTitle:nil forState:UIControlStateNormal];
    [button setEnabled:NO];
    
    // Host needs to notify the participant of the question to display
//    NSData *dataQuestion = [NSKeyedArchiver archivedDataWithRootObject:button.question];
    NSData *dataQuestion = [NSKeyedArchiver archivedDataWithRootObject:button];
    
    //NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:dataQuestion
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    if (error)
        NSLog(@"Error sending requesting participants scores. Error = %@", [error localizedDescription]);
    
    // Host needs to perform segue
    if (isHost)
    {
        [[NSOperationQueue mainQueue]addOperationWithBlock:
         ^{
             [self performSegueWithIdentifier:@"segueSingleQuestion" sender:button];
         }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"segueSingleQuestion"])
    {
        SingleQuestionViewController *sqvc = [segue destinationViewController];
        sqvc.participant = self.participant;

//        if (isHost)
//        {
            UICustomButton *button = (UICustomButton *)sender;
            sqvc.question = button.question;
            sqvc.isHost = isHost;
//        }
//        else
//        {
//            Question *question = (Question *)sender;
//            sqvc.question = question;
//        }

    }
}

//- (void) getAllPartipantsScores
//{
//    NSLog(@"in getAllPartipantsScores");
//    NSString *message = MC_KEY_REQUEST_ALL_PARTICIPANTS_SCORE;
//    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
//    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
//    NSError *error;
//    
//    [self.appDelegate.mcManager.session sendData:data
//                                         toPeers:allPeers
//                                        withMode:MCSessionSendDataUnreliable
//                                           error:&error];
//    
//    if (error)
//        NSLog(@"Error sending requesting participants scores. Error = %@", [error localizedDescription]);
//}

//- (void) didReceiveDataWithNotification:(NSNotification *)notification
//{
//    MCPeerID *peerID = [[notification userInfo]objectForKey:MC_SESSION_KEY_PEER_ID];
//    NSString *peerDisplayName = peerID.displayName;
//    NSData *receivedData = [[notification userInfo]objectForKey:MC_SESSION_KEY_DATA];
//    NSString *receivedMessage = [[NSString alloc]initWithData:receivedData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"receivedMessage = %@", receivedMessage);
//    
//    if ([receivedMessage containsString:MC_KEY_SEND_ALL_PARTICIPANTS_SCORE])
//    {
//        NSNumber *score = (NSNumber *)[[receivedMessage componentsSeparatedByString:TRIVIA_GENERIC_SEPARATOR]objectAtIndex:1];
//
//        [[NSOperationQueue mainQueue]addOperationWithBlock:
//         ^{
//             NSLog(@"Participant = %@, Score = %@", peerDisplayName, score);
//         }];
//    }
//}

- (void) didReceiveParticipantDataWithNotification:(NSNotification *)notification
{
    NSData *receivedData = [[notification userInfo]objectForKey:MC_SESSION_KEY_DATA];
    //Question *question = (Question *)[NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    
    UICustomButton *button = (UICustomButton *)[NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
    NSLog(@"in didReceiveParticipantDataWithNotification question = %@", button.question.question_question);
    
    NSLog(@"coordinate x = %d", [button coordinate_x]);
    NSLog(@"coordinate y = %d", [button coordinate_y]);
    
    UICustomButton *buttonInBoard = buttons[button.coordinate_x][button.coordinate_y];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                                  object:nil];
    
    [[NSOperationQueue mainQueue]addOperationWithBlock:
     ^{
         [buttonInBoard setTitle:nil forState:UIControlStateNormal];
         [buttonInBoard setEnabled:NO];
         [self performSegueWithIdentifier:@"segueSingleQuestion" sender:button];
     }];
}

- (void) sendBoardDataFromHostToPlayer
{
    NSString *errorSerialization;
    NSArray *arrayOfAllQuestions = @[arrayCategory_0, arrayCategory_1, arrayCategory_2, arrayCategory_3, arrayCategory_4, arrayCategory_5];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrayOfAllQuestions];
    NSLog(@"errorSerialization = %@", errorSerialization);
    
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [self.appDelegate.mcManager.session sendData:data
                                         toPeers:allPeers
                                        withMode:MCSessionSendDataUnreliable
                                           error:&error];
    
    if (error)
        NSLog(@"Error sending data. Error = %@", [error localizedDescription]);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSLog(@"in viewDidDisappear");
    
    // remove all NSNotifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MC_NOTIFICATION_DID_RECEIVE_DATA
                                                  object:nil];
}
@end
















































