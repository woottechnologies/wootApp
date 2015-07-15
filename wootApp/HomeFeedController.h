//
//  HomeFeedController.h
//  wootApp
//
//  Created by Egan Anderson on 7/13/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <TwitterKit/TwitterKit.h>

static NSString *HashtagKey = @"hashtag";

@interface HomeFeedController : NSObject

@property (nonatomic, strong) User *currentUser;
@property (nonatomic, strong) NSArray *hashtags;
@property (nonatomic, strong) NSString *currentHashtag;
@property (nonatomic, strong) NSArray *tweets;

+ (instancetype) sharedInstance;
//- (void) loadHashtagsFromDBWithCompletion;
- (void) loadTweetsFromHashtags;

@end
