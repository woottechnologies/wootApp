//
//  GameViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/10/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "GameViewController.h"
#import "GameController.h"

@interface GameViewController ()

@property (nonatomic, strong) UIView *homeTeamView;
@property (nonatomic, strong) UIView *awayTeamView;
@property (nonatomic, strong) UIView *scoreBoardView;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) Game *game; // temporary

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    NSDictionary *dict = @{GameIDKey:@1, DateKey:@"2015-08-23", HomeScoreKey:@4, AwayScoreKey:@1};
    self.game = [[Game alloc] initWithDictionary:dict];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateScoreBoard];
}

- (void)setupViews {
    CGFloat teamViewHeight = self.view.frame.size.height / 2;
    
    self.homeTeamView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, teamViewHeight)];
    self.homeTeamView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.homeTeamView];
    
    self.awayTeamView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, teamViewHeight)];
    self.awayTeamView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.awayTeamView];
    
    self.scoreBoardView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 50, 200, 100)];
    self.scoreBoardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scoreBoardView];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scoreBoardView.frame.size.width / 2 - 95, self.scoreBoardView.frame.size.height / 2 - 45, 190, 90)];
    self.scoreLabel.font = [UIFont systemFontOfSize:21.0];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.backgroundColor = [UIColor blackColor];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.scoreBoardView addSubview:self.scoreLabel];
}

- (void)updateScoreBoard {
    self.scoreLabel.text = self.game.currentScore;
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
