//
//  GameViewController.m
//  wootApp
//
//  Created by Cole Wilkes on 6/10/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "GameViewController.h"
#import "GameController.h"
#import "TeamViewController.h"
#import "TeamController.h"

@interface GameViewController ()

@property (nonatomic, strong) UIButton *homeTeamView;
@property (nonatomic, strong) UIButton *awayTeamView;
@property (nonatomic, strong) UIButton *scoreBoardView;
@property (nonatomic, strong) UILabel *scoreLabel;

@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateScoreBoard];
}

- (void)setupViews {
    GameController *gameController = [GameController sharedInstance];
    CGFloat availableY = self.view.frame.size.height - 64;
    CGFloat teamViewHeight = availableY / 2;
    
    self.homeTeamView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.homeTeamView.frame = CGRectMake(0, 0, self.view.frame.size.width, teamViewHeight);
    self.homeTeamView.backgroundColor = [UIColor blueColor];
    self.homeTeamView.tag = gameController.currentGame.homeTeamID;
    [self.homeTeamView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeTeamView];
    
    self.awayTeamView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.awayTeamView.frame = CGRectMake(0, availableY / 2, self.view.frame.size.width, teamViewHeight);
    self.awayTeamView.backgroundColor = [UIColor redColor];
    self.awayTeamView.tag = gameController.currentGame.awayTeamID;
    [self.awayTeamView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.awayTeamView];
    
    self.scoreBoardView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.scoreBoardView.frame = CGRectMake(self.view.frame.size.width / 2 - 100, availableY / 2 - 50, 200, 100);
    self.scoreBoardView.backgroundColor = [UIColor whiteColor];
    self.scoreBoardView.tag = 0;
    [self.scoreBoardView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.scoreBoardView];
    
    self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.scoreBoardView.frame.size.width / 2 - 95, self.scoreBoardView.frame.size.height / 2 - 45, 190, 90)];
    self.scoreLabel.font = [UIFont systemFontOfSize:21.0];
    self.scoreLabel.textColor = [UIColor whiteColor];
    self.scoreLabel.backgroundColor = [UIColor blackColor];
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self.scoreBoardView addSubview:self.scoreLabel];
}

- (void)updateScoreBoard {
    GameController *gameController = [GameController sharedInstance];
    self.scoreLabel.text = gameController.currentGame.currentScore;
}

- (void)buttonPressed:(UIButton *)button {
    TeamController *teamController = [TeamController sharedInstance];
    TeamViewController *teamVC = [[TeamViewController alloc] init];
    
    if (button.tag == 0) {
        NSLog(@"score board");
    } else {
        if (button.tag == teamController.currentTeam.teamID) {
            [self.navigationController pushViewController:teamVC animated:YES];
        } else {
            [teamController selectTeamWithTeamID:button.tag andCompletion:^(BOOL success, Team *team) {
                if (success) {
                    teamController.currentTeam = team;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController pushViewController:teamVC animated:YES];
                    });
                }
            }];
        }
    }
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
