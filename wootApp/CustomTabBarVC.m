//
//  CustomTabBarVC.m
//  wootApp
//
//  Created by Cole Wilkes on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CustomTabBarVC.h"
#import "DrawerDataSource.h"
#import "UserController.h"
#import "DockViewController.h"
#import "SchoolListViewController.h"
#import "UIView+FLKAutoLayout.h"
#import "TeamViewController.h"
#import "AthleteViewController.h"
#import "CampaignController.h"
#import "CampaignAdViewController.h"
#import "UIView+FLKAutoLayout.h"
#import "AthleteController.h"
#import "SchoolController.h"
@import MessageUI;

@interface CustomTabBarVC () <UITabBarControllerDelegate, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *drawer;
@property (nonatomic, strong) UIButton *drawerButton;
@property (nonatomic, strong) UIButton *logOut;
//@property (nonatomic, strong) UIButton *toggleAccountButton;
@property (nonatomic, strong) DrawerDataSource *dataSource;

@end

@implementation CustomTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.hidden = YES;
    
    [[SchoolController sharedInstance] loadSchoolsFromDatabaseWithCompletion:^(BOOL success) {
        if (success) {
            
        }
    }];
    
//    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44.0)];
    self.toolBar = [[UIToolbar alloc] init];
    
    UIBarButtonItem *homeFeedItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(homeFeedItemTapped:)];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemTapped:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *selfItem = [[UIBarButtonItem alloc] initWithTitle:@"self" style:UIBarButtonItemStylePlain target:self action:@selector(selfItemTapped:)];
    
    [self.toolBar setItems:@[flexibleSpace, homeFeedItem, flexibleSpace, searchItem, flexibleSpace, selfItem, flexibleSpace]];
    [self.view addSubview:self.toolBar];
    [self.toolBar alignLeadingEdgeWithView:self.view predicate:@"0"];
    [self.toolBar alignTrailingEdgeWithView:self.view predicate:@"0"];
    [self.toolBar alignBottomEdgeWithView:self.view predicate:@"0"];
    [self.toolBar constrainHeight:@"44"];
    
    [self setUpCampaignAd];
    
    self.drawerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.drawerButton.enabled = NO;
    self.drawerButton.backgroundColor = [UIColor blackColor];
    self.drawerButton.alpha = 0.0;
    [self.drawerButton addTarget:self action:@selector(toggleDrawer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.drawerButton];
    
    // account button
    self.logOut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.logOut.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height - 45, self.view.frame.size.width * 2 / 3, 44.0);
    self.logOut.enabled = NO;
    self.logOut.backgroundColor = [UIColor redColor];
    [self.logOut setTitle:@"Log Out" forState:UIControlStateNormal];
    [self.logOut addTarget:self action:@selector(logOutPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.logOut];
    
    // drawer tableview
    self.drawer = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width  * 2 / 3, self.view.frame.size.height - self.logOut.frame.size.height) style:UITableViewStyleGrouped];
    self.dataSource = [[DrawerDataSource alloc] init];
    [self.dataSource registerTableView:self.drawer viewController:self];
    self.drawer.dataSource = self.dataSource;
    self.drawer.delegate = self;
    self.drawer.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"woot_square.png"]];
    headerImageView.frame = CGRectMake(0, 0, self.drawer.frame.size.width, self.drawer.frame.size.width - 33.33);
    self.drawer.tableHeaderView = headerImageView;
    self.drawer.backgroundColor = [UIColor whiteColor];
    self.drawer.hidden = YES;
    [self.view addSubview:self.drawer];
}

-(void)viewWillAppear:(BOOL)animated {
    for (UINavigationController *vc in self.childViewControllers) {
        [vc viewWillAppear:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    for (UINavigationController *vc in self.childViewControllers) {
        [vc viewDidAppear:animated];
    }
    
    self.drawer.hidden = YES;
   // self.campaignAdButton.hidden = YES;
}

#pragma mark - UIBarButtonItems for tool bar

- (void)homeFeedItemTapped:(UIBarButtonItem *)homeFeedItem {
    UINavigationController *vc = self.childViewControllers[0];
    self.selectedViewController = vc;
    [vc popToRootViewControllerAnimated:YES];
}

- (void)searchItemTapped:(UIBarButtonItem *)searchItem {
//    if (!self.drawer.hidden) {
//        [self toggleDrawer];
//    }
    
    UINavigationController *vc = self.childViewControllers[1];
    self.selectedViewController = vc;
    [vc popToRootViewControllerAnimated:YES];
}

- (void)selfItemTapped:(UIBarButtonItem *)selfItem {
   // [self toggleDrawer];
    
    UINavigationController *vc = self.childViewControllers[2];
    
    if (![UserController sharedInstance].currentUser) {
        vc = self.childViewControllers[1];
        [vc presentViewController:[DockViewController new] animated:YES completion:nil];
    } else {
        vc = self.childViewControllers[2];
        self.selectedViewController = vc;
        [vc popToRootViewControllerAnimated:YES];
    }
}

- (void)toggleDrawer {
    [self.drawer reloadData];
    if (self.drawer.hidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            self.drawer.center = CGPointMake(self.view.frame.size.width - self.drawer.frame.size.width / 2, self.drawer.center.y);
            self.logOut.center = CGPointMake(self.view.frame.size.width - self.logOut.frame.size.width / 2, self.logOut.center.y);
            self.drawerButton.alpha = 0.4;
        }];
        self.drawer.hidden = NO;
        self.drawerButton.enabled = YES;
        self.logOut.enabled = YES;
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            self.drawer.center = CGPointMake(self.view.frame.size.width + self.drawer.frame.size.width / 2, self.drawer.center.y);
            self.logOut.center = CGPointMake(self.view.frame.size.width + self.logOut.frame.size.width / 2, self.logOut.center.y);
            self.drawerButton.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.drawer.hidden = YES;
                self.drawerButton.enabled = NO;
                self.logOut.enabled = NO;
            }
        }];
    }
}

- (void)logOutPressed:(UIButton *)logOut {
    [UserController sharedInstance].currentUser = nil;
    [self toggleDrawer];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FollowingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.selectedViewController = self.childViewControllers[1];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Advertisement

- (void)chooseCampaign {
    CampaignController *campaignController = [CampaignController sharedInstance];
    [campaignController  selectRandomCampaign];
    [self.campaignAdButton setImage:campaignController.currentCampaign.bannerAd forState:UIControlStateNormal];
    if (self.campaignAdButton.imageView.image) {
        [campaignController incrementViewsWithAdType:@"B"];
    }
}

- (void)setUpCampaignAd {
    self.campaignAdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.campaignAdButton];
    //self.campaignAdButton.frame = CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50);
    [self.campaignAdButton alignLeadingEdgeWithView:self.view predicate:@"0"];
    [self.campaignAdButton alignTrailingEdgeWithView:self.view predicate:@"0"];
    [self.campaignAdButton alignBottomEdgeWithView:self.view predicate:@"-44"];
    [self.campaignAdButton constrainHeight:@"50"];
    
    [self.campaignAdButton addTarget:self action:@selector(campaignAdButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.campaignAdButton.hidden = YES;
}

- (void)campaignAdButtonPressed {
 
    CampaignAdViewController *campaignAdViewController = [CampaignAdViewController new];
    CampaignController *campaignController = [CampaignController sharedInstance];
    campaignAdViewController.campaignAdImageView = [[UIImageView alloc] initWithImage:campaignController.currentCampaign.fullScreenAd];
    
    UIViewController *vc = self.childViewControllers[1];
    [vc presentViewController:campaignAdViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
    } else {
        // contact
        NSLog(@"contact");
        [self openEmailComposer];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 20;
    }
    
    return 0.0000000000000000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000000000000000001f;
}

#pragma mark - Email Composer

- (void)openEmailComposer {
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    composer.mailComposeDelegate = self;
    [composer setToRecipients:@[@"woottechonolgies@gmail.com"]];
    
    UIViewController *vc = self.childViewControllers[1];
    [vc presentViewController:composer animated:YES completion:^{
  //      [self toggleDrawer];
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:self completion:nil];
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
