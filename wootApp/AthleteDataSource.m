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

typedef NS_ENUM(int16_t, AthleteDataSourceSection){
    StatsSection = 0,
    BioSection = 1,
    PicturesSection = 2,
    VideosSection = 3
};

static NSString *cellID = @"cellID";
static NSString *summaryStatsCellID = @"summaryStatsCellID";
static NSString *bioCellID = @"bioCellID";

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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    Athlete *currentAthlete = [AthleteController sharedInstance].currentAthlete;
    switch (indexPath.section){
            
        case StatsSection:
            cell = [tableView dequeueReusableCellWithIdentifier:summaryStatsCellID];
            //NSArray *athletes = teamController.currentTeam.athletes;
            if (currentAthlete.stats) {
                [((SummaryStatsTableViewCell *)cell) loadDataWithStats:[currentAthlete.stats summaryStats]];
            }
            break;
        case BioSection:
            //if (currentAthlete.bio) {
            //cell.textLabel.text = currentAthlete.bio;
            //}
            //cell.textLabel.text = currentAthlete.bio;
           // cell.frame = CGRectMake(0, 0, 320, 200);
            //      cell.textLabel.frame = CGRectMake(0, 0, 320, 100);
            cell.textLabel.numberOfLines = 0;
            //NSLog(@"%@", currentAthlete.bio);
            break;
        case PicturesSection:
            break;
        case VideosSection:
            break;
            
            
    }
    
    return cell;
    
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


