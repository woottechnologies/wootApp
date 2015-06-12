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
    
    self.homeTeamView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.homeTeamView.frame = CGRectMake(0, 0, self.view.frame.size.width, teamViewHeight);
    self.homeTeamView.backgroundColor = [UIColor blueColor];
    self.homeTeamView.tag = 0;
    [self.homeTeamView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeTeamView];
    
    self.awayTeamView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.awayTeamView.frame = CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, teamViewHeight);
    self.awayTeamView.backgroundColor = [UIColor redColor];
    self.awayTeamView.tag = 1;
    [self.awayTeamView addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.awayTeamView];
    
    self.scoreBoardView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.scoreBoardView.frame = CGRectMake(self.view.frame.size.width / 2 - 100, self.view.frame.size.height / 2 - 50, 200, 100);
    self.scoreBoardView.backgroundColor = [UIColor whiteColor];
    self.scoreBoardView.tag = 2;
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
    self.scoreLabel.text = self.game.currentScore;
}

- (void)buttonPressed:(UIButton *)button {
    GameController *gameController = [GameController sharedInstance];
    TeamViewController *teamVC = [[TeamViewController alloc] init];
    
    if (button.tag == 0) {
        // home team
        [TeamController sharedInstance].currentTeam = gameController.currentGame.homeTeam;
        [self.navigationController pushViewController:teamVC animated:YES];
    } else if (button.tag == gameController.currentGame.awayTeam.teamID) {
        // away team
        [TeamController sharedInstance].currentTeam = gameController.currentGame.awayTeam;
        [self.navigationController pushViewController:teamVC animated:YES];
    } else {
        // score board
        NSLog(@"score board");
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
