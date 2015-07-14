//
//  HomeFeedViewController.m
//  wootApp
//
//  Created by Egan Anderson on 7/13/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "HomeFeedViewController.h"
#import "HomeFeedController.h"
#import "HomeFeedDataSource.h"

@interface HomeFeedViewController () <UITableViewDelegate>

@property (nonatomic, strong) HomeFeedDataSource *dataSource;

@end

@implementation HomeFeedViewController

-(void) viewDidLoad{
    [super viewDidLoad];
    
    HomeFeedController* homeFeedController = [HomeFeedController sharedInstance];
    [homeFeedController loadHashtagsFromDBWithCompletion];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTweets) name:@"teamTweetRequestFinished" object:nil];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.dataSource = [HomeFeedDataSource new];
    [self.dataSource registerTableView:self.tableView viewController:self];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)loadTweets {
    [self.tableView reloadData];
}

@end
