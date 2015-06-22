//
//  CustomTabBarVC.m
//  wootApp
//
//  Created by Cole Wilkes on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CustomTabBarVC.h"
#import "DrawerDataSource.h"

@interface CustomTabBarVC () <UITabBarControllerDelegate, UITableViewDelegate>

@property (nonatomic, strong) UITableView *drawer;
@property (nonatomic, strong) UIButton *drawerButton;
@property (nonatomic, strong) DrawerDataSource *dataSource;

@end

@implementation CustomTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.hidden = YES;
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44.0)];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemTapped:)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *selfItem = [[UIBarButtonItem alloc] initWithTitle:@"self" style:UIBarButtonItemStylePlain target:self action:@selector(selfItemTapped:)];
    
    [toolBar setItems:@[flexibleSpace, searchItem, flexibleSpace, selfItem, flexibleSpace]];
    [self.view addSubview:toolBar];
    
    self.drawerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.drawerButton.enabled = NO;
    self.drawerButton.backgroundColor = [UIColor blackColor];
    self.drawerButton.alpha = 0.0;
    [self.drawerButton addTarget:self action:@selector(toggleDrawer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.drawerButton];

    self.drawer = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width  * 2 / 3, self.view.frame.size.height + toolBar.frame.size.height) style:UITableViewStyleGrouped];
    self.dataSource = [[DrawerDataSource alloc] init];
    [self.dataSource registerTableView:self.drawer viewController:self];
    self.drawer.dataSource = self.dataSource;
    self.drawer.delegate = self;
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"football.png"]];
    headerImageView.frame = CGRectMake(0, 0, self.drawer.frame.size.width, 150);
    self.drawer.tableHeaderView = headerImageView;
    self.drawer.backgroundColor = [UIColor whiteColor];
    self.drawer.hidden = YES;
    [self.view addSubview:self.drawer];
}

- (void)searchItemTapped:(UIBarButtonItem *)searchItem {
    if (!self.drawer.hidden) {
        [self toggleDrawer];
    }
}

- (void)selfItemTapped:(UIBarButtonItem *)selfItem {
    
    [self toggleDrawer];
}

- (void)toggleDrawer {
    if (self.drawer.hidden) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            self.drawer.center = CGPointMake(self.view.frame.size.width - self.drawer.frame.size.width / 2, self.drawer.center.y);
            self.drawerButton.alpha = 0.4;
        }];
        self.drawer.hidden = NO;
        self.drawerButton.enabled = YES;
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:0.3 animations:^{
            self.drawer.center = CGPointMake(self.view.frame.size.width + self.drawer.frame.size.width / 2, self.drawer.center.y);
            self.drawerButton.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.drawer.hidden = YES;
                self.drawerButton.enabled = NO;
            }
        }];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
