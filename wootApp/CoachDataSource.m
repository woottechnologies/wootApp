//
//  CoachDataSource.m
//  wootApp
//
//  Created by Cole Wilkes on 7/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "CoachDataSource.h"
#import "TeamController.h"

static NSString *cellID = @"cellID";

@implementation CoachDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    Coach *coach = [[TeamController sharedInstance].currentTeam.coaches objectAtIndex:indexPath.row];
    
    cell.textLabel.text = coach.name;
    cell.detailTextLabel.text = coach.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
