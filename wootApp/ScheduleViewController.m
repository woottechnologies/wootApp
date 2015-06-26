//
//  ScheduleViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/10/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "ScheduleViewController.h"
#import "PreviousGameTableViewCell.h"
#import "NextGameTableViewCell.h"
#import "TeamController.h"
#import "GameViewController.h"
#import "GameController.h"
#import "TeamViewController.h"

static NSString *previousGameCellID = @"previousGameCellID";
static NSString *nextGameCellID = @"nextGameCellID";

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"loaded scheduleVC");
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self registerTableView:self.tableView];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerTableView:(UITableView *)tableView {
    self.tableView = tableView;
    [self.tableView registerClass:[PreviousGameTableViewCell class] forCellReuseIdentifier:previousGameCellID];
    [self.tableView registerClass:[NextGameTableViewCell class] forCellReuseIdentifier:nextGameCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamController *teamController = [TeamController sharedInstance];
    GameController *gameController = [GameController sharedInstance];
    UITableViewCell *cell;
    if (indexPath.row < gameController.previousGames.count){
        cell = [tableView dequeueReusableCellWithIdentifier:previousGameCellID];
        if (teamController.currentTeam.schedule) {
            [((PreviousGameTableViewCell *)cell) setUpCell:gameController.previousGames[indexPath.row]];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:nextGameCellID];
        if (teamController.currentTeam.schedule) {
            [((NextGameTableViewCell *)cell) setUpCell:gameController.upcomingGames[indexPath.row - gameController.previousGames.count]];
        }
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TeamController *teamController = [TeamController sharedInstance];
    return teamController.currentTeam.schedule.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamController *teamController = [TeamController sharedInstance];
    GameController *gameController = [GameController sharedInstance];
    GameViewController *gameVC = [[GameViewController alloc] init];
    
    gameController.currentGame = [teamController.currentTeam.schedule objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:gameVC animated:YES];
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
