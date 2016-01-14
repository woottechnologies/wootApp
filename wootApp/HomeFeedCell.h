//
//  HomeFeedCell.h
//  wootApp
//
//  Created by Egan Anderson on 7/16/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import "AthleteController.h"
#import "TeamController.h"

@protocol HomeFeedCellDelegate;

@interface HomeFeedCell : UITableViewCell

@property (weak, nonatomic) id<HomeFeedCellDelegate> delegate;

- (void)setUpTweetCell:(TWTRTweet *) tweet posterInfo:(NSDictionary *)posterInfo;

- (void)setUpOriginalContentCell:(NSDictionary *)contents;

@end

@protocol HomeFeedCellDelegate <NSObject>

- (void)athleteNameButtonPressed:(Athlete *)athlete;

- (void)teamNameButtonPressed:(Team *)team;

@end
