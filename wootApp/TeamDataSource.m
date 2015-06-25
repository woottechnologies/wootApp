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
#import "ScheduleTableViewCell.h"

typedef NS_ENUM(int16_t, AthleteDataSourceSection){
    TopPlayersSection = 0,
    ScheduleSection = 1,
    PicturesSection = 2,
    VideosSection = 3
};

static NSString *mostViewedPlayerCellID = @"mostViewedPlayerCellID";
static NSString *scheduleCellID = @"scheduleCellID";

@interface TeamDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TeamViewController *viewController;

@end

@implementation TeamDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(TeamViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[MostViewedPlayersTableViewCell class] forCellReuseIdentifier:mostViewedPlayerCellID];
    [self.tableView registerClass:[ScheduleTableViewCell class] forCellReuseIdentifier:scheduleCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fullScheduleCellID"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamController *teamController = [TeamController sharedInstance];
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
                           [((ScheduleTableViewCell *)cell) initWithGame:[self previousGame] style:UITableViewCellStyleDefault reuseIdentifier:scheduleCellID];
                       }
                       break;
                   case 1:
                       cell = [tableView dequeueReusableCellWithIdentifier:scheduleCellID];
                       if (teamController.currentTeam.schedule) {
                           [((ScheduleTableViewCell *)cell) initWithGame:[self nextGame] style:UITableViewCellStyleDefault reuseIdentifier:scheduleCellID];
                       }

                       break;
                   case 2:
                       cell = [tableView dequeueReusableCellWithIdentifier:@"fullScheduleCellID"];
                       cell.textLabel.text = @"Full Schedule";
                       break;
               }
            break;
        case PicturesSection:
            break;
        case VideosSection:
            break;
            
            
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *numberOfRowsPerSection = @[@1, @3, @0, @0];
    return [numberOfRowsPerSection[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *sections = @[@"Top Players", @"Schedule", @"Pictures", @"Videos"];
    return sections[section];
}

//- (UITableView *)tableView

- (Game *)previousGame{
    TeamController *teamController = [TeamController sharedInstance];
    NSMutableArray *previousGames = [[NSMutableArray alloc] init];
    for(Game *game in teamController.currentTeam.schedule){
        if(game.isOver){
            [previousGames addObject:game];
        }
    }
    return [previousGames lastObject];
}

- (Game *)nextGame{
    TeamController *teamController = [TeamController sharedInstance];
    NSMutableArray *upcomingGames = [[NSMutableArray alloc] init];
    for(Game *game in teamController.currentTeam.schedule){
//        NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
//                                                                        value:-7
//                                                                       toDate:[NSDate date]
//                                                                      options:0];
       // if(!game.isOver && [game.date compare:sevenDaysAgo] == NSOrderedDescending){
        if(!game.isOver){
            [upcomingGames addObject:game];
        }
    }
    return [upcomingGames firstObject];
}


-(CGFloat)descriptionLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height;
}


@end
