//
//  Team.h
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "School.h"

static NSString *TeamIDKey = @"id";
static NSString *TypeKey = @"type";
static NSString *WinsKey = @"wins";
static NSString *LossesKey = @"losses";
static NSString *ScheduleIDKey = @"scheduleID";
static NSString *CoachingStaffPhotoKey = @"coachingStaffPhoto";
static NSString *AthleteHeaderPhotoKey = @"athleteHeaderPhoto";
static NSString *TeamHeaderPhotoKey = @"teamHeaderPhoto";
static NSString *TeamNameKey = @"teamName";
static NSString *TwitterKey = @"twitter";

@interface Team : NSObject

@property (nonatomic, assign) NSInteger teamID;
@property (nonatomic, assign) NSInteger schoolID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *record;
@property (nonatomic, strong) NSArray *athletes;
@property (nonatomic, strong) NSArray *campaigns;
@property (nonatomic, strong) NSArray *schedule;
@property (nonatomic, strong) NSArray *coaches;
@property (nonatomic, strong) UIImage *coachingStaffPhoto;
@property (nonatomic, strong) UIImage *athleteHeaderPhoto;
@property (nonatomic, strong) UIImage *teamHeaderPhoto;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *twitter;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
