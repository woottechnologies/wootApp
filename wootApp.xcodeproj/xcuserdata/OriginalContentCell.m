//
//  OriginalContentCell.m
//  wootApp
//
//  Created by Egan Anderson on 1/18/16.
//  Copyright © 2016 Woot Technologies. All rights reserved.
//

#import "OriginalContentCell.h"
#import "UIView+FLKAutoLayout.h"

@interface OriginalContentCell ()

@property (nonatomic, strong) UIImageView *originalContentImage;
@property (nonatomic, strong) UILabel *originalContentCaption;
@property (nonatomic, strong) UIView *postView;
@property (nonatomic, strong) UILabel *posterName;
@property (nonatomic, strong) UIButton *posterNameButton;
@property (nonatomic, strong) UIView *grayView;

@end


@implementation OriginalContentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.postView = [[UIView alloc] init];
        self.originalContentImage = [[UIImageView alloc] init];
        self.originalContentCaption = [[UILabel alloc] init];
        self.originalContentCaption.numberOfLines = 0;
        //    self.posterName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.contentView.frame.size.width, 30)];
        self.posterNameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        self.posterNameButton.frame = CGRectMake(5, 5, self.contentView.frame.size.width, 30);
        [self.posterNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.posterNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //    self.posterName.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        self.posterNameButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//        [self.posterNameButton addTarget:self action:@selector(posterNameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.posterNameButton.enabled = YES;
        self.grayView = [[UIView alloc] init];
        self.grayView.backgroundColor = [UIColor lightGrayColor];
        [self.postView addSubview:self.originalContentImage];
        [self.postView addSubview:self.originalContentCaption];
        //    [self.postView addSubview:self.posterName];
        [self.postView addSubview:self.grayView];
        [self.postView addSubview:self.posterNameButton];
        [self.contentView addSubview:self.postView];
        
        [self.grayView alignTop:@"0" leading:@"0" toView:self.postView];
        [self.grayView alignTrailingEdgeWithView:self.postView predicate:@"0"];
        [self.grayView constrainHeight:@"5"];
        
        [self.posterNameButton constrainTopSpaceToView:self.grayView predicate:@"0"];
        [self.posterNameButton alignLeadingEdgeWithView:self.postView predicate:@"5"];
        [self.posterNameButton alignTrailingEdgeWithView:self.postView predicate:@"0"];
        [self.posterNameButton constrainHeight:@"30"];
        
        [self.postView alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self.contentView];
        
    }
    return self;
}

- (void)setUpOriginalContentCell:(NSDictionary *)contents{
    [self.posterNameButton setTitle:contents[@"poster"] forState:UIControlStateNormal];
    [self.originalContentImage setImage:contents[@"image"]];
    self.originalContentCaption.text = contents[@"caption"];

    [self.originalContentImage constrainTopSpaceToView:self.posterNameButton predicate:@"0"];
    [self.originalContentImage alignLeading:@"0" trailing:@"0" toView:self.postView];
    [self.originalContentCaption constrainTopSpaceToView:self.originalContentImage predicate:@"0"];
    [self.originalContentCaption alignLeading:@"0" trailing:@"0" toView:self.postView];
    [self.originalContentCaption alignBottomEdgeWithView:self.postView predicate:@"0"];
}





@end
