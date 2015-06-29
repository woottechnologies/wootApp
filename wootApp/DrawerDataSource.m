//
//  DrawerDataSource.m
//  wootApp
//
//  Created by Cole Wilkes on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "DrawerDataSource.h"
#import "UserController.h"

static NSString *cellID = @"cellID";

@interface DrawerDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) CustomTabBarVC *viewController;

@end

@implementation DrawerDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(CustomTabBarVC *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    NSDictionary *fav;
    
    switch (indexPath.section){
            
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            fav = [[UserController sharedInstance].currentUser.favorites objectAtIndex:indexPath.row];
            cell.textLabel.text = [fav objectForKey:FavNameKey];
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.textLabel.text = @"Contact Woot";
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [UserController sharedInstance].currentUser.favorites.count;
            break;
            
        default:
            return 1;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
