//
//  HomeFeedViewController.h
//  wootApp
//
//  Created by Egan Anderson on 7/13/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"


@interface HomeFeedViewController : UIViewController <HomeFeedCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
