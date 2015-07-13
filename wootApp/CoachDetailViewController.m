//
//  CoachingStaffViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/29/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CoachDetailViewController.h"
#import "CoachDataSource.h"
#import "TeamController.h"
#import "SchoolController.h"

@interface CoachDetailViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CoachDataSource *dataSource;
@property (nonatomic, strong) UIButton *screenButton;
@property (nonatomic, strong) UIView *coachView;
@property (nonatomic, strong) UILabel *teamLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UIImageView *coachImageView;

@end

@implementation CoachDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationController.navigationBar.topItem.title = @"Coaches";
    
    UIImage *backArrow = [UIImage imageNamed:@"back_arrow.png"];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    [backButton setBackgroundImage:backArrow forState:UIControlStateNormal];
    backButton.alpha = 0.5;
    [backButton addTarget:self action:@selector(backButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backArrowButton =[[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backArrowButton;
    
    self.dataSource = [[CoachDataSource alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    
//    UIImageView *tableViewHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    tableViewHeader.image = [TeamController sharedInstance].currentTeam.coachingStaffPhoto;
//    self.tableView.tableHeaderView = tableViewHeader;
    
    [self.view addSubview:self.tableView];
    
    self.screenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.screenButton.frame = self.view.frame;
    self.screenButton.enabled = NO;
    self.screenButton.backgroundColor = [UIColor blackColor];
    self.screenButton.alpha = 0.0;
    [self.screenButton addTarget:self action:@selector(screenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.screenButton];
    
    [self setupCoachView];
}

- (void)setupCoachView {
    self.coachView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 150, 100, 300, 200)];
    self.coachView.backgroundColor = [UIColor whiteColor];
    
    self.coachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 120, 150)];
//    self.coachImageView.backgroundColor = [UIColor blueColor];
    [self.coachView addSubview:self.coachImageView];
    
    self.teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coachImageView.frame.size.width + 25, 25, 150, 30)];
//    self.teamLabel.backgroundColor = [UIColor blueColor];
    [self.coachView addSubview:self.teamLabel];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coachImageView.frame.size.width + 25, 65, 150, 30)];
//    self.nameLabel.backgroundColor = [UIColor blueColor];
    [self.coachView addSubview:self.nameLabel];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coachImageView.frame.size.width + 25, 100, 150, 30)];
//    self.titleLabel.backgroundColor = [UIColor blueColor];
    [self.coachView addSubview:self.titleLabel];
    
    self.emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.coachImageView.frame.size.width + 25, 135, 150, 30)];
//    self.emailLabel.backgroundColor = [UIColor blueColor];
    [self.coachView addSubview:self.emailLabel];
    
    [self.view addSubview:self.coachView];
    self.coachView.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Coach *coach = [[TeamController sharedInstance].currentTeam.coaches objectAtIndex:indexPath.row];
    
    self.screenButton.alpha = 0.5;
    self.screenButton.enabled = YES;
    
    self.coachImageView.image = coach.photo;
    self.teamLabel.text = [TeamController sharedInstance].currentTeam.teamName;
    self.nameLabel.text = coach.name;
    self.titleLabel.text = coach.title;
    //self.emailLabel.text = coach.email;
    
    self.coachView.hidden = NO;
}

- (void)screenButtonPressed:(UIButton *)button {
    self.screenButton.alpha = 0.0;
    self.screenButton.enabled = NO;
    
    self.coachView.hidden = YES;
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
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
