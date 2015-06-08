//
//  TeamDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 6/4/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamDataSource.h"
#import "TeamController.h"
#import "TeamViewController.h"

static NSString *mostViewedPlayerCellID = @"mostViewedPlayerCellID";

@interface TeamDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) TeamViewController *viewController;

@end

@implementation TeamDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(TeamViewController *)viewController
{
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[MostViewedPlayersTableViewCell class] forCellReuseIdentifier:mostViewedPlayerCellID];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
       switch (indexPath.section){
            
        case 0:
               cell = [tableView dequeueReusableCellWithIdentifier:mostViewedPlayerCellID];
//               if (cell == nil) {
//                   cell = [[MostViewedPlayersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mostViewedPlayerCellID];
//               }
               
               ((MostViewedPlayersTableViewCell *)cell).delegate = self.viewController;
            
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
            
            
    }
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *numberOfRowsPerSection = @[@1, @0, @0, @0];
    return [numberOfRowsPerSection[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray *sections = @[@"Top Players", @"News", @"Pictures", @"Videos"];
    return sections[section];
}

-(CGFloat)descriptionLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height;
}


@end
