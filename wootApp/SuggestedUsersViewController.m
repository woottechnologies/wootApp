//
//  SuggestedUsersViewController.m
//  wootApp
//
//  Created by Egan Anderson on 8/10/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SuggestedUsersViewController.h"
#import "SuggestedUsersDataSource.h"
#import "SearchController.h"
#import "AthleteController.h"
#import "AthleteViewController.h"
#import "UserViewController.h"
#import "UserController.h"

@interface SuggestedUsersViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SuggestedUsersDataSource *dataSource;

@end

@implementation SuggestedUsersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 3, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.dataSource = [[SuggestedUsersDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    
    UILabel *noVerifiedAthletesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height / 8, self.view.frame.size.width - 20, 100)];
    noVerifiedAthletesLabel.text = @"This athlete does not have a verified account. Here are some suggested users:";
    noVerifiedAthletesLabel.numberOfLines = 0;
    [self.view addSubview:noVerifiedAthletesLabel];
    
    SearchController *searchController = [SearchController sharedInstance];
    searchController.teams = [[NSArray alloc] init];
    searchController.people = [[NSArray alloc] init];
    

        [searchController searchUsersWithCompletion:^(BOOL success) {
            if (success){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];

    searchController.isSearching = YES;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *personDict = [[SearchController sharedInstance].people objectAtIndex:indexPath.row];
//    UserViewController *userVC = [[UserViewController alloc] init];
//    NSInteger athleteID = [[personDict objectForKey:@"athleteID"] integerValue];
//    [[UserController sharedInstance] selectAthleteWithAthleteID:athleteID andCompletion:^(BOOL success, Athlete *athlete) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [AthleteController sharedInstance].currentAthlete = athlete;
//            for (School *school in [SchoolController sharedInstance].schools) {
//                if (school.schoolID == athlete.schoolID) {
//                    [SchoolController sharedInstance].currentSchool = school;
//                }
//            }
//            [self.navigationController pushViewController:athleteVC animated:YES];
//            [tableView deselectRowAtIndexPath:indexPath animated:NO];
//            
//        });
//    }
    
    NSDictionary *personDict = [[SearchController sharedInstance].people objectAtIndex:indexPath.row];
    AthleteViewController *athleteVC = [[AthleteViewController alloc] init];
    NSInteger athleteID = [[personDict objectForKey:@"athleteID"] integerValue];
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

@end
