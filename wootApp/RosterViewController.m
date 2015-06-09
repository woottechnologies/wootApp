//
//  RosterViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/8/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "RosterViewController.h"
#import "Athlete.h"
#import "TeamController.h"
#import "AthleteViewController.h"

@interface RosterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rosterCellID"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rosterCellID"];
    }
    Athlete *athlete = self.rosterSortedByNumber[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"#%ld    %@", (long)athlete.jerseyNumber, athlete.name];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rosterSortedByNumber.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TeamController *teamController = [TeamController sharedInstance];
    teamController.currentAthlete = self.rosterSortedByNumber[indexPath.row];
    AthleteViewController *athleteVC = [AthleteViewController new];
    [self.navigationController pushViewController:athleteVC animated:YES];
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
