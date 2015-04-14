//
//  Macros.h
//  Trivia
//
//  Created by Eduardo Flores on 4/11/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#ifndef Trivia_Macros_h
#define Trivia_Macros_h

// Generic
#define TRIVIA_GENERIC_SEPARATOR                @";;;"

// Multipeer connectivity related
#define MC_SERVICE_ID                           @"eduardo-trivia"

#define MC_NOTIFICATION_DID_CHANGE_STATE        @"MCDidChangeStateNotification"
#define MC_NOTIFICATION_DID_RECEIVE_DATA        @"MCDidReceiveDataNotification"
#define MC_SESSION_KEY_PEER_ID                  @"MC_PeerID"
#define MC_SESSION_KEY_STATE                    @"MC_State"
#define MC_SESSION_KEY_DATA                     @"MC_Data"

#define MC_KEY_ENABLE_BUTTONS                   @"MC_EnableButtons"
#define MC_KEY_DISABLE_BUTTONS                  @"MC_DisableButtons"
#define MC_KEY_ASKING_QUESTION                  @"MC_AskingQuestion"
#define MC_KEY_ANSWERING_QUESTION               @"MC_AnsweringQuestion"
#define MC_KEY_CURRENT_QUESTION                 @"MC_CurrentQuestion"
#define MC_KEY_ANSWER_CORRECT                   @"MC_AnswerCorrect"
#define MC_KEY_ANSWER_INCORRECT                 @"MC_AnswerIncorrect"
#define MC_KEY_SCORE                            @"MC_CurrentScore"


// Trivia API related
#define TRIVIA_URL_BASE                         @"http://jservice.io"
#define TRIVIA_URL_CATEGORIES                   @"http://jservice.io/api/categories"
#define TRIVIA_URL_CATEGORY                     @"http://jservice.io/api/category"
#define TRIVIA_URL_CLUES                        @"http://jservice.io/api/clues"

#define TRIVIA_CATEGORY_TOTAL_NUMBER            18418
#define TRIVIA_CATEGORY_POTPOURII               306
#define TRIVIA_CATEGORY_STUPID_ANSWERS          136
#define TRIVIA_CATEGORY_SPORTS                  42
#define TRIVIA_CATEGORY_AMERICAN_HISTORY        780
#define TRIVIA_CATEGORY_ANIMALS                 21
#define TRIVIA_CATEGORY_3_LETTER_WORDS          105
#define TRIVIA_CATEGORY_SCIENCE                 25
#define TRIVIA_CATEGORY_TRANSPORTATION          103
#define TRIVIA_CATEGORY_US_CITIES               7
#define TRIVIA_CATEGORY_PEOPLE                  442
#define TRIVIA_CATEGORY_TELEVISION              67

#endif
