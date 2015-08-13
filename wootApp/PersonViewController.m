//
//  PersonViewController.m
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PersonViewController.h"
#import "AppDelegate.h"
#import "CustomTabBarVC.h"
#import "AthleteTweetController.h"
#import "SchoolController.h"
#import "PersonController.h"
#import "PersonDataSource.h"


@interface PersonViewController () <UITableViewDelegate>

@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PersonDataSource *dataSource;
@property (nonatomic, strong) UIView *header;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.customTBVC = (CustomTabBarVC *)appDelegate.window.rootViewController;
    
    [self.customTBVC chooseCampaign];
    
//    AthleteTweetController* athleteTweetController = [AthleteTweetController sharedInstance];
//    [athleteTweetController athleteTweetNetworkController];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTweets) name:athleteTweetRequestFinished object:nil];
//    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 380) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.dataSource = [PersonDataSource new];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    
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
    
    [self.navigationController.navigationBar setBarTintColor:[SchoolController sharedInstance].currentSchool.primaryColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)setupHeader {
    //    [super viewDidLoad];
    
    float windowWidth = self.view.frame.size.width;
    float headerPhotoBottom = windowWidth/2.083;
    float bigStripeHeight = windowWidth/8.333;
    float littleStripeHeight = windowWidth/46.875;
    
    SchoolController *schoolController = [SchoolController sharedInstance];
    PersonController *personController = [PersonController sharedInstance];
    
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
    
    UIImageView *headerPhoto = [[UIImageView alloc] initWithImage:personController.currentPerson.headerPhoto];
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
    UIImageView *personCircle = [[UIImageView alloc] initWithImage:personController.currentPerson.photo];
    personCircle.clipsToBounds = YES;
    [self setRoundedView:personCircle toDiameter:windowWidth/2.388];
    personCircle.center = circleCenter;
    [headerView addSubview:personCircle];
    
    UILabel *athleteNumberLabel = [[UILabel alloc] init];
    athleteNumberLabel.frame = CGRectMake(windowWidth/2, windowWidth/93.75, windowWidth/6.25, windowWidth/10.135);
    //    athleteNumberLabel.text = @"#88";
    athleteNumberLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:35];
    athleteNumberLabel.textColor = primaryColor;
//    [athleteNumberLabel setFont:[athleteNumberLabel.font fontWithSize:[self maxFontSize:athleteNumberLabel]]];
    [whiteStripe addSubview:athleteNumberLabel];
    
    UILabel *personNameLabel = [[UILabel alloc] init];
    personNameLabel.frame = CGRectMake(athleteNumberLabel.center.x + windowWidth/10.714, windowWidth/75, windowWidth/3.261, windowWidth/17.8571429);
    //    athleteNameLabel.text = @"Luke Robinson";
    personNameLabel.text = personController.currentPerson.name;
    personNameLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
//    [personNameLabel setFont:[personNameLabel.font fontWithSize:[self maxFontSize:personNameLabel]]];
    [whiteStripe addSubview:personNameLabel];
    
    UILabel *athleteHeightLabel = [[UILabel alloc] init];
    athleteHeightLabel.frame = CGRectMake(150 + windowWidth/10.714, 7, 70, 30);
    //    athleteNameLabel.text = @"Luke Robinson";
    athleteHeightLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    athleteHeightLabel.textColor = [UIColor whiteColor];
//    [athleteHeightLabel setFont:[athleteHeightLabel.font fontWithSize:[self maxFontSize:athleteHeightLabel]]];
    [primaryColorStripe addSubview:athleteHeightLabel];
    
    UILabel *athleteWeightLabel = [[UILabel alloc] init];
    athleteWeightLabel.frame = CGRectMake(220 + windowWidth/10.714, 7, 100, 30);
    //    athleteNameLabel.text = @"Luke Robinson";
   
    athleteWeightLabel.font = [UIFont fontWithName:@"ArialMT" size:15];
    athleteWeightLabel.textColor = [UIColor whiteColor];
//    [athleteWeightLabel setFont:[athleteWeightLabel.font fontWithSize:[self maxFontSize:athleteWeightLabel]]];
    [primaryColorStripe addSubview:athleteWeightLabel];
    
    
    UILabel *athletePositionLabel = [[UILabel alloc] init];
    athletePositionLabel.frame = CGRectMake(athleteNumberLabel.center.x + windowWidth/10.714, windowWidth/16.304, windowWidth/3.261, windowWidth/25);
    //    athletePositionLabel.text = @"Senior QB";
       
    athletePositionLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
//    [athletePositionLabel setFont:[athletePositionLabel.font fontWithSize:[self maxFontSize:athletePositionLabel]]];
    [whiteStripe addSubview:athletePositionLabel];
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

//- (CGFloat) maxFontSize:(UILabel *)label{
//    CGSize initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
//    
//    if (initialSize.width > label.frame.size.width ||
//        initialSize.height > label.frame.size.height)
//    {
//        while (initialSize.width > label.frame.size.width ||
//               initialSize.height > label.frame.size.height)
//        {
//            [label setFont:[label.font fontWithSize:label.font.pointSize - 1]];
//            initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
//        }
//    } else {
//        while (initialSize.width < label.frame.size.width &&
//               initialSize.height < label.frame.size.height)
//        {
//            [label setFont:[label.font fontWithSize:label.font.pointSize + 1]];
//            initialSize = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
//        }
//        // went 1 point too large so compensate here
//        [label setFont:[label.font fontWithSize:label.font.pointSize - 1]];
//    }
//    return label.font.pointSize;
//}

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

@end
