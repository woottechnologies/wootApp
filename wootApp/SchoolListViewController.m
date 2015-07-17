//
//  ViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/2/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SchoolListViewController.h"
#import "TeamViewController.h"
#import "SchoolController.h"
#import "TeamController.h"
#import "SchoolListDataSource.h"
#import "AppDelegate.h"
#import "CustomTabBarVC.h"
#import "UIColor+CreateMethods.h"

@interface SchoolListViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SchoolListDataSource *dataSource;
@property (nonatomic, strong) CustomTabBarVC *customTBVC;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.customTBVC = (CustomTabBarVC *)appD.window.rootViewController;
    
    [SchoolController sharedInstance];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, self.navigationController.navigationBar.frame.size.height - 15, self.view.frame.size.width - 40, 30)];
    self.searchBar.placeholder = @"Search";
    self.navigationItem.titleView = self.searchBar;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.dataSource = [[SchoolListDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
//    [[SchoolController sharedInstance] loadSchoolsFromDatabaseWithCompletion:^(BOOL success) {
//        if (success) {
//            //Updating UI must occur on main thread
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"loading schools worked");
//                [self.tableView reloadData];
//            });
//        }
//    }];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = YES;
    
//    UIView *statusBarStripe = [[UIView alloc] init];
//    statusBarStripe.backgroundColor = [UIColor whiteColor];
//    statusBarStripe.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
//    [self.view addSubview:statusBarStripe];

}

//- (void)backButtonPressed {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:@"#1a1c1c" alpha:1.0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.customTBVC.campaignAdButton.hidden = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   // SchoolController *schoolController = [SchoolController sharedInstance];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [SchoolController sharedInstance].currentSchool = [[SchoolController sharedInstance].schools objectAtIndex:indexPath.row];
    
    TeamViewController *teamVC = [[TeamViewController alloc] init];
    [[TeamController sharedInstance] loadTeamsFromDBWithCompletion:^(BOOL success) {
        if (success) {
            NSLog(@"Loaded teams from DB successfully");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:teamVC animated:YES];
            });
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.width/3.538;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
