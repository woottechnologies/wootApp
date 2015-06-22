//
//  SchoolListDataSource.m
//  wootApp
//
//  Created by Cole Wilkes on 6/18/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SchoolListDataSource.h"
#import "SchoolController.h"

static NSString *cellID = @"cellID";

@implementation SchoolListDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    SchoolController *schoolController = [SchoolController sharedInstance];
    School *school = [schoolController.schools objectAtIndex:indexPath.row];
    cell.textLabel.text = school.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SchoolController sharedInstance].schools.count;
}

@end
