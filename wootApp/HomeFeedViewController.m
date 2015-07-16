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
#import "TeamViewController.h"
#import "AthleteViewController.h"
#import "SchoolController.h"
#import "AthleteController.h"
#import "CustomTabBarVC.h"
#import "AppDelegate.h"

@interface HomeFeedViewController () <UITableViewDelegate>

@property (nonatomic, strong) HomeFeedDataSource *dataSource;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) NSArray *following;

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
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    if (self.following != [UserController sharedInstance].currentUser.following) {
        [homeFeedController loadTweetsFromHashtagsWithCompletion:^(BOOL success) {
            if (success) {
                [self.tableView reloadData];
            }
        }];
        self.following = [UserController sharedInstance].currentUser.following;
    }
    
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.customTBVC = (CustomTabBarVC *)appDelegate.window.rootViewController;
    self.customTBVC.campaignAdButton.hidden = YES;
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    TWTRTweet *tweet = homeFeedController.tweets[indexPath.row];
    NSDictionary *posterInfo;
    for (NSDictionary *tweetAndInfo in homeFeedController.tweetsAndNames) {
        if ([tweetAndInfo[@"tweetID"] isEqualToString:tweet.tweetID]) {
            posterInfo = tweetAndInfo;
            break;
        }
    }
    NSString *type = posterInfo[FollowingTypeKey];
    
    if ([type isEqualToString:@"T"]) {
        TeamViewController *teamVC = [[TeamViewController alloc] init];
        NSInteger teamID = [[posterInfo objectForKey:FollowingIDKey] integerValue];
        [[TeamController sharedInstance] selectTeamWithTeamID:teamID andCompletion:^(BOOL success, Team *team) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [TeamController sharedInstance].currentTeam = team;
                for (School *school in [SchoolController sharedInstance].schools) {
                    if (school.schoolID == team.schoolID) {
                        [SchoolController sharedInstance].currentSchool = school;
                    }
                }
                [self.navigationController pushViewController:teamVC animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            });
        }];
    } else {
        AthleteViewController *athleteVC = [[AthleteViewController alloc] init];
        NSInteger athleteID = [[posterInfo objectForKey:FollowingIDKey] integerValue];
        [[AthleteController sharedInstance] selectAthleteWithAthleteID:athleteID andCompletion:^(BOOL success, Athlete *athlete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AthleteController sharedInstance].currentAthlete = athlete;
                for (School *school in [SchoolController sharedInstance].schools) {
                    if (school.schoolID == athlete.schoolID) {
                        [SchoolController sharedInstance].currentSchool = school;
                    }
                }
                [self.navigationController pushViewController:athleteVC animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            });
        }];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    if (homeFeedController.tweets && homeFeedController.tweets.count>indexPath.row) {
        TWTRTweet *tweet = homeFeedController.tweets[indexPath.row];
        height = [TWTRTweetTableViewCell heightForTweet:tweet width:CGRectGetWidth(self.view.bounds)] + 35;
    } else {
        height = 0;
    }
    return height;
}

@end
