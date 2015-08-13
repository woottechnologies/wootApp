//
//  PersonTweetCell.h
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>

@interface PersonTweetCell : UITableViewCell

- (void)setUpTweetCell:(TWTRTweet *) tweet;

@end
