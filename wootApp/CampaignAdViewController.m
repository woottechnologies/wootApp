//
//  CampaignAdViewController.m
//  wootApp
//
//  Created by Egan Anderson on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CampaignAdViewController.h"
#import "CampaignController.h"
#import "UIView+FLKAutoLayout.h"

@interface CampaignAdViewController ()

@end

@implementation CampaignAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.campaignAdImageView.frame = self.view.frame;
    [self.view addSubview:self.campaignAdImageView];
    
    // exit button
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:exitButton];
    [exitButton alignTopEdgeWithView:self.view predicate:@"30"];
    [exitButton alignTrailingEdgeWithView:self.view predicate:@"-30"];
    [exitButton constrainHeight:@"20"];
    [exitButton constrainWidth:@"20"];
    [exitButton setImage:[UIImage imageNamed:@"button_x.png"] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(exitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    if (self.campaignAdImageView.image) {
        [[CampaignController sharedInstance] incrementViewsWithAdType:@"F"];
    }
}

- (void)exitButtonPressed:(UIButton *)button {
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
