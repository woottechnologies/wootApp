//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "AthleteViewController.h"
#import "AthleteDataSource.h"
#import "TeamController.h"
#import "UIView+FLKAutoLayout.h"


@interface AthleteViewController () <UITableViewDelegate>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AthleteDataSource *dataSource;

@end

@implementation AthleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height - 214) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.dataSource = [AthleteDataSource new];
    self.tableView.dataSource = self.dataSource;
    [self.view addSubview:self.tableView];
    
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [self.view addSubview:self.header];
    [self setupHeader];
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.141 green:0.18 blue:0.518 alpha:1];

    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    [self.navigationController.navigationBar setBarTintColor:backgroundColor];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)setupHeader {
    TeamController *teamController = [TeamController sharedInstance];
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.141 green:0.18 blue:0.518 alpha:1];
    self.header.backgroundColor = backgroundColor;
    
    UIImageView *photo = [[UIImageView alloc] initWithImage:teamController.currentAthlete.photo];
//    photo.frame = CGRectMake(0, 0, 105, 150);
    photo.center = CGPointMake(photo.frame.size.width / 2, self.header.frame.size.height / 2);
    [self.header addSubview:photo];
    [photo alignTop:@"0" leading:@"0" toView:self.header];
    [photo alignBottomEdgeWithView:self.header predicate:@"0"];
    [photo alignTrailingEdgeWithView:self.header predicate:@"*0.3"];
    
    UIView *info = [[UIView alloc] init];
    
//    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 15, 25, 250, 20)];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = teamController.currentAthlete.name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:22.0];
    [info addSubview:nameLabel];
    [nameLabel alignTop:@"25" leading:@"15" toView:info];
    [nameLabel constrainWidth:@"150"];
    
    
//    UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 175, 25, 250, 20)];
    UILabel *viewsLabel = [[UILabel alloc] init];
    viewsLabel.text = [NSString stringWithFormat:@"%li views", (long)teamController.currentAthlete.views];
    viewsLabel.textColor = [UIColor whiteColor];
    [info addSubview:viewsLabel];
    [viewsLabel alignBottomEdgeWithView:nameLabel predicate:@"0"];
    [viewsLabel constrainLeadingSpaceToView:nameLabel predicate:@"10"];
    
//    UILabel *jerseyNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 15, 50, 100, 15)];
    UILabel *jerseyNumberLabel = [[UILabel alloc] init];
    jerseyNumberLabel.text = [NSString stringWithFormat:@"#%li", (long)teamController.currentAthlete.jerseyNumber];
    jerseyNumberLabel.textColor = [UIColor whiteColor];
   // jerseyNumberLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:jerseyNumberLabel];
    [jerseyNumberLabel alignLeadingEdgeWithView:nameLabel predicate:@"0"];
    [jerseyNumberLabel constrainTopSpaceToView:nameLabel predicate:@"10"];
    
//    UILabel *positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 55, 50, 100, 15)];
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.text = teamController.currentAthlete.position;
    positionLabel.textColor = [UIColor whiteColor];
   // positionLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:positionLabel];
    [positionLabel constrainLeadingSpaceToView:jerseyNumberLabel predicate:@"30"];
    [positionLabel constrainTopSpaceToView:nameLabel predicate:@"10"];
    
//    UIView *dividingLine = [[UIView alloc] initWithFrame:CGRectMake(photo.frame.size.width + 20, 85, self.view.frame.size.width - photo.frame.size.width - 40, 2)];
    UIView *dividingLine = [[UIView alloc] init];
    dividingLine.backgroundColor = [UIColor whiteColor];
    [info addSubview:dividingLine];
    [dividingLine constrainHeight:@"2"];
    [dividingLine constrainWidthToView:info predicate:@"-50"];
    [dividingLine alignCenterXWithView:info predicate:@"0"];
    [dividingLine constrainTopSpaceToView:jerseyNumberLabel predicate:@"10"];
    
//    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 15, 110, 100, 15)];
    UILabel *heightLabel = [[UILabel alloc] init];
    heightLabel.text = [NSString stringWithFormat:@"%@", [self inchesToFeet:teamController.currentAthlete.height]];
    heightLabel.textColor = [UIColor whiteColor];
  //  heightLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:heightLabel];
    [heightLabel constrainTopSpaceToView:dividingLine predicate:@"15"];
    [heightLabel alignLeadingEdgeWithView:nameLabel predicate:@"0"];
    
//    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 75, 110, 100, 15)];
    UILabel *weightLabel = [[UILabel alloc] init];
    weightLabel.text = [NSString stringWithFormat:@"%lilbs", (long)teamController.currentAthlete.weight];
    weightLabel.textColor = [UIColor whiteColor];
    //  heightLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:weightLabel];
    [weightLabel constrainLeadingSpaceToView:heightLabel predicate:@"20"];
    [weightLabel alignBottomEdgeWithView:heightLabel predicate:@"0"];
    
//    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.size.width + 165, 110, 100, 15)];
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.text = [NSString stringWithFormat:@"%@", [self calculateYear:teamController.currentAthlete.year]];
    yearLabel.textColor = [UIColor whiteColor];
    //  heightLabel.font = [UIFont systemFontOfSize:13.0];
    [info addSubview:yearLabel];
    [yearLabel constrainLeadingSpaceToView:weightLabel predicate:@"20"];
    [yearLabel alignBottomEdgeWithView:weightLabel predicate:@"0"];
    
    [self.header addSubview:info];
    [info alignTopEdgeWithView:self.header predicate:@"0"];
    [info alignBottom:@"0" trailing:@"0" toView:self.header];
    [info constrainLeadingSpaceToView:photo predicate:@"0"];

   // self.navigationController.navigationBar.backgroundColor = backgroundColor;
    
    
    //    UILabel *recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoView.frame.size.width + 40, 75, 100, 15)];
    //    recordLabel.text = teamController.currentTeam.record;
    //    recordLabel.textColor = [UIColor whiteColor];
    //    //recordLabel.font = [UIFont systemFontOfSize:13.0];
    //    [self.header addSubview:recordLabel];
    //
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamController *teamController = [TeamController sharedInstance];
    
    float height = 0;
    
    switch (indexPath.section){
        case 0:
            //height = [self bioLabelHeight:teamController.currentAthlete.bio];
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
    }
    return height;
}

-(CGFloat)bioLabelHeight:(NSString *)string{
    
    CGRect bounding = [string boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    return bounding.size.height + 30;
}


- (NSString *)inchesToFeet:(NSInteger)heightInches{
    NSInteger feet = heightInches / 12;
    NSInteger inches = heightInches % 12;
    NSString *height = [NSString stringWithFormat:@"%li'%li\"", feet, inches];
    return height;
}

- (NSString *)calculateYear:(NSInteger)year{
    NSString *yearString;
    switch (year) {
        case (long)9:
            yearString = @"Freshman";
            break;
        case (long)10:
            yearString = @"Sophomore";
            break;
        case (long)11:
            yearString = @"Junior";
            break;
        case (long)12:
            yearString = @"Senior";
            break;
        default:
            yearString = @" ";
            break;
    }
    return yearString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end