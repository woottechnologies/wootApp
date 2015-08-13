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
@import QuartzCore;

@interface UserProfileViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *optionsButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *postsButton;
@property (nonatomic, strong) UIButton *followingButton;
@property (nonatomic, strong) UIButton *followersButton;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UIImageView *profileCircle;

@end

@implementation UserProfileViewController

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title = [NSString stringWithFormat:@"@%@", [UserController sharedInstance].currentUser.username];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.customTBVC.campaignAdButton.hidden = YES;
    
    [self.followingButton setTitle:[NSString stringWithFormat:@"%li\nfollowing", [[NSUserDefaults standardUserDefaults] integerForKey:FollowingCountKey]] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;
    
//    self.optionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(optionsButtonPressed:)];
//    self.navigationItem.rightBarButtonItem = self.optionsButton;
    
    UIImage *hamburger = [UIImage imageNamed:@"hamburger_button.png"];
    UIButton *options = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [options setBackgroundImage:hamburger forState:UIControlStateNormal];
    options.alpha = 0.5;
    [options addTarget:self action:@selector(optionsButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    self.optionsButton =[[UIBarButtonItem alloc] initWithCustomView:options];
    self.navigationItem.rightBarButtonItem = self.optionsButton;
    
    CGPoint circleCenter = CGPointMake(self.view.frame.size.width / 2, 100);
    
//    UIImageView *blackCircle = [UIImageView new];
//    blackCircle.backgroundColor = [UIColor lightGrayColor];
//    [self setRoundedView:blackCircle toDiameter:self.view.frame.size.width/2.355];
//    blackCircle.center = circleCenter;
//    [self.view addSubview:blackCircle];
    
    self.profileCircle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_placeholder.png"]];
    self.profileCircle.clipsToBounds = YES;
    self.profileCircle.backgroundColor = [UIColor blackColor];
    self.profileCircle.alpha = 0.84;
    [self setRoundedView:self.profileCircle toDiameter:self.view.frame.size.width/2.388];
    self.profileCircle.center = circleCenter;
    
    [self.view addSubview:self.profileCircle];
    
    self.postsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.postsButton.frame = CGRectMake(self.view.frame.size.width / 4 - 40, self.profileCircle.frame.size.height + 50, 80, 30);
    self.postsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.postsButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.postsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.postsButton setTitle:[NSString stringWithFormat:@"0\nposts"] forState:UIControlStateNormal];
    //[self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
    [self.postsButton addTarget:self action:@selector(postsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.postsButton];
    
    self.followingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.followingButton.frame = CGRectMake(self.view.frame.size.width / 2 - 40, self.profileCircle.frame.size.height + 50, 80, 30);
    self.followingButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.followingButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.followingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.followingButton setTitle:[NSString stringWithFormat:@"%li\nfollowing", [UserController sharedInstance].currentUser.following.count] forState:UIControlStateNormal];
    //[self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
    [self.followingButton addTarget:self action:@selector(followingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.followingButton];
    
    self.followersButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.followersButton.frame = CGRectMake(self.view.frame.size.width / 4 * 3 - 40, self.profileCircle.frame.size.height + 50, 80, 30);
    self.followersButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.followersButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.followersButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.followersButton setTitle:[NSString stringWithFormat:@"0\nfollowers"] forState:UIControlStateNormal];
    //[self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
    [self.followingButton addTarget:self action:@selector(followingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.followersButton];
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
            [self.navigationController pushViewController:followingVC animated:YES];
        } else {
            NSLog(@"error loading following");
        }
    }];
}

- (void)postsButtonPressed:(UIButton *)button {
    NSLog(@"posts button");
}

- (void)setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
