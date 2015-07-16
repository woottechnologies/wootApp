//
//  HomeFeedViewController.m
//  wootApp
//
//  Created by Egan Anderson on 7/13/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "HomeFeedDataSource.h"
#import "HomeFeedController.h"
#import "TeamTweetController.h"
#import "UserController.h"

@interface HomeFeedViewController () <UITableViewDelegate>

@property (nonatomic, strong) HomeFeedDataSource *dataSource;

@end

@implementation HomeFeedViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    [homeFeedController loadTweetsFromHashtagsWithCompletion:^(BOOL success) {
        if (success) {
            [self.tableView reloadData];
        }
    }];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UserController *userController = [UserController sharedInstance];
    if (userController.currentUser && userController.currentUser.following.count > 0) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.dataSource = [HomeFeedDataSource new];
        [self.dataSource registerTableView:self.tableView viewController:self];
        self.tableView.dataSource = self.dataSource;
        [self.view addSubview:self.tableView];
    } else {
        UILabel *noFeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 30)];
        noFeedLabel.text = @"You aren't currently following anybody";
        noFeedLabel.textColor = [UIColor lightGrayColor];
        [noFeedLabel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:noFeedLabel];
    }
    
    }

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    if (homeFeedController.tweets && homeFeedController.tweets.count>indexPath.row) {
        TWTRTweet *tweet = homeFeedController.tweets[indexPath.row];
        height = [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)];
    } else {
        height = 0;
    }
    return height;
}

@end
