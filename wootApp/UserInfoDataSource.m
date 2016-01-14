//
//  UserInfoDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 8/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "UserInfoDataSource.h"
#import "PersonInfoCell.h"
#import "UserController.h"

static NSString *personInfoCellID = @"infoCellID";

@interface UserInfoDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UserProfileViewController *viewController;

@end

@implementation UserInfoDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(UserProfileViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[PersonInfoCell class] forCellReuseIdentifier:personInfoCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:personInfoCellID];
    UserController *userController = [UserController sharedInstance];
    switch (indexPath.row) {
        case 0:
            if (!cell){
                cell = [[PersonInfoCell alloc] initWithInfoType:@"Name" infoValue:userController.currentUser.name style:UITableViewCellStyleDefault reuseIdentifier:personInfoCellID];
            } else {
                [cell setUpCellWithInfoType:@"Name" infoValue:userController.currentUser.name];
            }
            break;
//        case 1:
//            if (!cell){
//                cell = [[PersonInfoCell alloc] initWithInfoType:@"Views" infoValue:[NSString stringWithFormat:@"%ld",(long)userController.currentUser.] style:UITableViewCellStyleDefault reuseIdentifier:personInfoCellID];
//            } else {
//                [cell setUpCellWithInfoType:@"Views" infoValue:[NSString stringWithFormat:@"%ld",(long)personController.currentPerson.views]];
//            }
//            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
