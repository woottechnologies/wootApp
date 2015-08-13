//
//  EditDataSource.m
//  wootApp
//
//  Created by Cole Wilkes on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "EditDataSource.h"
#import "UserController.h"

static NSString *cellID = @"cellID";

@interface EditDataSource ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EditUserViewController *vc;

@end

@implementation EditDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(EditUserViewController *)viewController {
    self.tableView = tableView;
    self.vc = viewController;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    // if statement subject to change
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Username\t\t%@", [UserController sharedInstance].currentUser.username];
        } else {
            cell.textLabel.text = @"Password";
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Email\t\t%@", [UserController sharedInstance].currentUser.email];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // subject to change
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

@end
