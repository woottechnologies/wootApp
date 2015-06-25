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

@interface SchoolListViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SchoolListDataSource *dataSource;

@end

@implementation SchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SchoolController sharedInstance];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.dataSource = [[SchoolListDataSource alloc] init];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    [[SchoolController sharedInstance] loadSchoolsFromDatabaseWithCompletion:^(BOOL success) {
        if (success) {
            //Updating UI must occur on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"loading schools worked");
                [self.tableView reloadData];
            });
        }
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
