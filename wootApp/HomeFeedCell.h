//
//  HomeFeedCell.h
//  wootApp
//
//  Created by Egan Anderson on 7/16/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

@interface HomeFeedCell : UITableViewCell

- (void)setUpTweetCell:(TWTRTweet *) tweet posterInfo:(NSDictionary *)posterInfo;

@end
