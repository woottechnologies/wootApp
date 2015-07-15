//
//  FollowingViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 7/15/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "FollowingViewController.h"
#import "UserController.h"
#import "FollowingDataSource.h"
#import "UIView+FLKAutoLayout.h"
#import "TeamViewController.h"
#import "AthleteViewController.h"
#import "AthleteController.h"
#import "SchoolController.h"

@interface FollowingViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FollowingDataSource *dataSource;

@end

@implementation FollowingViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[FollowingDataSource alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *follow = [[UserController sharedInstance].currentUser.following objectAtIndex:indexPath.row];
    NSString *type = [follow objectForKey:FollowingTypeKey];
    
    if ([type isEqualToString:@"T"]) {
        TeamViewController *teamVC = [[TeamViewController alloc] init];
        NSInteger teamID = [[follow objectForKey:FollowingIDKey] integerValue];
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
        NSInteger athleteID = [[follow objectForKey:FollowingIDKey] integerValue];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
