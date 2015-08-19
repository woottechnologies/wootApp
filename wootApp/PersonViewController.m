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
#import "PersonFeedDataSource.h"
#import "UIColor+CreateMethods.h"
#import "PersonInfoDataSource.h"


@interface PersonViewController () <UITableViewDelegate>

@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UITableView *feedTableView;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) PersonFeedDataSource *feedDataSource;
@property (nonatomic, strong) PersonInfoDataSource *infoDataSource;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.customTBVC = (CustomTabBarVC *)appDelegate.window.rootViewController;
    
    [self.customTBVC chooseCampaign];
    
    self.feedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 380) style:UITableViewStyleGrouped];
    self.feedTableView.delegate = self;
    self.feedDataSource = [PersonFeedDataSource new];
    [self.feedDataSource registerTableView:self.feedTableView viewController:self];
    self.feedTableView.dataSource = self.feedDataSource;
    [self.view addSubview:self.feedTableView];
    self.feedTableView.hidden = NO;
    
    self.infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, 380) style:UITableViewStyleGrouped];
    self.infoDataSource = [PersonInfoDataSource new];
    [self.infoDataSource registerTableView:self.infoTableView viewController:self];
    self.infoTableView.dataSource = self.infoDataSource;
    [self.view addSubview:self.infoTableView];
    self.infoTableView.hidden = YES;
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self.view addSubview:self.header];
    [self setupHeader];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHex:@"#19b78c" alpha:1]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    PersonController *personController = [PersonController sharedInstance];
    self.navigationItem.title = [NSString stringWithFormat:@"@%@", personController.currentPerson.username];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}

- (void)setupHeader {
    float windowWidth = self.view.frame.size.width;
    float headerPhotoBottom = windowWidth*0.43;
    float buttonStripeHeight = windowWidth*0.12;
    
    PersonController *personController = [PersonController sharedInstance];

    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.5;
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backArrowButton;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, headerPhotoBottom + buttonStripeHeight)];
    [self.view addSubview:headerView];
    
    UIImageView *headerPhoto;
    if (personController.currentPerson.headerPhoto) {
        headerPhoto = [[UIImageView alloc] initWithImage:personController.currentPerson.headerPhoto];
    } else {
        headerPhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woot_headerimage"]];
    }
    headerPhoto.frame = CGRectMake(0, 0, windowWidth, headerPhotoBottom);
    [headerView addSubview:headerPhoto];
   
    UIView *buttonStripe = [[UIView alloc] init];
    buttonStripe.backgroundColor = [UIColor colorWithHex:@"#807c7c" alpha:1];
    buttonStripe.frame = CGRectMake(0, headerPhotoBottom, windowWidth, buttonStripeHeight);
    [headerView addSubview:buttonStripe];
    
    UIButton *feedButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 11, 30, 22)];
    [feedButton setBackgroundImage:[UIImage imageNamed:@"list_icon"] forState:UIControlStateNormal];
    [feedButton addTarget:self action:@selector(feedButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonStripe addSubview:feedButton];
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 20, 30, 7)];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"dots_icon"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonStripe addSubview:infoButton];
    
    UIImageView *whiteCircle = [UIImageView new];
    whiteCircle.backgroundColor = [UIColor whiteColor];
    [self setRoundedView:whiteCircle toDiameter:windowWidth*0.29];
    CGPoint circleCenter = whiteCircle.center;
    circleCenter.x = windowWidth/2;
    circleCenter.y = headerPhotoBottom - windowWidth*0.06;
    whiteCircle.center = circleCenter;
    [headerView addSubview:whiteCircle];
    
    UIImageView *personCircle;
    if (personController.currentPerson.photo) {
        personCircle = [[UIImageView alloc] initWithImage:personController.currentPerson.photo];
    } else {
        personCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noimage_profilepic"]];
    }
    personCircle.clipsToBounds = YES;
    [self setRoundedView:personCircle toDiameter:windowWidth*0.245];
    personCircle.center = circleCenter;
    personCircle.backgroundColor = [UIColor redColor];
    [headerView addSubview:personCircle];
}

- (void) backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) feedButtonPressed {
    self.infoTableView.hidden = YES;
    self.feedTableView.hidden = NO;
}

- (void) infoButtonPressed {
    self.feedTableView.hidden = YES;
    self.infoTableView.hidden = NO;
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
