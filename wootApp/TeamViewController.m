//
//  TeamViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamController.h"
#import "SchoolController.h"
#import "TeamDataSource.h"
#import "AthleteViewController.h"
#import "RosterViewController.h"
#import "CampaignController.h"
#import "CampaignAdViewController.h"
#import "ScheduleViewController.h"
#import "GameController.h"
#import "UIColor+CreateMethods.h"
#import "UserController.h"
#import "DockViewController.h"
#import "UIView+FLKAutoLayout.h"
#import "CoachingStaffViewController.h"

@interface TeamViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TeamDataSource *dataSource;
@property (nonatomic, strong) UIButton *campaignAdButton;
@property (nonatomic, strong) UIImageView *campaignAdImageView;
@property (nonatomic, strong) Campaign *campaign;
@property (nonatomic, strong) UIBarButtonItem *favoriteButton;
@property (nonatomic, strong) UIBarButtonItem *unfavoriteButton;

@end

@implementation TeamViewController

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([TeamController sharedInstance].currentTeam.campaigns) {
        [self chooseCampaign];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 264) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.dataSource = [TeamDataSource new];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    
    [[TeamController sharedInstance] loadAthletesFromDBWithCompletion:^(BOOL success) {
        if (success) {
            //Updating UI must occur on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
    [[TeamController sharedInstance] loadCoachesFromDBWithCompletion:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self.view addSubview:self.header];
    [self setupHeader];
    
    self.campaignAdButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.campaignAdButton.frame = CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50);
    [self.view addSubview:self.campaignAdButton];
    
    CampaignController *campaignController = [CampaignController sharedInstance];
    [campaignController loadCampaignsFromDBForTeam:[TeamController sharedInstance].currentTeam WithCompletion:^(BOOL success, NSArray *campaigns) {
        if (success) {
            [TeamController sharedInstance].currentTeam.campaigns = campaigns;
            [self setUpCampaignAd];
        }
    }];
     
    
  //  UIColor *backgroundColor = [UIColor colorWithRed:0.141 green:0.18 blue:0.518 alpha:1];
    UIColor *backgroundColor = [SchoolController sharedInstance].currentSchool.primaryColor;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(favoriteTapped:)];
    self.unfavoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(unfavoriteTapped:)];
    
    self.navigationItem.rightBarButtonItem = self.favoriteButton;
    
    for (NSDictionary *dict in [UserController sharedInstance].currentUser.favorites) {
        NSInteger favID = [[dict objectForKey:FavIDKey] integerValue];
        NSString *favType = [dict objectForKey:FavTypeKey];
        if (favID == [TeamController sharedInstance].currentTeam.teamID
            && [favType isEqualToString:@"T"]) {
            self.navigationItem.rightBarButtonItem = self.unfavoriteButton;
        }
    }
    
    [[GameController sharedInstance] allGamesForTeam:[TeamController sharedInstance].currentTeam WithCompletion:^(BOOL success, NSArray *games) {
        [TeamController sharedInstance].currentTeam.schedule = games;
    }];
}

- (void)setupHeader {
    SchoolController *schoolController = [SchoolController sharedInstance];
    TeamController *teamController = [TeamController sharedInstance];
    
   // UIColor *backgroundColor = [UIColor colorWithRed:0.141 green:0.18 blue:0.518 alpha:1];
    UIColor *backgroundColor = [SchoolController sharedInstance].currentSchool.primaryColor;
    self.header.backgroundColor = backgroundColor;

    UIImageView *logoView = [[UIImageView alloc] initWithImage:schoolController.currentSchool.logo];
    logoView.frame = CGRectMake(0, 0, 100, 100);
    logoView.center = CGPointMake(self.header.frame.size.width / 5, self.header.frame.size.height / 2);
    [self.header addSubview:logoView];
    
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 15, 250, 20)];
    schoolLabel.text = schoolController.currentSchool.name;
    schoolLabel.textColor = [UIColor whiteColor];
    [self.header addSubview:schoolLabel];
    
    UILabel *mascottLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 40, 100, 15)];
    mascottLabel.text = schoolController.currentSchool.mascott;
    mascottLabel.textColor = [UIColor whiteColor];
    mascottLabel.font = [UIFont systemFontOfSize:13.0];
    [self.header addSubview:mascottLabel];
    
    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 75, 100, 15)];
    recordLabel.text = teamController.currentTeam.record;
    recordLabel.textColor = [UIColor whiteColor];
    //recordLabel.font = [UIFont systemFontOfSize:13.0];
    [self.header addSubview:recordLabel];
}

- (void)chooseCampaign {
    CampaignController *campaignController = [CampaignController sharedInstance];
    self.campaign = [campaignController  selectRandomCampaign:[TeamController sharedInstance].currentTeam.campaigns];
    self.campaignAdImageView.image = self.campaign.bannerAd;
}

- (void)setUpCampaignAd{
    self.campaignAdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.campaignAdButton.frame.size.width, self.campaignAdButton.frame.size.height)];
    [self.campaignAdButton addSubview:self.campaignAdImageView];
    [self.campaignAdButton addTarget:self action:@selector(campaignAdButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self chooseCampaign];
}

- (void)campaignAdButtonPressed{
    CampaignAdViewController *campaignAdViewController = [CampaignAdViewController new];
    campaignAdViewController.campaignAdImageView = [[UIImageView alloc] initWithImage:self.campaign.fullScreenAd];
    
    [self.navigationController presentViewController:campaignAdViewController animated:YES completion:nil];
}

#pragma mark - TableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    switch (indexPath.section){
        
        case 0:
            height = 380;
            break;
        case 1:
            height = 30;
            break;
        case 2:
            height = 190;
            break;
        case 3:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section){
            
        case 0:
            break;
        case 1:
            [self pushFullSchedule];
            break;
        case 2:
            break;
        case 3:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    UILabel *sectionTitleLabel = [[UILabel alloc] init];
    UIButton *sectionActionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [headerView addSubview:sectionTitleLabel];
    [headerView addSubview:sectionActionButton];
    
    [sectionTitleLabel alignTop:@"10" leading:@"10" toView:headerView];
    [sectionTitleLabel alignBottomEdgeWithView:headerView predicate:@"-10"];
    [sectionTitleLabel constrainWidth:@"200"];
    
    [sectionActionButton alignTop:@"10" bottom:@"-10" toView:headerView];
    [sectionActionButton alignTrailingEdgeWithView:headerView predicate:@"-10"];
    [sectionActionButton constrainWidth:@"100"];
    
    switch (section){
            
        case 0:
            sectionTitleLabel.text = @"Most Viewed Athletes";
            
            [sectionActionButton setTitle:@"See All" forState:UIControlStateNormal];
            [sectionActionButton addTarget:self action:@selector(rosterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1:
            sectionTitleLabel.text = @"Games";
            
            [sectionActionButton setTitle:@"See All" forState:UIControlStateNormal];
            [sectionActionButton addTarget:self action:@selector(pushFullSchedule) forControlEvents:UIControlEventTouchUpInside];

            break;
        case 2:
            sectionTitleLabel.text = @"Coaches";
            break;
        case 3:
            break;
    }
    return headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushFullSchedule{
    ScheduleViewController *scheduleViewController = [ScheduleViewController new];
    [self.navigationController pushViewController:scheduleViewController animated:YES];
}

#pragma mark - MostViewedPlayerCell delegate methods

- (void)athleteButtonPressed:(Athlete *)athlete{
    TeamController *teamController = [TeamController sharedInstance];
    teamController.currentAthlete = athlete;
    AthleteViewController *athleteVC = [AthleteViewController new];
    [self.navigationController pushViewController:athleteVC animated:YES];
}

- (void)rosterButtonPressed{
    TeamController *teamController = [TeamController sharedInstance];
    RosterViewController *rosterViewController = [RosterViewController new];
    rosterViewController.rosterSortedByNumber = [teamController sortRosterByNumber];
    [self.navigationController pushViewController: rosterViewController animated:YES];
}

#pragma mark - CoachingStaffCell delegate methods

-(void)coachButtonPressed {
    CoachingStaffViewController *coachingStaffVC = [[CoachingStaffViewController alloc] init];
    
    [self.navigationController pushViewController:coachingStaffVC animated:YES];
}

#pragma mark - fav buttons

- (void)favoriteTapped:(UIBarButtonItem *)favoriteItem {
    UserController *userController = [UserController sharedInstance];
    
    if (!userController.currentUser) {
        [self.navigationController presentViewController:[DockViewController new] animated:YES completion:nil];
    } else {
        self.navigationItem.rightBarButtonItem = self.unfavoriteButton;
        [userController addFavorite:[TeamController sharedInstance].currentTeam];
    }
}

- (void)unfavoriteTapped:(UIBarButtonItem *)item {
    UserController *userController = [UserController sharedInstance];
    
    if (!userController.currentUser) {
        [self.navigationController presentViewController:[DockViewController new] animated:YES completion:nil];
    } else {
        self.navigationItem.rightBarButtonItem = self.favoriteButton;
        [userController removeFavorite:[TeamController sharedInstance].currentTeam];
    }
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
