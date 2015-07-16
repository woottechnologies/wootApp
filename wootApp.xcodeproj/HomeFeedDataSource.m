//
//  HomeFeedDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 7/14/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "HomeFeedDataSource.h"
#import "TeamTweetCell.h"
#import "HomeFeedController.h"

static NSString *homeFeedTweetCellID = @"homeFeedTweetCellID";

@interface HomeFeedDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HomeFeedViewController *viewController;

@end

@implementation HomeFeedDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(HomeFeedViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[TeamTweetCell class] forCellReuseIdentifier:homeFeedTweetCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:homeFeedTweetCellID];
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    [cell setUpTweetCell:homeFeedController.tweets[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    if (homeFeedController.tweets.count < 20) {
        return homeFeedController.tweets.count;
    } else {
      return 20;
    }
}

@end
