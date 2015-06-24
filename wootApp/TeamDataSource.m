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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:scheduleCellID];
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
               cell = [tableView dequeueReusableCellWithIdentifier:scheduleCellID];
               cell.textLabel.text = @"Full Schedule";
            break;
        case PicturesSection:
            break;
        case VideosSection:
            break;
            
            
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *numberOfRowsPerSection = @[@1, @1, @0, @0];
    return [numberOfRowsPerSection[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *sections = @[@"Top Players", @"Schedule", @"Pictures", @"Videos"];
    return sections[section];
}


-(CGFloat)descriptionLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height;
}


@end
