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

@interface SchoolListViewController ()

@end

@implementation SchoolListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SchoolController sharedInstance];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *teamButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    teamButton.frame = CGRectMake(self.view.frame.size.width / 2 - 25, 100, 50, 30);
    [teamButton setTitle:@"Team" forState:UIControlStateNormal];
    [teamButton addTarget:self action:@selector(teamButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:teamButton];
}

- (void)teamButtonPressed:(UIButton *)button {
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
