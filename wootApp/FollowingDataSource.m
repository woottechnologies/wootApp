//
//  FollowingDataSource.m
//  wootApp
//
//  Created by Cole Wilkes on 7/15/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "FollowingDataSource.h"
#import "UserController.h"

static NSString *cellID = @"cellID";

@implementation FollowingDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *accountFollowed = [[UserController sharedInstance].currentUser.following objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [accountFollowed objectForKey:FollowingNameKey];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UserController sharedInstance].currentUser.following.count;
}

@end
