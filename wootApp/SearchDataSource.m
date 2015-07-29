//
//  SchoolListDataSource.m
//  wootApp
//
//  Created by Cole Wilkes on 6/18/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SearchDataSource.h"
#import "SearchController.h"
#import "SearchTableViewCell.h"

static NSString *cellID = @"cellID";

@implementation SearchDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    SearchController *searchController = [SearchController sharedInstance];
    if (searchController.selectedSegmentIndex == 0) {
        if (searchController.teams.count > 0) {
            NSDictionary *team = [searchController.teams objectAtIndex:indexPath.row];
            cell.textLabel.text = team[@"teamName"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@, %@)", team[@"schoolName"], team[@"city"], team[@"state"]];
        } else if (searchController.isSearching == YES){
            cell.textLabel.text = @"Searching...";
            cell.detailTextLabel.text = @"";
        } else {
            cell.textLabel.text = @"No results found";
            cell.detailTextLabel.text = @"";
        }
        
    } else if (searchController.selectedSegmentIndex == 1) {
        if (searchController.people.count > 0) {
            NSDictionary *person = [searchController.people objectAtIndex:indexPath.row];
            cell.textLabel.text = person[@"name"];
            cell.detailTextLabel.text = person[@"teamName"];
        } else if (searchController.isSearching == YES){
            cell.textLabel.text = @"Searching...";
            cell.detailTextLabel.text = @"";
        } else {
            cell.textLabel.text = @"No results found";
            cell.detailTextLabel.text = @"";
        }
    }
    searchController.isSearching = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchController *searchController = [SearchController sharedInstance];
    if (searchController.hasSearched == NO) {
        return 0;
    } else if (searchController.selectedSegmentIndex == 0) {
        if (searchController.teams.count > 0 || searchController.hasSearched == NO){
            return searchController.teams.count;
        } else {
            return 1;
        }
    } else if (searchController.selectedSegmentIndex == 1) {
        if (searchController.people.count > 0 || searchController.hasSearched == NO){
            return searchController.people.count;
        } else {
            return 1;
        }
    }
    return 0;
}

@end
