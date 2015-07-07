//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "AthleteViewController.h"
#import "AthleteDataSource.h"
#import "TeamController.h"
#import "UIView+FLKAutoLayout.h"
#import "StatsController.h"
#import "UserController.h"
#import "DockViewController.h"
#import "SchoolController.h"
#import "AppDelegate.h"
#import "CustomTabBarVC.h"


@interface AthleteViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AthleteDataSource *dataSource;
@property (nonatomic, strong) UIBarButtonItem *favoriteButton;
@property (nonatomic, strong) UIBarButtonItem *unfavoriteButton;
//@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;

@end

@implementation AthleteViewController

- (void)viewWillAppear:(BOOL)animated {
   // [super viewWillAppear:animated];
    
    self.customTBVC.toolBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[StatsController sharedInstance] loadSummaryStatsFromDBForAthlete:[TeamController sharedInstance].currentAthlete WithCompletion:^(BOOL success, Stats *stats) {
        if (success) {
            [TeamController sharedInstance].currentAthlete.stats = stats;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.customTBVC = (CustomTabBarVC *)appDelegate.window.rootViewController;
    
    [self.customTBVC chooseCampaign];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 380) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.dataSource = [AthleteDataSource new];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    
    self.favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(favoriteTapped:)];
    self.unfavoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(unfavoriteTapped:)];
    
    self.navigationItem.rightBarButtonItem = self.favoriteButton;
    
    for (NSDictionary *dict in [UserController sharedInstance].currentUser.favorites) {
        NSInteger favID = [[dict objectForKey:FavIDKey] integerValue];
        NSString *favType = [dict objectForKey:FavTypeKey];
        if (favID == [TeamController sharedInstance].currentAthlete.athleteID
            && [favType isEqualToString:@"A"]) {
            self.navigationItem.rightBarButtonItem = self.unfavoriteButton;
        }
    }
    
//    [self.view addSubview:customTabBarVC.toolBar];
//    [customTabBarVC.toolBar alignLeadingEdgeWithView:self.view predicate:@"0"];
//    [customTabBarVC.toolBar alignTrailingEdgeWithView:self.view predicate:@"0"];
//    [customTabBarVC.toolBar alignBottomEdgeWithView:self.view predicate:@"0"];
//    [customTabBarVC.toolBar constrainHeight:@"44"];
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self.view addSubview:self.header];
    [self setupHeader];
    
//    UIColor *backgroundColor = [UIColor colorWithRed:0.141 green:0.18 blue:0.518 alpha:1];
//
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
//    
//    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
//    [self.navigationController.navigationBar setTranslucent:NO];
}

/*
- (void)setupHeader {
    TeamController *teamController = [TeamController sharedInstance];
    SchoolController *schoolController = [SchoolController sharedInstance];
    
    UIColor *backgroundColor = schoolController.currentSchool.primaryColor;
    self.header.backgroundColor = backgroundColor;
    
    UIImageView *photo = [[UIImageView alloc] initWithImage:teamController.currentAthlete.photo];
//    photo.frame = CGRectMake(0, 0, 105, 150);
    photo.center = CGPointMake(photo.frame.size.width / 2, self.header.frame.size.height / 2);
    [self.header addSubview:photo];
    [photo alignTop:@"0" leading:@"0" toView:self.header];
    [photo alignBottomEdgeWithView:self.header predicate:@"0"];
    [photo alignTrailingEdgeWithView:self.header predicate:@"*0.3"];
    
    UIView *info = [[UIView alloc] init];
    
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 15, 25, 250, 20)];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = teamController.currentAthlete.name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:22.0];
    [info addSubview:nameLabel];
    [nameLabel alignTop:@"25" leading:@"15" toView:info];
    [nameLabel constrainWidth:@"150"];
    
    
//    UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 175, 25, 250, 20)];
    UILabel *viewsLabel = [[UILabel alloc] init];
    viewsLabel.text = [NSString stringWithFormat:@"%li views", (long)teamController.currentAthlete.views];
    viewsLabel.textColor = [UIColor whiteColor];
    [info addSubview:viewsLabel];
    [viewsLabel alignBottomEdgeWithView:nameLabel predicate:@"0"];
    [viewsLabel constrainLeadingSpaceToView:nameLabel predicate:@"10"];
    
//    UILabel *jerseyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 15, 50, 100, 15)];
    UILabel *jerseyNumberLabel = [[UILabel alloc] init];
    jerseyNumberLabel.text = [NSString stringWithFormat:@"#%li", (long)teamController.currentAthlete.jerseyNumber];
    jerseyNumberLabel.textColor = [UIColor whiteColor];
   // jerseyNumberLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:jerseyNumberLabel];
    [jerseyNumberLabel alignLeadingEdgeWithView:nameLabel predicate:@"0"];
    [jerseyNumberLabel constrainTopSpaceToView:nameLabel predicate:@"10"];
    
//    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 55, 50, 100, 15)];
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = teamController.currentAthlete.position;
    positionLabel.textColor = [UIColor whiteColor];
   // positionLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:positionLabel];
    [positionLabel constrainLeadingSpaceToView:jerseyNumberLabel predicate:@"30"];
    [positionLabel constrainTopSpaceToView:nameLabel predicate:@"10"];
    
//    UIView *dividingLine = [[UIView alloc] initWithFrame:CGRectMake(photo.frame.size.width + 20, 85, self.view.frame.size.width - photo.frame.size.width - 40, 2)];
    UIView *dividingLine = [[UIView alloc] init];
    dividingLine.backgroundColor = [UIColor whiteColor];
    [info addSubview:dividingLine];
    [dividingLine constrainHeight:@"2"];
    [dividingLine constrainWidthToView:info predicate:@"-50"];
    [dividingLine alignCenterXWithView:info predicate:@"0"];
    [dividingLine constrainTopSpaceToView:jerseyNumberLabel predicate:@"10"];
    
//    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 15, 110, 100, 15)];
    UILabel *heightLabel = [[UILabel alloc] init];
    heightLabel.text = [NSString stringWithFormat:@"%@", [self inchesToFeet:teamController.currentAthlete.height]];
    heightLabel.textColor = [UIColor whiteColor];
  //  heightLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:heightLabel];
    [heightLabel constrainTopSpaceToView:dividingLine predicate:@"15"];
    [heightLabel alignLeadingEdgeWithView:nameLabel predicate:@"0"];
    
//    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 75, 110, 100, 15)];
    UILabel *weightLabel = [[UILabel alloc] init];
    weightLabel.text = [NSString stringWithFormat:@"%lilbs", (long)teamController.currentAthlete.weight];
    weightLabel.textColor = [UIColor whiteColor];
    //  heightLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:weightLabel];
    [weightLabel constrainLeadingSpaceToView:heightLabel predicate:@"20"];
    [weightLabel alignBottomEdgeWithView:heightLabel predicate:@"0"];
    
//    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 165, 110, 100, 15)];
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.text = [NSString stringWithFormat:@"%@", [self calculateYear:teamController.currentAthlete.year]];
    yearLabel.textColor = [UIColor whiteColor];
    //  heightLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:yearLabel];
    [yearLabel constrainLeadingSpaceToView:weightLabel predicate:@"20"];
    [yearLabel alignBottomEdgeWithView:weightLabel predicate:@"0"];
    
    [self.header addSubview:info];
    [info alignTopEdgeWithView:self.header predicate:@"0"];
    [info alignBottom:@"0" trailing:@"0" toView:self.header];
    [info constrainLeadingSpaceToView:photo predicate:@"0"];
    
    UIView *primaryColorStripe = [[UIView alloc] init];
    primaryColorStripe.backgroundColor = schoolController.currentSchool.primaryColor;
    primaryColorStripe.frame = CGRectMake(0, 193, self.view.frame.size.width, 45);
    [self.view addSubview:primaryColorStripe];
    
    //    UIView *secondaryColorStripe = [[UIView alloc] init];
    //    secondaryColorStripe.backgroundColor = schoolController.currentSchool.secondaryColor;
    //    secondaryColorStripe.frame = CGRectMake(0, 250, self.view.frame.size.width, 8);
    //    [self.view addSubview:secondaryColorStripe];


   // self.navigationController.navigationBar.backgroundColor = backgroundColor;
    
    
    //    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 75, 100, 15)];
    //    recordLabel.text = teamController.currentTeam.record;
    //    recordLabel.textColor = [UIColor whiteColor];
    //    //recordLabel.font = [UIFont systemFontOfSize:13.0];
    //    [self.header addSubview:recordLabel];
    //
}
*/
 
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
    
//    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
//    [backArrow drawInRect:CGRectMake(0, 0, 10, 20) blendMode:1 alpha:0.5];
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backArrow style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
//    backButton.tintColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = backButton;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, windowWidth, headerPhotoBottom + bigStripeHeight + littleStripeHeight + bigStripeHeight)];
    [self.view addSubview:headerView];
    
    UIImageView *headerPhoto = [[UIImageView alloc] initWithImage:teamController.currentTeam.athleteHeaderPhoto];
    headerPhoto.frame = CGRectMake(0, 0, windowWidth, headerPhotoBottom);
    [headerView addSubview:headerPhoto];
    
//    UIView *statusBarStripe = [[UIView alloc] init];
//    statusBarStripe.backgroundColor = [UIColor whiteColor];
//    statusBarStripe.frame = CGRectMake(0, 0, windowWidth, 20);
//    [self.view addSubview:statusBarStripe];
    
    UIView *primaryColorStripe = [[UIView alloc] init];
    primaryColorStripe.backgroundColor = primaryColor;
    primaryColorStripe.frame = CGRectMake(0, headerPhotoBottom + bigStripeHeight + littleStripeHeight, windowWidth, bigStripeHeight);
    [headerView addSubview:primaryColorStripe];
    
    UIView *secondaryColorStripe = [[UIView alloc] init];
    secondaryColorStripe.backgroundColor = secondaryColor;
    secondaryColorStripe.frame = CGRectMake(0, headerPhotoBottom + bigStripeHeight, windowWidth, littleStripeHeight);
    [headerView addSubview:secondaryColorStripe];
    
    UIView *whiteStripe = [[UIView alloc] init];
    whiteStripe.backgroundColor = [UIColor whiteColor];
    whiteStripe.frame = CGRectMake(0, headerPhotoBottom, self.view.frame.size.width, bigStripeHeight);
    [headerView addSubview:whiteStripe];
    
    UIImageView *whiteCircle = [UIImageView new];
    whiteCircle.backgroundColor = [UIColor whiteColor];
    [self setRoundedView:whiteCircle toDiameter:windowWidth/2.083];
    CGPoint circleCenter = whiteCircle.center;
    circleCenter.x = windowWidth/4 + 6;
    circleCenter.y = headerPhotoBottom;
    whiteCircle.center = circleCenter;
    [headerView addSubview:whiteCircle];
    
//    UIImageView *athleteCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"football_portrait_square"]];
    UIImageView *athleteCircle = [[UIImageView alloc] initWithImage:teamController.currentAthlete.photo];
    athleteCircle.clipsToBounds = YES;
    [self setRoundedView:athleteCircle toDiameter:windowWidth/2.388];
    athleteCircle.center = circleCenter;
    [headerView addSubview:athleteCircle];
    
    UILabel *athleteNumberLabel = [[UILabel alloc] init];
    athleteNumberLabel.frame = CGRectMake(windowWidth/2, windowWidth/93.75, windowWidth/6.25, windowWidth/10.135);
//    athleteNumberLabel.text = @"#88";
    athleteNumberLabel.text = [NSString stringWithFormat:@"#%li", (long)teamController.currentAthlete.jerseyNumber];
    athleteNumberLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35];
    athleteNumberLabel.textColor = primaryColor;
    [athleteNumberLabel setFont:[athleteNumberLabel.font fontWithSize:[self maxFontSize:athleteNumberLabel]]];
    [whiteStripe addSubview:athleteNumberLabel];
    
    UILabel *athleteNameLabel = [[UILabel alloc] init];
    athleteNameLabel.frame = CGRectMake(athleteNumberLabel.center.x + windowWidth/10.714, windowWidth/75, windowWidth/3.261, windowWidth/17.8571429);
//    athleteNameLabel.text = @"Luke Robinson";
    athleteNameLabel.text = teamController.currentAthlete.name;
    athleteNameLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    [athleteNameLabel setFont:[athleteNameLabel.font fontWithSize:[self maxFontSize:athleteNameLabel]]];
    [whiteStripe addSubview:athleteNameLabel];
    
    UILabel *athleteHeightLabel = [[UILabel alloc] init];
    athleteHeightLabel.frame = CGRectMake(150 + windowWidth/10.714, 7, 70, 30);
    //    athleteNameLabel.text = @"Luke Robinson";
    athleteHeightLabel.text = [NSString stringWithFormat:@"%@", [self inchesToFeet:teamController.currentAthlete.height]];
    athleteHeightLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    athleteHeightLabel.textColor = [UIColor whiteColor];
    [athleteHeightLabel setFont:[athleteHeightLabel.font fontWithSize:[self maxFontSize:athleteHeightLabel]]];
    [primaryColorStripe addSubview:athleteHeightLabel];

    UILabel *athleteWeightLabel = [[UILabel alloc] init];
    athleteWeightLabel.frame = CGRectMake(220 + windowWidth/10.714, 7, 100, 30);
    //    athleteNameLabel.text = @"Luke Robinson";
    athleteWeightLabel.text = [NSString stringWithFormat:@"%lilbs", (long)teamController.currentAthlete.weight];
    athleteWeightLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    athleteWeightLabel.textColor = [UIColor whiteColor];
    [athleteWeightLabel setFont:[athleteWeightLabel.font fontWithSize:[self maxFontSize:athleteWeightLabel]]];
    [primaryColorStripe addSubview:athleteWeightLabel];

    
    UILabel *athletePositionLabel = [[UILabel alloc] init];
    athletePositionLabel.frame = CGRectMake(athleteNumberLabel.center.x + windowWidth/10.714, windowWidth/16.304, windowWidth/3.261, windowWidth/25);
//    athletePositionLabel.text = @"Senior QB";
    athletePositionLabel.text = [NSString stringWithFormat:@"%@ %@", [self calculateYear:teamController.currentAthlete.year], teamController.currentAthlete.position];
    
    athletePositionLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
    [athletePositionLabel setFont:[athletePositionLabel.font fontWithSize:[self maxFontSize:athletePositionLabel]]];
    [whiteStripe addSubview:athletePositionLabel];
    
    
}

- (void) backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    TeamController *teamController = [TeamController sharedInstance];
    
    float height = 0;
    
    switch (indexPath.section){
        case 0:
            height = 300;
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

-(CGFloat)bioLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height + 30;
}


- (NSString *)inchesToFeet:(NSInteger)heightInches{
    NSInteger feet = heightInches / 12;
    NSInteger inches = heightInches % 12;
    NSString *height = [NSString stringWithFormat:@"%li'%li\"", feet, inches];
    return height;
}

- (NSString *)calculateYear:(NSInteger)year{
    NSString *yearString;
    switch (year) {
        case (long)9:
            yearString = @"Freshman";
            break;
        case (long)10:
            yearString = @"Sophomore";
            break;
        case (long)11:
            yearString = @"Junior";
            break;
        case (long)12:
            yearString = @"Senior";
            break;
        default:
            yearString = @" ";
            break;
    }
    return yearString;
}

- (void)favoriteTapped:(UIBarButtonItem *)favoriteItem {
    UserController *userController = [UserController sharedInstance];
    
    if (!userController.currentUser) {
        [self.navigationController presentViewController:[DockViewController new] animated:YES completion:nil];
    } else {
        self.navigationItem.rightBarButtonItem = self.unfavoriteButton;
        [userController addFavorite:[TeamController sharedInstance].currentAthlete];
    }
}

- (void)unfavoriteTapped:(UIBarButtonItem *)item {
    UserController *userController = [UserController sharedInstance];
    
    if (!userController.currentUser) {
        [self.navigationController presentViewController:[DockViewController new] animated:YES completion:nil];
    } else {
        self.navigationItem.rightBarButtonItem = self.favoriteButton;
        [userController removeFavorite:[TeamController sharedInstance].currentAthlete];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end