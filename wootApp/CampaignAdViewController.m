//
//  CampaignAdViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CampaignAdViewController.h"
#import "CampaignController.h"

@interface CampaignAdViewController ()

@end

@implementation CampaignAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.campaignAdImageView.frame = self.view.frame;
    [self.view addSubview:self.campaignAdImageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(280, 30, 70, 30);
    button.backgroundColor = [UIColor whiteColor];
    
    [button setTitle:@"Close" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    if (self.campaignAdImageView.image) {
        [[CampaignController sharedInstance] incrementViewsWithAdType:@"F"];
    }
}

- (void)buttonPressed:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
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
