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
#import "UIColor+CreateMethods.h"
#import "UserController.h"

@interface HomeFeedViewController () <UITableViewDelegate>

@property (nonatomic, strong) HomeFeedDataSource *dataSource;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UILabel *noFeedLabel;

@end

@implementation HomeFeedViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.dataSource = [HomeFeedDataSource new];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    
    self.noFeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 30)];
    self.noFeedLabel.text = @"You aren't currently following anybody";
    self.noFeedLabel.textColor = [UIColor lightGrayColor];
    [self.noFeedLabel setTextAlignment:NSTextAlignmentCenter];
    self.noFeedLabel.hidden = YES;
    [self.view addSubview:self.noFeedLabel];
    
    UserController *userController = [UserController sharedInstance];
    [userController loadFollowingFromDBWithCompletion:^(BOOL success, NSArray *following) {
        if (success) {
            userController.currentUser.following = following;
            HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
            dispatch_async(dispatch_get_main_queue(), ^{
                [homeFeedController loadTweetsFromHashtagsWithCompletion:^(BOOL success) {
                    if (success) {
                        if (userController.currentUser && userController.currentUser.following.count > 0) {
                            self.tableView.hidden = NO;
                            self.noFeedLabel.hidden = YES;
                        } else {
                            self.noFeedLabel.hidden = NO;
                            self.tableView.hidden = YES;
                        }
                        [self.tableView reloadData];
                    }
                }];
            });
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
    UserController *userController = [UserController sharedInstance];
    [homeFeedController loadTweetsFromHashtagsWithCompletion:^(BOOL success) {
        if (success) {
            if (self.tableView.isHidden && userController.currentUser && userController.currentUser.following.count > 0) {
                self.noFeedLabel.hidden = YES;
                self.tableView.hidden = NO;
            } else if (!userController.currentUser || userController.currentUser.following.count == 0){
                self.tableView.hidden = YES;
                self.noFeedLabel.hidden = NO;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:@"#1a1c1c" alpha:0.8];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.customTBVC = (CustomTabBarVC *)appDelegate.window.rootViewController;
    self.customTBVC.campaignAdButton.hidden = YES;
}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}

- (void) viewDidAppear:(BOOL)animated{
    UIImageView *wootView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woot_woot_green"]];
    wootView.frame = CGRectMake(0, 0, 90, 30);
    [wootView setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationController.navigationBar.topItem setTitleView:wootView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HomeFeedController *homeFeedController = [HomeFeedController sharedInstance];
//    TWTRTweet *tweet = homeFeedController.tweets[indexPath.row];
//    NSDictionary *posterInfo;
//    for (NSDictionary *tweetAndInfo in homeFeedController.tweetsAndNames) {
//        if ([tweetAndInfo[@"tweetID"] isEqualToString:tweet.tweetID]) {
//            posterInfo = tweetAndInfo;
//            break;
//        }
//    }
//    NSString *type = posterInfo[FollowingTypeKey];
//    
//    if ([type isEqualToString:@"T"]) {
//        TeamViewController *teamVC = [[TeamViewController alloc] init];
//        NSInteger teamID = [[posterInfo objectForKey:FollowingIDKey] integerValue];
//        [[TeamController sharedInstance] selectTeamWithTeamID:teamID andCompletion:^(BOOL success, Team *team) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [TeamController sharedInstance].currentTeam = team;
//                for (School *school in [SchoolController sharedInstance].schools) {
//                    if (school.schoolID == team.schoolID) {
//                        [SchoolController sharedInstance].currentSchool = school;
//                    }
//                }
//                [self.navigationController pushViewController:teamVC animated:YES];
//                [tableView deselectRowAtIndexPath:indexPath animated:NO];
//            });
//        }];
//    } else {
//        AthleteViewController *athleteVC = [[AthleteViewController alloc] init];
//        NSInteger athleteID = [[posterInfo objectForKey:FollowingIDKey] integerValue];
//        [[AthleteController sharedInstance] selectAthleteWithAthleteID:athleteID andCompletion:^(BOOL success, Athlete *athlete) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [AthleteController sharedInstance].currentAthlete = athlete;
//                for (School *school in [SchoolController sharedInstance].schools) {
//                    if (school.schoolID == athlete.schoolID) {
//                        [SchoolController sharedInstance].currentSchool = school;
//                    }
//                }
//                [self.navigationController pushViewController:athleteVC animated:YES];
//                [tableView deselectRowAtIndexPath:indexPath animated:NO];
//            });
//        }];
//    }

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

- (void) athleteNameButtonPressed:(Athlete *)athlete {
    AthleteController *athleteController = [AthleteController sharedInstance];
    athleteController.currentAthlete = athlete;
    AthleteViewController *athleteVC = [AthleteViewController new];
    [self.navigationController pushViewController:athleteVC animated:YES];
}

- (void)teamNameButtonPressed:(Team *)team {
    TeamController *teamController = [TeamController sharedInstance];
    teamController.currentTeam = team;
    TeamViewController *teamVC = [TeamViewController new];
    [self.navigationController pushViewController:teamVC animated:YES];
}

@end
