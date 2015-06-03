//
//  TeamViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamController.h"
#import "SchoolController.h"

@interface TeamViewController ()

@property (nonatomic, strong) UIView *header;

@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 150)];
    [self.view addSubview:self.header];
    [self setupHeader];
    
    [TeamController sharedInstance];
}

- (void)setupHeader {
    SchoolController *schoolController = [SchoolController sharedInstance];
    TeamController *teamController = [TeamController sharedInstance];
    
    self.header.backgroundColor = [UIColor blueColor];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:schoolController.currentSchool.logo];
    logoView.frame = CGRectMake(0, 0, 100, 100);
    logoView.center = CGPointMake(self.header.frame.size.width / 5, self.header.frame.size.height / 2);
    [self.header addSubview:logoView];
    
    UILabel *schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 15, 250, 20)];
    schoolLabel.text = schoolController.currentSchool.name;
    schoolLabel.textColor = [UIColor whiteColor];
    [self.header addSubview:schoolLabel];
    
    UILabel *mascottLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 40, 100, 15)];
    mascottLabel.text = schoolController.currentSchool.mascott;
    mascottLabel.textColor = [UIColor whiteColor];
    mascottLabel.font = [UIFont systemFontOfSize:13.0];
    [self.header addSubview:mascottLabel];
    
    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 75, 100, 15)];
    recordLabel.text = teamController.currentTeam.record;
    recordLabel.textColor = [UIColor whiteColor];
    //recordLabel.font = [UIFont systemFontOfSize:13.0];
    [self.header addSubview:recordLabel];
    
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
