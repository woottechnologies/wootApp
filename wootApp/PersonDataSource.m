//
//  PersonDataSource.m
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PersonDataSource.h"
#import "PersonTweetCell.h"
#import "PersonController.h"
#import "PersonTweetController.h"

static NSString *personTwitterCellID = @"twitterCellID";

@interface PersonDataSource()

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) PersonViewController *viewController;

@end


@implementation PersonDataSource

- (void)registerTableView:(UITableView *)tableView viewController:(PersonViewController *)viewController {
    self.tableView = tableView;
    self.viewController = viewController;
    [self.tableView registerClass:[PersonTweetCell class] forCellReuseIdentifier:personTwitterCellID];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    Person *currentPerson = [PersonController sharedInstance].currentPerson;
    PersonTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:personTwitterCellID];
    PersonTweetController *personTweetController = [PersonTweetController sharedInstance];
//    if ([personTweetController.handle isEqualToString:currentPerson.twitter] && personTweetController.tweets.count > indexPath.row) {
//        TWTRTweet *tweet = personTweetController.tweets[indexPath.row];
//        [cell setUpTweetCell:tweet];
//        
//    }
return [UITableViewCell new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *numberOfRowsPerSection = @[@0, @0, @0, @0];
    return [numberOfRowsPerSection[section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)descriptionLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(320, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height;
}


@end
