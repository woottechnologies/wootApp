//
//  DrawerDataSource.m
//  wootApp
//
//  Created by Cole Wilkes on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "DrawerDataSource.h"

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
    
    switch (indexPath.row){
            
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.textLabel.text = @"Favorites";
            break;
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.textLabel.text = @"Contact Woot";
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

@end
