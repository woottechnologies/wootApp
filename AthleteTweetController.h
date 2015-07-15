//
//  AthleteTweetController.h
//  wootApp
//
//  Created by Egan Anderson on 7/15/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>

static NSString *athleteTweetRequestFinished = @"athleteTweetRequestFinished";

@interface AthleteTweetController : NSObject

@property (nonatomic, strong) NSString *athleteHandle;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) TWTRTweet *tweet;

+ (AthleteTweetController *)sharedInstance;
- (void)athleteTweetNetworkController;

@end
