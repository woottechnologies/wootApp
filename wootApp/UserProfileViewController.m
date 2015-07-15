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

@interface UserProfileViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *optionsButton;
@property (nonatomic, strong) UIView *userHeader;
@property (nonatomic, strong) UIButton *followingButton;
@property (nonatomic, strong) UILabel *followers;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.optionsButton = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStylePlain target:self action:@selector(optionsButtonPressed:)];
    self.navigationItem.rightBarButtonItem = self.optionsButton;
    
    self.followingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.followingButton.frame = CGRectMake(self.view.frame.size.width / 2 - 40, 80, 80, 30);
    [self.followingButton setTitle:@"Following" forState:UIControlStateNormal];
    [self.followingButton addTarget:self action:@selector(followingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.followingButton];
}

- (void)optionsButtonPressed:(UIBarButtonItem *)item {
    AppDelegate *appD = [[UIApplication sharedApplication] delegate];
    CustomTabBarVC *customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
    
    [customTBVC toggleDrawer];
}

- (void)followingButtonPressed:(UIButton *)button {
    FollowingViewController *followingVC = [[FollowingViewController alloc] init];
    [self.navigationController pushViewController:followingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
