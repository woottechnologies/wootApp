//
//  ScheduleViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/10/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleTableViewCell.h"
#import "TeamController.h"

static NSString *scheduleCellID = @"scheduleCellID";

@interface ScheduleViewController () <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamController *teamController = [TeamController sharedInstance];
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scheduleCellID];
    if (!cell){
        NSArray *schedule = teamController.currentTeam.schedule;
//        cell = [[ScheduleTableViewCell alloc] initWithGame:schedule[indexPath.row] style:UITableViewCellStyleDefault reuseIdentifier:scheduleCellID];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TeamController *teamController = [TeamController sharedInstance];
    return teamController.currentTeam.schedule.count;
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
