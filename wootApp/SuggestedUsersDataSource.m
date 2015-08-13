//
//  SuggestedUsersDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 8/10/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SuggestedUsersDataSource.h"
#import "SearchTableViewCell.h"
#import "SearchController.h"

static NSString *cellID = @"suggestedUsersCellID";

@interface SuggestedUsersDataSource () 

@end

@implementation SuggestedUsersDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    SearchController *searchController = [SearchController sharedInstance];
    
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
    
    searchController.isSearching = NO;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SearchController *searchController = [SearchController sharedInstance];
    if (searchController.hasSearched == NO) {
        return 0;
    } else if (searchController.people.count > 0){
        return searchController.people.count;
    } else {
        return 1;
    }
    return 0;
}

@end
