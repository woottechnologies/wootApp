//
//  HomeFeedDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 7/14/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "HomeFeedDataSource.h"
#import "HomeFeedCell.h"
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
    [self.tableView registerClass:[HomeFeedCell class] forCellReuseIdentifier:homeFeedTweetCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:homeFeedTweetCellID];
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    if ([homeFeedController.posts[indexPath.row] isKindOfClass:[TWTRTweet class]]) {
        TWTRTweet *tweet = homeFeedController.posts[indexPath.row];
        NSDictionary *posterInfo;
        for (NSDictionary *tweetAndInfo in homeFeedController.tweetsAndNames) {
            if ([tweetAndInfo[@"tweetID"] isEqualToString:tweet.tweetID]) {
                posterInfo = tweetAndInfo;
                [cell setUpTweetCell:tweet posterInfo:posterInfo];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
    } else {
        [cell setUpOriginalContentCell:(NSDictionary *)homeFeedController.posts[indexPath.row]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    cell.delegate = self.viewController;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    if (homeFeedController.posts.count < 20) {
        return homeFeedController.posts.count;
    } else {
      return 20;
    }
    return 1;
    
}

@end
