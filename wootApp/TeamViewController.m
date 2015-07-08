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
#import <TwitterKit/TwitterKit.h>


@interface TeamViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TeamDataSource *dataSource;
@property (nonatomic, strong) UIButton *campaignAdButton;
@property (nonatomic, strong) UIImageView *campaignAdImageView;
@property (nonatomic, strong) Campaign *campaign;
@property (nonatomic, assign) CGPoint lastOffset;
@property (nonatomic, assign) CGPoint currentOffset;
@property (nonatomic, strong) UIToolbar *toolBar;
//@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UIBarButtonItem *favoriteButton;
@property (nonatomic, strong) UIBarButtonItem *unfavoriteButton;
@property (nonatomic, assign) BOOL toolbarIsAnimating;
@property (nonatomic, assign) BOOL isTransitioning;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *whiteCircle;
@property (nonatomic, strong) UIImageView *colorCircle;
@property (nonatomic, strong) UIImageView *logoCircle;
@property (nonatomic, assign) float whiteCircleDiameter;
@property (nonatomic, assign) float colorCircleDiameter;
@property (nonatomic, assign) float logoCircleDiameter;
@property (nonatomic, strong) UIImageView *blackView;

@end

@implementation TeamViewController

- (void)viewDidAppear:(BOOL)animated {
   // [super viewDidAppear:animated];
    self.customTBVC.campaignAdButton.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
   // [super viewWillAppear:animated];
    if ([TeamController sharedInstance].currentTeam.campaigns) {
        //[self chooseCampaign];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.toolbarIsAnimating = NO;
    [self unhideToolBar];
    
    [self.tableView reloadData];
    
    SchoolController *schoolController = [SchoolController sharedInstance];
    self.navigationController.navigationBar.backgroundColor = schoolController.currentSchool.primaryColor;
    NSString *mascotSingular = [schoolController.currentSchool.mascott substringToIndex:[schoolController.currentSchool.mascott length]-1];
    self.title = [NSString stringWithFormat:@"%@ %@", mascotSingular, @"Football"];
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.5;
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backArrowButton;
    
    UIImage *favoriteEmpty = [UIImage imageNamed:@"favorite_empty.png"];
    UIButton *favoriteEmptyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [favoriteEmptyButton setBackgroundImage:favoriteEmpty forState:UIControlStateNormal];
    favoriteEmptyButton.alpha = 0.5;
    [favoriteEmptyButton addTarget:self action:@selector(favoriteTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.favoriteButton =[[UIBarButtonItem alloc] initWithCustomView:favoriteEmptyButton];
    
    UIImage *favoriteFilled = [UIImage imageNamed:@"favorite_filled.png"];
    UIButton *favoriteFilledButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [favoriteFilledButton setBackgroundImage:favoriteFilled forState:UIControlStateNormal];
    favoriteFilledButton.alpha = 0.5;
    [favoriteFilledButton addTarget:self action:@selector(unfavoriteTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.unfavoriteButton = [[UIBarButtonItem alloc] initWithCustomView:favoriteFilledButton];
    
    self.navigationItem.rightBarButtonItem = self.favoriteButton;
    
    for (NSDictionary *dict in [UserController sharedInstance].currentUser.favorites) {
        NSInteger favID = [[dict objectForKey:FavIDKey] integerValue];
        NSString *favType = [dict objectForKey:FavTypeKey];
        if (favID == [TeamController sharedInstance].currentTeam.teamID
            && [favType isEqualToString:@"T"]) {
            self.navigationItem.rightBarButtonItem = self.unfavoriteButton;
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated {
   // [super viewWillDisappear:animated];
    [self unhideToolBar];
    self.isTransitioning = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isTransitioning = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SchoolController *schoolController = [SchoolController sharedInstance];
    
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        [[[Twitter sharedInstance] APIClient] loadTweetWithID:@"20" completion:^(TWTRTweet *tweet, NSError *error) {
            TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet style:TWTRTweetViewStyleRegular];
//            [self.view addSubview:tweetView];
        }];
    }];

    
    self.isTransitioning = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = schoolController.currentSchool.primaryColor;
    NSString *mascotSingular = [schoolController.currentSchool.mascott substringToIndex:[schoolController.currentSchool.mascott length]-1];
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%@ %@", mascotSingular, @"Football"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.customTBVC = (CustomTabBarVC *)appDelegate.window.rootViewController;
    self.toolBar = self.customTBVC.toolBar;
    self.toolBar.hidden = YES;
    [self unhideToolBar];
    self.toolBar.hidden = NO;

    self.lastOffset = CGPointMake(0, 0);
    self.currentOffset = CGPointMake(0, 0);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 605) style:UITableViewStyleGrouped];
    [self.tableView setContentOffset:CGPointMake(0, 0)];
    self.tableView.delegate = self;
    self.dataSource = [TeamDataSource new];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
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
<<<<<<< HEAD
    
=======

>>>>>>> 57bbbd0e90ef0208caf11a55a0125fa912c696a2
    [self setupHeader];
    
    CampaignController *campaignController = [CampaignController sharedInstance];
    [campaignController loadCampaignsFromDBForTeam:[TeamController sharedInstance].currentTeam WithCompletion:^(BOOL success, NSArray *campaigns) {
        if (success) {
            [TeamController sharedInstance].currentTeam.campaigns = campaigns;
            [self.customTBVC chooseCampaign];
        }
    }];
    
    UIColor *backgroundColor = [SchoolController sharedInstance].currentSchool.primaryColor;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[GameController sharedInstance] allGamesForTeam:[TeamController sharedInstance].currentTeam WithCompletion:^(BOOL success, NSArray *games) {
        [TeamController sharedInstance].currentTeam.schedule = games;
    }];
}

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
    
    self.navigationController.navigationBar.backgroundColor = primaryColor;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.5;
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backArrowButton;
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, headerPhotoBottom + bigStripeHeight + littleStripeHeight + bigStripeHeight)];
    [self.view addSubview:self.headerView];
    
    UIImageView *headerPhoto = [[UIImageView alloc] initWithImage:teamController.currentTeam.teamHeaderPhoto];
    headerPhoto.frame = CGRectMake(0, 0, windowWidth, headerPhotoBottom);
    headerPhoto.backgroundColor = [UIColor lightGrayColor];
    [self.headerView addSubview:headerPhoto];
    
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
    
    self.whiteCircle = [UIImageView new];
    self.whiteCircle.backgroundColor = [UIColor whiteColor];
    self.whiteCircleDiameter = windowWidth/2.083;
    [self setRoundedView:self.whiteCircle toDiameter:self.whiteCircleDiameter];
    CGPoint circleCenter = self.whiteCircle.center;
    circleCenter.x = windowWidth/4 + 6;
    circleCenter.y = headerPhotoBottom;
    self.whiteCircle.center = circleCenter;
    [self.headerView addSubview:self.whiteCircle];
    
    self.colorCircle = [UIImageView new];
    self.colorCircle.backgroundColor = primaryColor;
    self.colorCircleDiameter = windowWidth/2.388;
//    colorCircle.backgroundColor = [UIColor blueColor];
    [self setRoundedView:self.colorCircle toDiameter:self.colorCircleDiameter];
//    circleCenter.x = (windowWidth/2.083)/2;
//    circleCenter.y = circleCenter.x;
    self.colorCircle.center = circleCenter;
    [self.headerView addSubview:self.colorCircle];
    
    //    UIImageView *athleteCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"football_portrait_square"]];
    self.logoCircle = [[UIImageView alloc] initWithImage:schoolController.currentSchool.logo];
    self.logoCircle.clipsToBounds = YES;
    self.logoCircleDiameter = windowWidth/2.5;
    [self setRoundedView:self.logoCircle toDiameter:self.logoCircleDiameter];
    self.logoCircle.center = circleCenter;
    [self.headerView addSubview:self.logoCircle];
    
    UILabel *schoolNameLabel = [[UILabel alloc] init];
    schoolNameLabel.frame = CGRectMake(circleCenter.x + windowWidth/3.7, 2, 150, 40);
    schoolNameLabel.text = [NSString stringWithFormat:@"%@", schoolController.currentSchool.name];
    schoolNameLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    schoolNameLabel.textColor = primaryColor;
    [schoolNameLabel setFont:[schoolNameLabel.font fontWithSize:[self maxFontSize:schoolNameLabel]]];
    [whiteStripe addSubview:schoolNameLabel];
    
    UILabel *teamRecordLabel = [[UILabel alloc] init];
    teamRecordLabel.frame = CGRectMake(circleCenter.x + windowWidth/3.7, 7, 100, 30);
    teamRecordLabel.text = [NSString stringWithFormat:@"%@", teamController.currentTeam.record];
    teamRecordLabel.font = [UIFont fontWithName:@"ArialMT" size:25];
    teamRecordLabel.textColor = [UIColor whiteColor];
    [teamRecordLabel setFont:[teamRecordLabel.font fontWithSize:[self maxFontSize:teamRecordLabel]]];
    [primaryColorStripe addSubview:teamRecordLabel];
    
    self.blackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width, self.headerView.frame.size.height)];
    self.blackView.backgroundColor = [UIColor blackColor];
    [self.headerView addSubview:self.blackView];
    
//    UIView *statusBarStripe = [[UIView alloc] init];
//    statusBarStripe.backgroundColor = [UIColor whiteColor];
//    statusBarStripe.frame = CGRectMake(0, 0, windowWidth, 20);
//    [self.view addSubview:statusBarStripe];

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

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section){
            
        case 0:
            return YES;
            break;
        case 1:
            return NO;
            break;
        case 2:
            return YES;
            break;
    }
    return NO;
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
//    NSLog(@"%f", self.lastOffset.y);
    if (self.currentOffset.y < self.lastOffset.y) {
        [self unhideToolBar];
    } else {
        [self hideToolBar];
    }
    
    float headerY = -(self.currentOffset.y + 20);
    if(self.currentOffset.y < 260){
        self.headerView.frame = CGRectMake(0, headerY, self.view.frame.size.width, 215);
        float blackViewAlpha = -headerY/290 - 0.068;
//        NSLog(@"%f", blackViewAlpha);
        self.blackView.alpha = blackViewAlpha;
//        self.tableView.frame = CGRectMake(0, headerY + 215, self.view.frame.size.width, 510-headerY);
//        CGPoint circlesCenter = self.whiteCircle.center;
//        circlesCenter.y = headerY*1.6 + 180;
//        self.whiteCircle.center = circlesCenter;
//        CGRect circleFrame = self.circles.frame;
//        circleFrame.size = CGSizeMake(self.circles.frame.size.width *headerScaler, self.circles.frame.size.height *headerScaler);
//        float headerScaler = 1 - headerY/-318;
//        NSLog(@"scaler %f", headerScaler);
//        float whiteCircleDiameterScaled = self.whiteCircleDiameter *headerScaler;
//        self.whiteCircle.frame = CGRectMake(10, headerY/2 + 140, whiteCircleDiameterScaled, whiteCircleDiameterScaled);
//        [self setRoundedView:self.whiteCircle toDiameter:whiteCircleDiameterScaled];
//        
//        float colorCircleDiameterScaled = self.colorCircleDiameter *headerScaler;
////        self.colorCircle.frame = CGRectMake(0, 0, colorCircleDiameterScaled, colorCircleDiameterScaled);
//        CGRect colorCircleFrame = self.colorCircle.frame;
//        colorCircleFrame.size = CGSizeMake(colorCircleDiameterScaled, colorCircleDiameterScaled);
//        self.colorCircle.center = self.whiteCircle.center;
//        [self setRoundedView:self.whiteCircle toDiameter:colorCircleDiameterScaled];
//        self.colorCircle.center = self.whiteCircle.center;
//        
//        float logoCircleDiameterScaled = self.logoCircleDiameter *headerScaler;
////        self.logoCircle.frame = CGRectMake(0, 0, logoCircleDiameterScaled, logoCircleDiameterScaled);
//        CGRect logoCircleFrame = self.logoCircle.frame;
//        logoCircleFrame.size = CGSizeMake(logoCircleDiameterScaled, logoCircleDiameterScaled);
//        self.logoCircle.center = self.whiteCircle.center;
//        [self setRoundedView:self.whiteCircle toDiameter:logoCircleDiameterScaled];
//        self.logoCircle.center = self.whiteCircle.center;
      
//        NSLog(@"width %f", self.whiteCircle.frame.size.width);
//        self.circles.frame = circleFrame;
//        self.circles.center = circlesCenter;
    } else {
        self.headerView.frame = CGRectMake(0, -320, self.view.frame.size.width, 215);
//        self.whiteCircle.center = CGPointMake(self.view.frame.size.width/4 + 6, -60);
    }

}

- (void)hideToolBar{
    if(!self.toolBar.hidden && !self.toolbarIsAnimating && self.currentOffset.y > 0 && !self.isTransitioning ){
        self.toolbarIsAnimating = YES;
     
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.transform = CGAffineTransformMakeTranslation(0, (self.toolBar.frame.size.height));
            self.customTBVC.campaignAdButton.transform = CGAffineTransformMakeTranslation(0, (self.toolBar.frame.size.height));
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
        
        [UIView animateWithDuration:0.3 animations:^{
            self.toolBar.transform = CGAffineTransformIdentity;
            self.customTBVC.campaignAdButton.transform = CGAffineTransformIdentity;
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
    rosterViewController.sortedRoster = [teamController sortRosterByNumber];
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
