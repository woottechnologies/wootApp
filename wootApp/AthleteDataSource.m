//
//  AthleteDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "AthleteDataSource.h"
#import "TeamController.h"
#import "Athlete.h"
#import "SummaryStatsTableViewCell.h"
#import "AthleteController.h"
#import "TeamTweetCell.h"
#import "AthleteTweetController.h"

typedef NS_ENUM(int16_t, AthleteDataSourceSection){
    StatsSection = 0,
    TwitterSection = 1,
    PicturesSection = 2,
    VideosSection = 3
};

static NSString *cellID = @"cellID";
static NSString *summaryStatsCellID = @"summaryStatsCellID";
static NSString *bioCellID = @"bioCellID";
static NSString *athleteTwitterCellID = @"athleteTwitterCellID";

@interface AthleteDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) AthleteViewController *viewController;

@end


@implementation AthleteDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(AthleteViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[SummaryStatsTableViewCell class] forCellReuseIdentifier:summaryStatsCellID];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:bioCellID];
    [self.tableView registerClass:[TeamTweetCell class] forCellReuseIdentifier:athleteTwitterCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Athlete *currentAthlete = [AthleteController sharedInstance].currentAthlete;
    switch (indexPath.section){
            
        case StatsSection:
        {
            SummaryStatsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:summaryStatsCellID];
            //NSArray *athletes = teamController.currentTeam.athletes;
            if (currentAthlete.stats) {
                [cell loadDataWithStats:[currentAthlete.stats summaryStats]];
                return cell;
            }
        }
        case TwitterSection:
        {
            TeamTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:athleteTwitterCellID];
            AthleteTweetController *athleteTweetController = [AthleteTweetController sharedInstance];
            if ([athleteTweetController.athleteHandle isEqualToString:currentAthlete.twitter] && athleteTweetController.tweets.count > indexPath.row) {
                TWTRTweet *tweet = athleteTweetController.tweets[indexPath.row];
                [cell setUpTweetCell:tweet];
            }
        }
    }
    
    return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *numberOfRowsPerSection = @[@1, @0, @0, @0];
    return [numberOfRowsPerSection[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    Athlete *currentAthlete = [AthleteController sharedInstance].currentAthlete;
    if(currentAthlete.statType != 7){
        return 1;
    } else {
        return 0;
    }
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSArray *sections = @[@"Stats", @"Bio", @"Pictures", @"Videos"];
//    return sections[section];
//}

-(CGFloat)descriptionLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height;
}

@end


