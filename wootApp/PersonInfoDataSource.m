//
//  PersonInfoDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 8/19/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PersonInfoDataSource.h"
#import "PersonInfoCell.h"
#import "PersonController.h"

static NSString *personInfoCellID = @"infoCellID";

@interface PersonInfoDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PersonViewController *viewController;

@end

@implementation PersonInfoDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(PersonViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[PersonInfoCell class] forCellReuseIdentifier:personInfoCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:personInfoCellID];
    PersonController *personController = [PersonController sharedInstance];
    switch (indexPath.row) {
        case 0:
            if (!cell){
                cell = [[PersonInfoCell alloc] initWithInfoType:@"Name" infoValue:personController.currentPerson.name style:UITableViewCellStyleDefault reuseIdentifier:personInfoCellID];
            } else {
                [cell setUpCellWithInfoType:@"Name" infoValue:personController.currentPerson.name];
            }
            break;
        case 1:
            if (!cell){
                cell = [[PersonInfoCell alloc] initWithInfoType:@"Views" infoValue:[NSString stringWithFormat:@"%ld",(long)personController.currentPerson.views] style:UITableViewCellStyleDefault reuseIdentifier:personInfoCellID];
            } else {
                [cell setUpCellWithInfoType:@"Views" infoValue:[NSString stringWithFormat:@"%ld",(long)personController.currentPerson.views]];
            }
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

@end
