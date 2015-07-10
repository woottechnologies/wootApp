//
//  TeamTweets.h
//  wootApp
//
//  Created by Egan Anderson on 7/8/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface TeamTweetController : UITableViewCell
@property (nonatomic, strong) NSString *teamHashtag;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) TWTRTweet *tweet;

+ (TeamTweetController *)sharedInstance;

- (void)networkController;

@end
