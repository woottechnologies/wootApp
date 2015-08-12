//
//  PersonTweetController.h
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>

static NSString *teamTweetRequestFinished = @"teamTweetRequestFinished";

@interface PersonTweetController : NSObject
@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) TWTRTweet *tweet;

+ (PersonTweetController *)sharedInstance;

- (void)teamTweetNetworkController;

@end
