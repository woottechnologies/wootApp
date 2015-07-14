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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeFeedTweetCellID];
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    //    if ([teamTweetController.teamHashtag isEqualToString:teamController.currentTeam.teamHashtag] && teamTweetController.tweets) {
    [((TeamTweetCell *)cell) setUpCell:homeFeedController.tweets[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

@end
