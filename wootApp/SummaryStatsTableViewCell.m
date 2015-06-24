//
//  SummaryStatsTableViewCell.m
//  wootApp
//
//  Created by Egan Anderson on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "SummaryStatsTableViewCell.h"
#import "UIView+FLKAutoLayout.h"

@interface SummaryStatsTableViewCell ()

@property (nonatomic, strong) NSDictionary *summaryStats;

@property (nonatomic, strong) UIView *stat1View;
@property (nonatomic, strong) UILabel *stat1NameLabel;
@property (nonatomic, strong) UILabel *stat1ValueLabel;

@property (nonatomic, strong) UIView *stat2View;
@property (nonatomic, strong) UILabel *stat2NameLabel;
@property (nonatomic, strong) UILabel *stat2ValueLabel;

@property (nonatomic, strong) UIView *stat3View;
@property (nonatomic, strong) UILabel *stat3NameLabel;
@property (nonatomic, strong) UILabel *stat3ValueLabel;

@property (nonatomic, strong) UIView *stat4View;
@property (nonatomic, strong) UILabel *stat4NameLabel;
@property (nonatomic, strong) UILabel *stat4ValueLabel;

@property (nonatomic, strong) UIView *stat5View;
@property (nonatomic, strong) UILabel *stat5NameLabel;
@property (nonatomic, strong) UILabel *stat5ValueLabel;

@property (nonatomic, strong) UIView *stat6View;
@property (nonatomic, strong) UILabel *stat6NameLabel;
@property (nonatomic, strong) UILabel *stat6ValueLabel;

@end

@implementation SummaryStatsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    NSString *topMarginString = @"5";
    NSString *bottomMarginString = @"-5";
    NSString *sideMarginString = @"30";
    NSString *font = @"Arial-BoldMT";
    CGFloat valueFontSize = 60;
    CGFloat nameFontSize = 25;
    
    self.stat1View = [[UIView alloc] init];
    self.stat1NameLabel = [[UILabel alloc] init];
    self.stat1NameLabel.font = [UIFont fontWithName:font size:nameFontSize];
    self.stat1ValueLabel = [[UILabel alloc] init];
    self.stat1ValueLabel.font = [UIFont fontWithName:font size:valueFontSize];
    [self.stat1View addSubview:self.stat1NameLabel];
    [self.stat1View addSubview:self.stat1ValueLabel];
    [self.stat1ValueLabel alignTopEdgeWithView:self.stat1View predicate:topMarginString];
    [self.stat1ValueLabel alignLeadingEdgeWithView:self.stat1View predicate:sideMarginString];
    [self.stat1NameLabel constrainTopSpaceToView:self.stat1ValueLabel predicate:@"-15"];
    [self.stat1NameLabel alignLeadingEdgeWithView:self.stat1ValueLabel predicate:@"0"];
    [self.stat1NameLabel alignBottomEdgeWithView:self.stat1View predicate:bottomMarginString];
    [self.stat1ValueLabel constrainHeightToView:self.stat1View predicate:@"*0.6"];
    
    self.stat2View = [[UIView alloc] init];
    self.stat2NameLabel = [[UILabel alloc] init];
    self.stat2NameLabel.font = [UIFont fontWithName:font size:nameFontSize];
    self.stat2ValueLabel = [[UILabel alloc] init];
    self.stat2ValueLabel.font = [UIFont fontWithName:font size:valueFontSize];
    [self.stat2View addSubview:self.stat2NameLabel];
    [self.stat2View addSubview:self.stat2ValueLabel];
    [self.stat2ValueLabel alignTopEdgeWithView:self.stat2View predicate:topMarginString];
    [self.stat2ValueLabel alignLeadingEdgeWithView:self.stat2View predicate:sideMarginString];
    [self.stat2NameLabel constrainTopSpaceToView:self.stat2ValueLabel predicate:@"-15"];
    [self.stat2NameLabel alignLeadingEdgeWithView:self.stat2ValueLabel predicate:@"0"];
    [self.stat2NameLabel alignBottomEdgeWithView:self.stat2View predicate:bottomMarginString];
    [self.stat2ValueLabel constrainHeightToView:self.stat2View predicate:@"*0.6"];
    
    self.stat3View = [[UIView alloc] init];
    self.stat3NameLabel = [[UILabel alloc] init];
    self.stat3NameLabel.font = [UIFont fontWithName:font size:nameFontSize];
    self.stat3ValueLabel = [[UILabel alloc] init];
    self.stat3ValueLabel.font = [UIFont fontWithName:font size:valueFontSize];
    [self.stat3View addSubview:self.stat3NameLabel];
    [self.stat3View addSubview:self.stat3ValueLabel];
    [self.stat3ValueLabel alignTopEdgeWithView:self.stat3View predicate:topMarginString];
    [self.stat3ValueLabel alignLeadingEdgeWithView:self.stat3View predicate:sideMarginString];
    [self.stat3NameLabel constrainTopSpaceToView:self.stat3ValueLabel predicate:@"-15"];
    [self.stat3NameLabel alignLeadingEdgeWithView:self.stat3ValueLabel predicate:@"0"];
    [self.stat3NameLabel alignBottomEdgeWithView:self.stat3View predicate:bottomMarginString];
    [self.stat3ValueLabel constrainHeightToView:self.stat3View predicate:@"*0.6"];
    
    self.stat4View = [[UIView alloc] init];
    self.stat4NameLabel = [[UILabel alloc] init];
    self.stat4NameLabel.font = [UIFont fontWithName:font size:nameFontSize];
    self.stat4ValueLabel = [[UILabel alloc] init];
    self.stat4ValueLabel.font = [UIFont fontWithName:font size:valueFontSize];
    [self.stat4View addSubview:self.stat4NameLabel];
    [self.stat4View addSubview:self.stat4ValueLabel];
    [self.stat4ValueLabel alignTopEdgeWithView:self.stat4View predicate:topMarginString];
    [self.stat4ValueLabel alignLeadingEdgeWithView:self.stat4View predicate:sideMarginString];
    [self.stat4NameLabel constrainTopSpaceToView:self.stat4ValueLabel predicate:@"-15"];
    [self.stat4NameLabel alignLeadingEdgeWithView:self.stat4ValueLabel predicate:@"0"];
    [self.stat4NameLabel alignBottomEdgeWithView:self.stat4View predicate:bottomMarginString];
    [self.stat4ValueLabel constrainHeightToView:self.stat4View predicate:@"*0.6"];
    
    self.stat5View = [[UIView alloc] init];
    self.stat5NameLabel = [[UILabel alloc] init];
    self.stat5NameLabel.font = [UIFont fontWithName:font size:nameFontSize];
    self.stat5ValueLabel = [[UILabel alloc] init];
    self.stat5ValueLabel.font = [UIFont fontWithName:font size:valueFontSize];
    [self.stat5View addSubview:self.stat5NameLabel];
    [self.stat5View addSubview:self.stat5ValueLabel];
    [self.stat5ValueLabel alignTopEdgeWithView:self.stat5View predicate:topMarginString];
    [self.stat5ValueLabel alignLeadingEdgeWithView:self.stat5View predicate:sideMarginString];
    [self.stat5NameLabel constrainTopSpaceToView:self.stat5ValueLabel predicate:@"-15"];
    [self.stat5NameLabel alignLeadingEdgeWithView:self.stat5ValueLabel predicate:@"0"];
    [self.stat5NameLabel alignBottomEdgeWithView:self.stat5View predicate:bottomMarginString];
    [self.stat5ValueLabel constrainHeightToView:self.stat5View predicate:@"*0.6"];
    
    self.stat6View = [[UIView alloc] init];
    self.stat6NameLabel = [[UILabel alloc] init];
    self.stat6NameLabel.font = [UIFont fontWithName:font size:nameFontSize];
    self.stat6ValueLabel = [[UILabel alloc] init];
    self.stat6ValueLabel.font = [UIFont fontWithName:font size:valueFontSize];
    [self.stat6View addSubview:self.stat6NameLabel];
    [self.stat6View addSubview:self.stat6ValueLabel];
    [self.stat6ValueLabel alignTopEdgeWithView:self.stat6View predicate:topMarginString];
    [self.stat6ValueLabel alignLeadingEdgeWithView:self.stat6View predicate:sideMarginString];
    [self.stat6NameLabel constrainTopSpaceToView:self.stat6ValueLabel predicate:@"-15"];
    [self.stat6NameLabel alignLeadingEdgeWithView:self.stat6ValueLabel predicate:@"0"];
    [self.stat6NameLabel alignBottomEdgeWithView:self.stat6View predicate:bottomMarginString];
    [self.stat6ValueLabel constrainHeightToView:self.stat6View predicate:@"*0.6"];
    
    [self.contentView addSubview:self.stat1View];
    [self.contentView addSubview:self.stat2View];
    [self.contentView addSubview:self.stat3View];
    [self.contentView addSubview:self.stat4View];
    [self.contentView addSubview:self.stat5View];
    [self.contentView addSubview:self.stat6View];
    
    [self.stat1View alignTop:@"0" leading:@"0" toView:self.contentView];
    [self.stat2View alignTopEdgeWithView:self.contentView predicate:@"0"];
    [self.stat2View constrainLeadingSpaceToView:self.stat1View predicate:@"0"];
    [self.stat2View alignTrailingEdgeWithView:self.contentView predicate:@"0"];
    [UIView equalWidthForViews:@[self.stat1View, self.stat2View]];
    
    [self.stat3View constrainTopSpaceToView:self.stat1View predicate:@"0"];
    [self.stat3View alignLeadingEdgeWithView:self.contentView predicate:@"0"];
    [self.stat4View constrainTopSpaceToView:self.stat2View predicate:@"0"];
    [self.stat4View constrainLeadingSpaceToView:self.stat3View predicate:@"0"];
    [self.stat4View alignTrailingEdgeWithView:self.contentView predicate:@"0"];
    [UIView equalWidthForViews:@[self.stat3View, self.stat4View]];
    
    [self.stat5View constrainTopSpaceToView:self.stat3View predicate:@"0"];
    [self.stat5View alignLeadingEdgeWithView:self.contentView predicate:@"0"];
    [self.stat6View constrainTopSpaceToView:self.stat4View predicate:@"0"];
    [self.stat6View constrainLeadingSpaceToView:self.stat5View predicate:@"0"];
    [self.stat6View alignTrailingEdgeWithView:self.contentView predicate:@"0"];
    [self.stat5View alignBottomEdgeWithView:self.contentView predicate:@"0"];
    [self.stat6View alignBottomEdgeWithView:self.contentView predicate:@"0"];
    [UIView equalWidthForViews:@[self.stat5View, self.stat6View]];
    
    
    [UIView equalHeightForViews:@[self.stat1View, self.stat2View, self.stat3View, self.stat4View, self.stat5View, self.stat6View]];
    }

- (void)loadDataWithStats:(NSDictionary *)summaryStats {
    self.summaryStats = summaryStats;
    NSArray *statNames = summaryStats[@"Stat Names"];
    
//    NSString *value = summaryStats[statNames[0]];
    self.stat1ValueLabel.text = summaryStats[statNames[0]];
    self.stat1NameLabel.text = statNames[0];
    
//    value = summaryStats[statNames[1]];
    self.stat2ValueLabel.text = summaryStats[statNames[1]];
    self.stat2NameLabel.text = statNames[1];
    
//    value = summaryStats[statNames[2]];
    self.stat3ValueLabel.text = summaryStats[statNames[2]];
    self.stat3NameLabel.text = statNames[2];
    
//    value = summaryStats[statNames[3]];
    self.stat4ValueLabel.text = summaryStats[statNames[3]];
    self.stat4NameLabel.text = statNames[3];

//    value = summaryStats[statNames[4]];
    self.stat5ValueLabel.text = summaryStats[statNames[4]];
    self.stat5NameLabel.text = statNames[4];
    
//    value = summaryStats[statNames[5]];
    self.stat6ValueLabel.text = summaryStats[statNames[5]];
    self.stat6NameLabel.text = statNames[5];
}

@end
