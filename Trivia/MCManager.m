//
//  MCManager.m
//  Trivia
//
//  Created by Eduardo Flores on 4/13/15.
//  Copyright (c) 2015 Eduardo Flores. All rights reserved.
//

#import "MCManager.h"
#import "Macros.h"

@implementation MCManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.peerID = nil;
        self.session = nil;
        self.browser = nil;
        self.advertiser = nil;
    }
    return self;
}

#pragma mark - Public methods
- (void)setupPeerAndSessionWithPlayerName:(NSString *)displayName
{
    self.peerID = [[MCPeerID alloc]initWithDisplayName:displayName];
    
    self.session = [[MCSession alloc]initWithPeer:self.peerID];
    self.session.delegate = self;
}

- (void)setupMCBrowser
{
    self.browser = [[MCBrowserViewController alloc]initWithServiceType:MC_SERVICE_ID session:self.session];
}

- (void)advertiseItself:(BOOL)shouldAdvertise
{
    if (shouldAdvertise)
    {
        self.advertiser = [[MCAdvertiserAssistant alloc]initWithServiceType:MC_SERVICE_ID
                                                              discoveryInfo:nil
                                                                    session:self.session];
        [self.advertiser start];
    }
    else
    {
        [self.advertiser stop];
        self.advertiser = nil;
    }
}

#pragma mark - Delegate methods
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSDictionary *dictionary = @{MC_SESSION_KEY_DATA : data,
                                 MC_SESSION_KEY_PEER_ID : peerID };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_NOTIFICATION_DID_RECEIVE_DATA
                                                        object:nil
                                                      userInfo:dictionary];
    
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSDictionary *dictionary = @{MC_SESSION_KEY_PEER_ID : peerID,
                                 MC_SESSION_KEY_STATE : [NSNumber numberWithInt:state]};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MC_NOTIFICATION_DID_CHANGE_STATE
                                                        object:nil
                                                      userInfo:dictionary];
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    // we're not doing streams
}
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    // we're not sending files
}
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    // we're not receiving resources, only data
}

@end













































