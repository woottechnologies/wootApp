//
//  UserProfileViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 7/14/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserController.h"
#import "AppDelegate.h"
#import "CustomTabBarVC.h"
#import "FollowingViewController.h"
#import "PersonFeedDataSource.h"
#import "PersonInfoDataSource.h"
#import "PersonInfoCell.h"
#import "UIColor+CreateMethods.h"
@import QuartzCore;

@interface UserProfileViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *optionsButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *postsButton;
@property (nonatomic, strong) UIButton *followingButton;
@property (nonatomic, strong) UIButton *followersButton;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UIImageView *profileCircle;
@property (nonatomic, strong) UITableView *feedTableView;
@property (nonatomic, strong) UITableView *infoTableView;
@property (nonatomic, strong) PersonFeedDataSource *feedDataSource;
@property (nonatomic, strong) PersonInfoDataSource *infoDataSource;
@property (nonatomic, strong) UIView *header;

@end

@implementation UserProfileViewController

//-(void)viewWillAppear:(BOOL)animated {
//    self.navigationItem.title = [NSString stringWithFormat:@"@%@", [UserController sharedInstance].currentUser.username];
//    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    self.customTBVC.campaignAdButton.hidden = YES;
//    
//    [self.followingButton setTitle:[NSString stringWithFormat:@"%li\nfollowing", [[NSUserDefaults standardUserDefaults] integerForKey:FollowingCountKey]] forState:UIControlStateNormal];
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
//    
//    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    self.customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
//    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
//    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = NO;
//    
////    self.optionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(optionsButtonPressed:)];
////    self.navigationItem.rightBarButtonItem = self.optionsButton;
//    
//    UIImage *hamburger = [UIImage imageNamed:@"hamburger_button.png"];
//    UIButton *options = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [options setBackgroundImage:hamburger forState:UIControlStateNormal];
//    options.alpha = 0.5;
//    [options addTarget:self action:@selector(optionsButtonPressed:)
//         forControlEvents:UIControlEventTouchUpInside];
//    self.optionsButton =[[UIBarButtonItem alloc] initWithCustomView:options];
//    self.navigationItem.rightBarButtonItem = self.optionsButton;
//
//    CGPoint circleCenter = CGPointMake(self.view.frame.size.width / 2, 100);
//    
////    UIImageView *blackCircle = [UIImageView new];
////    blackCircle.backgroundColor = [UIColor lightGrayColor];
////    [self setRoundedView:blackCircle toDiameter:self.view.frame.size.width/2.355];
////    blackCircle.center = circleCenter;
////    [self.view addSubview:blackCircle];
//    
//    self.profileCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_placeholder.png"]];
//    self.profileCircle.clipsToBounds = YES;
//    self.profileCircle.backgroundColor = [UIColor blackColor];
//    self.profileCircle.alpha = 0.84;
//    [self setRoundedView:self.profileCircle toDiameter:self.view.frame.size.width/2.388];
//    self.profileCircle.center = circleCenter;
//    
//    [self.view addSubview:self.profileCircle];
//    
//    self.postsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.postsButton.frame = CGRectMake(self.view.frame.size.width / 4 - 40, self.profileCircle.frame.size.height + 50, 80, 30);
//    self.postsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.postsButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    [self.postsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.postsButton setTitle:[NSString stringWithFormat:@"0\nposts"] forState:UIControlStateNormal];
//    //[self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
//    [self.postsButton addTarget:self action:@selector(postsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.postsButton];
//    
//    self.followingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.followingButton.frame = CGRectMake(self.view.frame.size.width / 2 - 40, self.profileCircle.frame.size.height + 50, 80, 30);
//    self.followingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.followingButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    [self.followingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
////    [self.followingButton setTitle:[NSString stringWithFormat:@"%li\nfollowing", [UserController sharedInstance].currentUser.following.count] forState:UIControlStateNormal];
//    //[self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
//    [self.followingButton addTarget:self action:@selector(followingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.followingButton];
//    
//    self.followersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    self.followersButton.frame = CGRectMake(self.view.frame.size.width / 4 * 3 - 40, self.profileCircle.frame.size.height + 50, 80, 30);
//    self.followersButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    self.followersButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    [self.followersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.followersButton setTitle:[NSString stringWithFormat:@"0\nfollowers"] forState:UIControlStateNormal];
//    //[self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
//    [self.followingButton addTarget:self action:@selector(followingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.followersButton];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float windowWidth = self.view.frame.size.width;
    float headerPhotoBottom = windowWidth*0.43;
    float buttonStripeHeight = windowWidth*0.12;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.customTBVC = (CustomTabBarVC *)appDelegate.window.rootViewController;
    self.customTBVC.campaignAdButton.hidden = YES;
    
    [self.customTBVC chooseCampaign];
    
    self.feedTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerPhotoBottom + buttonStripeHeight, self.view.frame.size.width, 380) style:UITableViewStyleGrouped];
    self.feedTableView.delegate = self;
    self.feedDataSource = [PersonFeedDataSource new];
    [self.feedDataSource registerTableView:self.feedTableView viewController:self];
    self.feedTableView.dataSource = self.feedDataSource;
    [self.view addSubview:self.feedTableView];
    self.feedTableView.hidden = NO;
    
    self.infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, headerPhotoBottom + buttonStripeHeight, self.view.frame.size.width, 380) style:UITableViewStyleGrouped];
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
    
    UIImage *hamburger = [UIImage imageNamed:@"hamburger_button.png"];
    UIButton *options = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [options setBackgroundImage:hamburger forState:UIControlStateNormal];
    options.alpha = 0.5;
    [options addTarget:self action:@selector(optionsButtonPressed:)
      forControlEvents:UIControlEventTouchUpInside];
    self.optionsButton =[[UIBarButtonItem alloc] initWithCustomView:options];
    self.navigationItem.rightBarButtonItem = self.optionsButton;
    
    UserController *userController = [UserController sharedInstance];
    self.navigationItem.title = [NSString stringWithFormat:@"@%@", userController.currentUser.username];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
}

- (void)setupHeader {
    float windowWidth = self.view.frame.size.width;
    float headerPhotoBottom = windowWidth*0.43;
    float buttonStripeHeight = windowWidth*0.12;
    
    UserController *userController = [UserController sharedInstance];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, headerPhotoBottom + buttonStripeHeight)];
    [self.view addSubview:headerView];
    
//    UIImageView *headerPhoto;
//    if (userController.currentUser.headerPhoto) {
//        headerPhoto = [[UIImageView alloc] initWithImage:userController.currentUser.headerPhoto];
//    } else {
//        headerPhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woot_headerimage"]];
//    }
//    headerPhoto.frame = CGRectMake(0, 0, windowWidth, headerPhotoBottom);
//    [headerView addSubview:headerPhoto];
    
    UIButton *headerPhotoButton;
    headerPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, windowWidth, headerPhotoBottom)];
    if (userController.currentUser.headerPhoto) {
        [headerPhotoButton setImage:userController.currentUser.headerPhoto forState:UIControlStateNormal];
    } else {
        [headerPhotoButton setImage:[UIImage imageNamed:@"woot_headerimage"] forState:UIControlStateNormal];
    }
    [headerView addSubview:headerPhotoButton];
    
    
    UIView *buttonStripe = [[UIView alloc] init];
    buttonStripe.backgroundColor = [UIColor colorWithHex:@"#807c7c" alpha:1];
    buttonStripe.frame = CGRectMake(0, headerPhotoBottom, windowWidth, buttonStripeHeight);
    [headerView addSubview:buttonStripe];
    
    UIButton *feedButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 9, 30, 30)];
    [feedButton setBackgroundImage:[UIImage imageNamed:@"list_icon"] forState:UIControlStateNormal];
    [feedButton addTarget:self action:@selector(feedButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [buttonStripe addSubview:feedButton];
    
    UIButton *infoButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 9, 30, 30)];
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
    
//    UIImageView *personCircle;
//    if (userController.currentUser.photo) {
//        personCircle = [[UIImageView alloc] initWithImage:userController.currentUser.photo];
//    } else {
//        personCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noimage_profilepic"]];
//    }
//    personCircle.clipsToBounds = YES;
//    [self setRoundedView:personCircle toDiameter:windowWidth*0.245];
//    personCircle.center = circleCenter;
//    personCircle.backgroundColor = [UIColor redColor];
//    [headerView addSubview:personCircle];
    
//    UIImageView *personCircleButton;
//    personCircleButton = [[UIImageView alloc] init];
//    if (userController.currentUser.photo) {
//        [headerPhotoButton setImage:userController.currentUser.photo forState:UIControlStateNormal];
//    } else {
//        [headerPhotoButton setImage:[UIImage imageNamed:@"noimage_profilepic"] forState:UIControlStateNormal];
//    }
//    personCircleButton.clipsToBounds = YES;
//    personCircleButton.center = circleCenter;
//    [self setRoundedView:personCircleButton toDiameter:windowWidth*0.245];
//    [headerView addSubview:personCircleButton];
    
    UIButton *personCircle = [UIButton buttonWithType:UIButtonTypeCustom];
    if (userController.currentUser.photo) {
        [personCircle setImage:userController.currentUser.photo forState:UIControlStateNormal];
    } else {
        [personCircle setImage:[UIImage imageNamed:@"noimage_profilepic"] forState:UIControlStateNormal];
    }
    personCircle.clipsToBounds = YES;
    [self setRoundedButton:personCircle toDiameter:windowWidth*0.245];
    personCircle.center = circleCenter;
    personCircle.backgroundColor = [UIColor redColor];
    [headerView addSubview:personCircle];


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

- (void)setRoundedButton:(UIButton *)roundedButton toDiameter:(float)newSize;{
    CGPoint saveCenter = roundedButton.center;
    CGRect newFrame = CGRectMake(roundedButton.frame.origin.x, roundedButton.frame.origin.y, newSize, newSize);
    roundedButton.frame = newFrame;
    roundedButton.layer.cornerRadius = newSize / 2.0;
    roundedButton.center = saveCenter;
}



- (void)optionsButtonPressed:(UIBarButtonItem *)item {
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    CustomTabBarVC *customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
    
    [customTBVC toggleDrawer];
}

- (void)followingButtonPressed:(UIButton *)button {
    FollowingViewController *followingVC = [[FollowingViewController alloc] init];
    UserController *userController = [UserController sharedInstance];
    
    [userController loadFollowingFromDBWithCompletion:^(BOOL success, NSArray *following) {
        if (success) {
            userController.currentUser.following = following;
            [userController saveUserLocal];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:followingVC animated:YES];
            });
            
        } else {
            NSLog(@"error loading following");
        }
    }];
}

- (void)postsButtonPressed:(UIButton *)button {
    NSLog(@"posts button");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
