//
//  HomeFeedDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 7/14/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "HomeFeedDataSource.h"
#import "TweetCell.h"
#import "OriginalContentCell.h"
#import "HomeFeedController.h"

static NSString *homeFeedTweetCellID = @"homeFeedTweetCellID";
static NSString *originalContentCellID = @"originalContentCellID";

@interface HomeFeedDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) HomeFeedViewController *viewController;

@end

@implementation HomeFeedDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(HomeFeedViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[TweetCell class] forCellReuseIdentifier:homeFeedTweetCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    if ([homeFeedController.posts[indexPath.row] isKindOfClass:[TWTRTweet class]]) {
        TweetCell *tweetCell = [tableView dequeueReusableCellWithIdentifier:homeFeedTweetCellID];
        tweetCell.delegate = self.viewController;
        TWTRTweet *tweet = homeFeedController.posts[indexPath.row];
        NSDictionary *posterInfo;
        for (NSDictionary *tweetAndInfo in homeFeedController.tweetsAndNames) {
            if ([tweetAndInfo[@"tweetID"] isEqualToString:tweet.tweetID]) {
                posterInfo = tweetAndInfo;
                [tweetCell setUpTweetCell:tweet posterInfo:posterInfo];
                [tweetCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return tweetCell;
            }
        }
        
    } else {
        OriginalContentCell *ocCell = [tableView dequeueReusableCellWithIdentifier:originalContentCellID];
        ocCell.delegate = self.viewController;
        [ocCell setUpOriginalContentCell:(NSDictionary *)homeFeedController.posts[indexPath.row]];
        [ocCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return ocCell;
    }
    
    return [[UITableViewCell alloc] init];
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
