//
//  EditUserViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 8/10/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "EditUserViewController.h"
#import "UIView+FLKAutoLayout.h"
#import "EditDataSource.h"
#import "UsernameEditVC.h"
#import "PasswordEditVC.h"
#import "EmailEditVC.h"

@interface EditUserViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EditDataSource *dataSource;

@end

@implementation EditUserViewController

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    self.navigationItem.title = @"Edit Profile";
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
//    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
//    backButton.alpha = 0.5;
//    [backButton addTarget:self action:@selector(backButtonPressed:)
//         forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backArrowButton;
    
    UIImage *exitImage = [UIImage imageNamed:@"button_x.png"];
    UIButton *exit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [exit setBackgroundImage:exitImage forState:UIControlStateNormal];
    exit.alpha = 0.5;
    [exit addTarget:self action:@selector(exitButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *exitButton =[[UIBarButtonItem alloc] initWithCustomView:exit];
    self.navigationItem.leftBarButtonItem = exitButton;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.dataSource = [[EditDataSource alloc] init];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}

- (void)exitButtonPressed:(UIButton *)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UsernameEditVC *usernameVC = [[UsernameEditVC alloc] init];
            [self.navigationController pushViewController:usernameVC animated:YES];
        } else {
            PasswordEditVC *passwordVC = [[PasswordEditVC alloc] init];
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
    } else {
        EmailEditVC *emailVC = [[EmailEditVC alloc] init];
        [self.navigationController pushViewController:emailVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    UILabel *headerTextLabel = [[UILabel alloc] init];
    [headerView addSubview:headerTextLabel];
    
    [headerTextLabel alignTop:@"10" leading:@"10" toView:headerView];
    [headerTextLabel alignBottomEdgeWithView:headerView predicate:@"-10"];
    [headerTextLabel constrainWidth:@"200"];
    
    if (section == 0) {
        headerTextLabel.text = @"My Profile";
    } else {
        headerTextLabel.text = @"Private Information";
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000000000000000001f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
