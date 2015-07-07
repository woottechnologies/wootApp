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

@interface TeamViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TeamDataSource *dataSource;
@property (nonatomic, strong) UIButton *campaignAdButton;
@property (nonatomic, strong) UIImageView *campaignAdImageView;

@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 204) style:UITableViewStyleGrouped];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self.view addSubview:self.header];
    [self setupHeader];
    
    self.campaignAdButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50)];
    [self.view addSubview:self.campaignAdButton];
    [self setUpCampaignAd];
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.141 green:0.18 blue:0.518 alpha:1];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
<<<<<<< HEAD
    
    
    //temporary. should be called every time there is a new currentTeam selected
    [[TeamController sharedInstance] loadCampaigns];
=======
}

- (void)viewDidAppear:(BOOL)animated {
    
>>>>>>> 416867e27b0ec890cfda2dacd7813755c60c7db9
}

- (void)setupHeader {
    SchoolController *schoolController = [SchoolController sharedInstance];
    TeamController *teamController = [TeamController sharedInstance];
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.141 green:0.18 blue:0.518 alpha:1];
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

- (void)setUpCampaignAd{
    TeamController *teamController = [TeamController sharedInstance];
    CampaignController *campaignController = [CampaignController sharedInstance];
    Campaign *currentCampaign = [campaignController  selectRandomCampaign:teamController.currentTeam.campaigns];
    self.campaignAdImageView = [[UIImageView alloc] initWithImage:currentCampaign.bannerAd];
    self.campaignAdImageView.frame = self.campaignAdButton.frame;
    [self.campaignAdButton addSubview:self.campaignAdImageView];
    [self.campaignAdButton addTarget:self action:@selector(campaignAdButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)campaignAdButtonPressed{
    CampaignAdViewController *campaignAdViewController = [CampaignAdViewController new];
    campaignAdViewController.campaignAdImageView = self.campaignAdImageView;
    [self.navigationController presentViewController:campaignAdViewController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    switch (indexPath.section){
        
        case 0:
            height = 340;
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
