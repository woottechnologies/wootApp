//
//  RosterViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/8/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "RosterViewController.h"
#import "Athlete.h"
#import "TeamController.h"
#import "AthleteViewController.h"
#import "RosterTableViewCell.h"
#import "CustomTabBarVC.h"
#import "AppDelegate.h"
#import "AthleteController.h"
#import "SearchController.h"
#import "SuggestedUsersViewController.h"

static NSString *RosterCellID = @"RosterCellID";

@interface RosterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;

@end

@implementation RosterViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.customTBVC chooseCampaign];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RosterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RosterCellID];
    if (!cell){
        cell = [[RosterTableViewCell alloc] initWithAthlete:self.sortedRoster[indexPath.row] style:UITableViewCellStyleDefault reuseIdentifier:RosterCellID];
    }
//    Athlete *athlete = self.rosterSortedByNumber[indexPath.row];
//    cell.textLabel.text = [NSString stringWithFormat:@"#%ld    %@", (long)athlete.jerseyNumber, athlete.name];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sortedRoster.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AthleteController *athleteController = [AthleteController sharedInstance];
    athleteController.currentAthlete = self.sortedRoster[indexPath.row];
    
    // if statement
    
    SearchController *searchController = [SearchController sharedInstance];
    searchController.userNameSearch = ((Athlete *)self.sortedRoster[indexPath.row]).name;
    SuggestedUsersViewController *suggestedUsersVC = [SuggestedUsersViewController new];
    [self.navigationController pushViewController:suggestedUsersVC animated:YES];
    
    // else statement

//    AthleteViewController *athleteVC = [AthleteViewController new];
//    [self.navigationController pushViewController:athleteVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
