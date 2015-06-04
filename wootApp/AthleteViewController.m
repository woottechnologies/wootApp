//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "AthleteViewController.h"
#import "AthleteDataSource.h"


@interface AthleteViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AthleteDataSource *dataSource;

@end

@implementation AthleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 214, self.view.frame.size.width, self.view.frame.size.height - 214) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.dataSource = [AthleteDataSource new];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end