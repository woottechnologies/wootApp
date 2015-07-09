//
//  Athlete.h
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "Stats.h"
#import "School.h"

static NSString *AthleteIDKey = @"id";
static NSString *AthleteNameKey = @"name";
static NSString *JerseyNumberKey = @"number";
static NSString *PhotoKey = @"photo";
static NSString *PositionKey = @"position";
static NSString *StatTypeKey = @"statType";
static NSString *HeightKey = @"height";
static NSString *WeightKey = @"weight";
static NSString *YearKey = @"year";
static NSString *BioKey = @"bio";
static NSString *IsCaptainKey = @"captain";
static NSString *IsStarterKey = @"starter";
static NSString *ViewsKey = @"views";

@interface Athlete : NSObject

@property (nonatomic, assign) NSInteger athleteID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger jerseyNumber;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *position;
@property (nonatomic, assign) NSInteger statType;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSString *bio;
@property (nonatomic, assign) BOOL isCaptain;
@property (nonatomic, assign) BOOL isStarter;
@property (nonatomic, assign) NSInteger views;
@property (nonatomic, strong) Stats *stats;
@property (nonatomic, assign) NSInteger schoolID;

- (instancetype)initWithDictionary: (NSDictionary *)dictionary;




@end
