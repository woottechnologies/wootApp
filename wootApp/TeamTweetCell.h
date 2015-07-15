//
//  TeamTweetCell.h
//  wootApp
//
//  Created by Egan Anderson on 7/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface TeamTweetCell : UITableViewCell

- (void)setUpTweetCell:(TWTRTweet *) tweet;

@end
