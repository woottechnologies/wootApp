//
//  TeamDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 6/4/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamDataSource.h"
#import "TeamController.h"
#import "TeamViewController.h"
#import "PreviousGameTableViewCell.h"
#import "NextGameTableViewCell.h"
#import "CoachingStaffCell.h"
#import "TeamTweetCell.h"
#import "TeamTweetController.h"



typedef NS_ENUM(int16_t, AthleteDataSourceSection){
    TopPlayersSection = 0,
    ScheduleSection = 1,
    CoachesSection = 2,
    //PicturesSection = 2,
    TweetSection = 3
};

static NSString *mostViewedPlayerCellID = @"mostViewedPlayerCellID";
static NSString *scheduleCellID = @"scheduleCellID";
static NSString *nextGameCellID = @"nextGameCellID";
static NSString *normalCellID = @"normalCellID";
static NSString *coachingStaffCellID = @"coachingStaffCellID";
static NSString *teamTweetCellID = @"teamTweetCellID";

@interface TeamDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TeamViewController *viewController;

@end

@implementation TeamDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(TeamViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[MostViewedPlayersTableViewCell class] forCellReuseIdentifier:mostViewedPlayerCellID];
    [self.tableView registerClass:[PreviousGameTableViewCell class] forCellReuseIdentifier:scheduleCellID];
    [self.tableView registerClass:[NextGameTableViewCell class] forCellReuseIdentifier:nextGameCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:normalCellID];
    [self.tableView registerClass:[CoachingStaffCell class] forCellReuseIdentifier:coachingStaffCellID];
    [self.tableView registerClass:[TeamTweetCell class] forCellReuseIdentifier:teamTweetCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamController *teamController = [TeamController sharedInstance];
    GameController *gameController = [GameController sharedInstance];
    UITableViewCell *cell;
//    MostViewedPlayersTableViewCell *cell;
       switch (indexPath.section){
            
        case TopPlayersSection:
               cell = [tableView dequeueReusableCellWithIdentifier:mostViewedPlayerCellID];
               //NSArray *athletes = teamController.currentTeam.athletes;
               if (teamController.currentTeam.athletes) {
                   [((MostViewedPlayersTableViewCell *)cell) loadDataWithAthletes:[teamController mostViewedAthletes]];
               }
               ((MostViewedPlayersTableViewCell *)cell).delegate = self.viewController;
            break;
        case ScheduleSection:
               switch (indexPath.row){
                   case 0:
                       cell = [tableView dequeueReusableCellWithIdentifier:scheduleCellID];
                       if (teamController.currentTeam.schedule) {
                           [((PreviousGameTableViewCell *)cell) setUpCell:[gameController previousGame]];
                       } else {
                           cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
                           cell.textLabel.text = @"No Schedule Information is Available";
                       }
//                       cell = [tableView dequeueReusableCellWithIdentifier:@"fullScheduleCellID"];
//                       cell.textLabel.text = [self nextGame].opposingSchool;
                       break;
                   case 1:
//                       cell = [tableView dequeueReusableCellWithIdentifier:scheduleCellID];
//                       if (teamController.currentTeam.schedule) {
//                           [((ScheduleTableViewCell *)cell) setUpCell:[self nextGame]];
//                       }
                       
                       cell = [tableView dequeueReusableCellWithIdentifier:nextGameCellID];
                       if (teamController.currentTeam.schedule) {
                           [((NextGameTableViewCell *)cell) setUpCell:[gameController nextGame]];
                       }
                       break;
               }
            break;
        case CoachesSection:
               cell = [tableView dequeueReusableCellWithIdentifier:coachingStaffCellID];
               
               if (teamController.currentTeam.coaches) {
                   [((CoachingStaffCell *)cell) finishCell];
               }
               ((CoachingStaffCell *)cell).delegate = self.viewController;
            break;
        case TweetSection:
               cell = [tableView dequeueReusableCellWithIdentifier:teamTweetCellID];
               TeamTweetController *teamTweetController = [TeamTweetController sharedInstance];
//               if ([teamTweetController.teamHashtag isEqualToString:teamController.currentTeam.teamHashtag] && teamTweetController.tweets) {
                   [((TeamTweetCell *)cell) setUpCell:teamTweetController.tweets[indexPath.row]];
               break;

    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *numberOfRowsPerSection = @[@1, @2, @1, @5];
    return [numberOfRowsPerSection[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(CGFloat)descriptionLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height;
}


@end
