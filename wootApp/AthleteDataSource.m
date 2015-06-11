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

typedef NS_ENUM(int16_t, AthleteDataSourceSection){
    BioSection = 0,
    StatsSection = 1,
    PicturesSection = 2,
    VideosSection = 3
};

static NSString *cellID = @"cellID";

@implementation AthleteDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    Athlete *currentAthlete = [TeamController sharedInstance].currentAthlete;
    switch (indexPath.section){
            
        case BioSection:
            //if (currentAthlete.bio) {
                //cell.textLabel.text = currentAthlete.bio;
            //}
            //cell.textLabel.text = currentAthlete.bio;
            cell.frame = CGRectMake(0, 0, 320, 200);
            //      cell.textLabel.frame = CGRectMake(0, 0, 320, 100);
            cell.textLabel.numberOfLines = 0;
            //NSLog(@"%@", currentAthlete.bio);
            break;
        case StatsSection:
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
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *sections = @[@"Bio", @"Stats", @"Pictures", @"Videos"];
    return sections[section];
}

-(CGFloat)descriptionLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height;
}

@end


