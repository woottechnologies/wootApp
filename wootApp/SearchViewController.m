//
//  ViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/2/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SearchViewController.h"
#import "TeamViewController.h"
#import "SchoolController.h"
#import "TeamController.h"
#import "SearchDataSource.h"
#import "AppDelegate.h"
#import "CustomTabBarVC.h"
#import "UIColor+CreateMethods.h"
#import "SearchController.h"
#import "AthleteViewController.h"
#import "AthleteController.h"
#import "PersonController.h"
#import "PersonViewController.h"

@interface SearchViewController () <UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SearchDataSource *dataSource;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
    
    [SchoolController sharedInstance];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, self.navigationController.navigationBar.frame.size.height - 15, self.view.frame.size.width - 100, 30)];
    self.searchBar.placeholder = @"Search";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    self.cancelButton = [[UIBarButtonItem alloc] init];
    self.cancelButton.title = @"Cancel";
    [self.cancelButton setTarget:self];
    [self.cancelButton setAction:@selector(cancelSearch)];
    self.navigationItem.rightBarButtonItem = self.cancelButton;
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"teams", @"people"]];
    self.segmentedControl.center = CGPointMake(self.view.frame.size.width / 2, 80);
    self.segmentedControl.backgroundColor = [UIColor lightGrayColor];
    [self.segmentedControl setTitle:@"TEAM" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"PEOPLE" forSegmentAtIndex:1];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlToggled) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:self.segmentedControl];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.dataSource = [[SearchDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
//    [[SchoolController sharedInstance] loadSchoolsFromDatabaseWithCompletion:^(BOOL success) {
//        if (success) {
//            //Updating UI must occur on main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"loading schools worked");
//                [self.tableView reloadData];
//            });
//        }
//    }];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    
//    UIView *statusBarStripe = [[UIView alloc] init];
//    statusBarStripe.backgroundColor = [UIColor whiteColor];
//    statusBarStripe.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
//    [self.view addSubview:statusBarStripe];

}

//- (void)backButtonPressed {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    [self.searchBar becomeFirstResponder];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:@"#1a1c1c" alpha:1.0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.customTBVC.campaignAdButton.hidden = YES;
    
    [SearchController sharedInstance].hasSearched = NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchController *searchController = [SearchController sharedInstance];
    if (searchController.selectedSegmentIndex == 0) {
        NSDictionary *teamDict = [[SearchController sharedInstance].teams objectAtIndex:indexPath.row];
        TeamViewController *teamVC = [[TeamViewController alloc] init];
        NSInteger teamID = [[teamDict objectForKey:TeamIDKey] integerValue];
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
    } else if (searchController.selectedSegmentIndex == 1) {
        NSDictionary *personDict = [[SearchController sharedInstance].people objectAtIndex:indexPath.row];
        PersonViewController *personVC = [[PersonViewController alloc] init];
        NSInteger personID = [[personDict objectForKey:PersonIDKey] integerValue];
        [[PersonController sharedInstance] selectPersonWithUserID:personID andCompletion:^(BOOL success, Person *person) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [PersonController sharedInstance].currentPerson = person;
//                for (School *school in [SchoolController sharedInstance].schools) {
//                    if (school.schoolID == athlete.schoolID) {
//                        [SchoolController sharedInstance].currentSchool = school;
//                    }
//                }
                [self.navigationController pushViewController:personVC animated:YES];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            
            });
        }];

    }
   }
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return self.view.frame.size.width/3.538;
//}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];

    SearchController *searchController = [SearchController sharedInstance];
    searchController.teams = [[NSArray alloc] init];
    searchController.people = [[NSArray alloc] init];
    searchController.hasSearched = YES;
    
    self.cancelButton.enabled = NO;
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        searchController.schoolNameSearch = searchBar.text;
        [searchController searchTeamsWithCompletion:^(BOOL success) {
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
    } else if (self.segmentedControl.selectedSegmentIndex == 1) {
        searchController.personNameSearch = searchBar.text;
        [searchController searchPeopleWithCompletion:^(BOOL success) {
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
    }
    searchController.isSearching = YES;
    [self.tableView reloadData];
}

- (void)cancelSearch {
    [self.searchBar resignFirstResponder];
    self.cancelButton.enabled = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [SearchController sharedInstance].hasSearched = NO;
    [self.tableView reloadData];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.cancelButton.enabled = YES;
    return YES;
}

- (void)segmentedControlToggled{
    SearchController *searchController = [SearchController sharedInstance];
    searchController.hasSearched = NO;
    searchController.teams = [NSArray new];
    searchController.people = [NSArray new];
    [self.tableView reloadData];
    searchController.selectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
