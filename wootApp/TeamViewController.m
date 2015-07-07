//
//  TeamViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamViewController.h"
#import "AppDelegate.h"
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
#import "CustomTabBarVC.h"
#import "CoachingStaffViewController.h"

@interface TeamViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TeamDataSource *dataSource;
@property (nonatomic, strong) UIButton *campaignAdButton;
@property (nonatomic, strong) UIImageView *campaignAdImageView;
@property (nonatomic, strong) Campaign *campaign;
@property (nonatomic, assign) CGPoint lastOffset;
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) UIBarButtonItem *favoriteButton;
@property (nonatomic, strong) UIBarButtonItem *unfavoriteButton;
@property (nonatomic, assign) BOOL toolbarIsAnimating;
@property (nonatomic, assign) BOOL isTransitioning;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *circles;

@end

@implementation TeamViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([TeamController sharedInstance].currentTeam.campaigns) {
        //[self chooseCampaign];
    }
    
    self.toolbarIsAnimating = NO;
    [self unhideToolBar];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.5;
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backArrowButton;

}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unhideToolBar];
    self.isTransitioning = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isTransitioning = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isTransitioning = NO;
    self.navigationController.navigationBar.hidden = NO;
    
    self.appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.toolBar = ((CustomTabBarVC *)self.appDelegate.window.rootViewController).toolBar;
    self.toolBar.hidden = YES;
    [self unhideToolBar];
    self.toolBar.hidden = NO;

    self.lastOffset = CGPointMake(0, 0);
    self.currentOffset = CGPointMake(0, 0);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 510) style:UITableViewStyleGrouped];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    self.tableView.delegate = self;
    self.dataSource = [TeamDataSource new];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 215)];
    self.tableView.tableHeaderView = tableHeaderView;
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
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 150)];
    [self.view addSubview:self.header];
    [self setupHeader];
    
    self.campaignAdButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:self.campaignAdButton];
    [self.campaignAdButton alignLeadingEdgeWithView:self.view predicate:@"0"];
    [self.campaignAdButton alignTrailingEdgeWithView:self.view predicate:@"0"];
    [self.campaignAdButton alignBottomEdgeWithView:self.view predicate:@"-44"];
    [self.campaignAdButton constrainHeight:@"50"];
    
    CampaignController *campaignController = [CampaignController sharedInstance];
    CustomTabBarVC *customTBVC = (CustomTabBarVC *)self.appDelegate.window.rootViewController;
    [campaignController loadCampaignsFromDBForTeam:[TeamController sharedInstance].currentTeam WithCompletion:^(BOOL success, NSArray *campaigns) {
        if (success) {
            [TeamController sharedInstance].currentTeam.campaigns = campaigns;
            [customTBVC chooseCampaign];
        }
    }];
    
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

//- (void)setupHeader {
//    SchoolController *schoolController = [SchoolController sharedInstance];
//    TeamController *teamController = [TeamController sharedInstance];
//    
//    UIColor *backgroundColor = [SchoolController sharedInstance].currentSchool.primaryColor;
//    self.header.backgroundColor = backgroundColor;
//    
//    UIView *statusBarStripe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
//    statusBarStripe.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:statusBarStripe];
//    
//
//    UIImageView *logoView = [[UIImageView alloc] initWithImage:schoolController.currentSchool.logo];
//    logoView.frame = CGRectMake(0, 0, 100, 100);
//    logoView.center = CGPointMake(self.header.frame.size.width / 5, self.header.frame.size.height / 2);
//    [self.header addSubview:logoView];
//    
//    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 15, 250, 20)];
//    schoolLabel.text = schoolController.currentSchool.name;
//    schoolLabel.textColor = [UIColor whiteColor];
//    [self.header addSubview:schoolLabel];
//    
//    UILabel *mascottLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 40, 100, 15)];
//    mascottLabel.text = schoolController.currentSchool.mascott;
//    mascottLabel.textColor = [UIColor whiteColor];
//    mascottLabel.font = [UIFont systemFontOfSize:13.0];
//    [self.header addSubview:mascottLabel];
//    
//    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 75, 100, 15)];
//    recordLabel.text = teamController.currentTeam.record;
//    recordLabel.textColor = [UIColor whiteColor];
//    [self.header addSubview:recordLabel];
//}

- (void)setupHeader {
    //    [super viewDidLoad];
    
    float windowWidth = self.view.frame.size.width;
    float headerPhotoBottom = windowWidth/2.083;
    float bigStripeHeight = windowWidth/8.333;
    float littleStripeHeight = windowWidth/46.875;
    
    TeamController *teamController = [TeamController sharedInstance];
    SchoolController *schoolController = [SchoolController sharedInstance];
    
    UIColor *primaryColor = schoolController.currentSchool.primaryColor;
    UIColor *secondaryColor = schoolController.currentSchool.secondaryColor;
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:nil];
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.5;
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backArrowButton;
    
    //    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    //    [backArrow drawInRect:CGRectMake(0, 0, 10, 20) blendMode:1 alpha:0.5];
    //    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backArrow style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    //    backButton.tintColor = [UIColor whiteColor];
    //    self.navigationItem.leftBarButtonItem = backButton;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, headerPhotoBottom + bigStripeHeight + littleStripeHeight + bigStripeHeight)];
    [self.view addSubview:self.headerView];
    
    UIImageView *headerPhoto = [[UIImageView alloc] initWithImage:teamController.currentTeam.athleteHeaderPhoto];
    headerPhoto.frame = CGRectMake(0, 0, windowWidth, headerPhotoBottom);
    headerPhoto.backgroundColor = [UIColor lightGrayColor];
    [self.headerView addSubview:headerPhoto];
    
    UIView *statusBarStripe = [[UIView alloc] init];
    statusBarStripe.backgroundColor = [UIColor whiteColor];
    statusBarStripe.frame = CGRectMake(0, 0, windowWidth, 20);
    [self.view addSubview:statusBarStripe];
    
    UIView *primaryColorStripe = [[UIView alloc] init];
    primaryColorStripe.backgroundColor = primaryColor;
//    primaryColorStripe.backgroundColor = [UIColor blueColor];
    primaryColorStripe.frame = CGRectMake(0, headerPhotoBottom + bigStripeHeight + littleStripeHeight, windowWidth, bigStripeHeight);
    [self.headerView addSubview:primaryColorStripe];
    
    UIView *secondaryColorStripe = [[UIView alloc] init];
    secondaryColorStripe.backgroundColor = secondaryColor;
//    secondaryColorStripe.backgroundColor = [UIColor redColor];
    secondaryColorStripe.frame = CGRectMake(0, headerPhotoBottom + bigStripeHeight, windowWidth, littleStripeHeight);
    [self.headerView addSubview:secondaryColorStripe];
    
    UIView *whiteStripe = [[UIView alloc] init];
    whiteStripe.backgroundColor = [UIColor whiteColor];
    whiteStripe.frame = CGRectMake(0, headerPhotoBottom, self.view.frame.size.width, bigStripeHeight);
    [self.headerView addSubview:whiteStripe];
    
    self.circles = [UIImageView new];
    self.circles.backgroundColor = [UIColor whiteColor];
    [self setRoundedView:self.circles toDiameter:windowWidth/2.083];
    CGPoint circleCenter = self.circles.center;
    circleCenter.x = windowWidth/4 + 6;
    circleCenter.y = headerPhotoBottom;
    self.circles.center = circleCenter;
    [self.view addSubview:self.circles];
    
    UIImageView *colorCircle = [UIImageView new];
    colorCircle.backgroundColor = primaryColor;
//    colorCircle.backgroundColor = [UIColor blueColor];
    [self setRoundedView:colorCircle toDiameter:windowWidth/2.388];
    circleCenter.x = (windowWidth/2.083)/2;
    circleCenter.y = circleCenter.x;
    colorCircle.center = circleCenter;
    [self.circles addSubview:colorCircle];
    
    //    UIImageView *athleteCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"football_portrait_square"]];
    UIImageView *logoCircle = [[UIImageView alloc] initWithImage:schoolController.currentSchool.logo];
    logoCircle.clipsToBounds = YES;
    [self setRoundedView:logoCircle toDiameter:windowWidth/2.5];
    logoCircle.center = circleCenter;
    [self.circles addSubview:logoCircle];
    
    UILabel *schoolNameLabel = [[UILabel alloc] init];
    schoolNameLabel.frame = CGRectMake(circleCenter.x + windowWidth/4, windowWidth/75, windowWidth/3.261, windowWidth/17.8571429);
    NSString *mascotSingular = [schoolController.currentSchool.mascott substringToIndex:[schoolController.currentSchool.mascott length]-1];
    schoolNameLabel.text = [NSString stringWithFormat:@"%@ %@", mascotSingular, @"Football"];
    schoolNameLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    [schoolNameLabel setFont:[schoolNameLabel.font fontWithSize:[self maxFontSize:schoolNameLabel]]];
    [whiteStripe addSubview:schoolNameLabel];
    
    UILabel *teamRecordLabel = [[UILabel alloc] init];
    teamRecordLabel.frame = CGRectMake(circleCenter.x + windowWidth/4, windowWidth/16.304, windowWidth/3.261, windowWidth/25);
    teamRecordLabel.text = [NSString stringWithFormat:@"%@", teamController.currentTeam.record];
    teamRecordLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
    [teamRecordLabel setFont:[teamRecordLabel.font fontWithSize:[self maxFontSize:teamRecordLabel]]];
    [whiteStripe addSubview:teamRecordLabel];
    
    
}

- (void) backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (CGFloat) maxFontSize:(UILabel *)label{
    CGSize initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
    
    if (initialSize.width > label.frame.size.width ||
        initialSize.height > label.frame.size.height)
    {
        while (initialSize.width > label.frame.size.width ||
               initialSize.height > label.frame.size.height)
        {
            [label setFont:[label.font fontWithSize:label.font.pointSize - 1]];
            initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        }
    } else {
        while (initialSize.width < label.frame.size.width &&
               initialSize.height < label.frame.size.height)
        {
            [label setFont:[label.font fontWithSize:label.font.pointSize + 1]];
            initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
        }
        // went 1 point too large so compensate here
        [label setFont:[label.font fontWithSize:label.font.pointSize - 1]];
    }
    return label.font.pointSize;
}

#pragma mark - TableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    switch (indexPath.section){
        
        case 0:
            height = 270;
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
//            [self pushFullSchedule];
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

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"%f", velocity.y);
}

- (void)scrollViewDidScroll :(UIScrollView *)scrollView {
    self.lastOffset = self.currentOffset;
    self.currentOffset = scrollView.contentOffset;
    NSLog(@"%f", self.lastOffset.y);
    if (self.currentOffset.y < self.lastOffset.y) {
        [self unhideToolBar];
    } else {
        [self hideToolBar];
    }
    
    if(self.currentOffset.y < 94.5){
        float headerY = -(self.currentOffset.y + 64.5);
        self.headerView.frame = CGRectMake(0, headerY, self.view.frame.size.width, 215);
//        self.tableView.frame = CGRectMake(0, headerY + 215, self.view.frame.size.width, 510-headerY);
        CGPoint circlesCenter = self.circles.center;
        circlesCenter.y = headerY/2 + 180;
        self.circles.center = circlesCenter;
        
    } else {
        self.headerView.frame = CGRectMake(0, -160, self.view.frame.size.width, 215);
    }

}

- (void)hideToolBar{
    if(!self.toolBar.hidden && !self.toolbarIsAnimating && self.currentOffset.y > -64 && !self.isTransitioning ){
        self.toolbarIsAnimating = YES;
        CustomTabBarVC *customTBVC = (CustomTabBarVC *)self.appDelegate.window.rootViewController;
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, (self.toolBar.frame.size.height));
            customTBVC.campaignAdButton.transform = CGAffineTransformMakeTranslation(0, (self.toolBar.frame.size.height));
//            self.campaignAdButton.transform = CGAffineTransformMakeTranslation(0, (self.toolBar.frame.size.height));
        } completion:^(BOOL finished) {
            self.toolbarIsAnimating = NO;
            self.toolBar.hidden = YES;
        }];
        
    }
}

- (void)unhideToolBar{
    if(self.toolBar.hidden && !self.toolbarIsAnimating && !self.isTransitioning && self.currentOffset.y < 281){
        self.toolbarIsAnimating = YES;
        self.toolBar.hidden = NO;
        CustomTabBarVC *customTBVC = (CustomTabBarVC *)self.appDelegate.window.rootViewController;
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.transform = CGAffineTransformIdentity;
            customTBVC.campaignAdButton.transform = CGAffineTransformIdentity;
           // self.campaignAdButton.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.toolbarIsAnimating = NO;
        }];
        
    }
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
