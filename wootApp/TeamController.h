//
//  TeamController.h
//  wootApp
//
//  Created by Cole Wilkes on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"
#import "Athlete.h"

@interface TeamController : NSObject

@property (nonatomic, strong, readonly) NSArray *teams;
@property (nonatomic, assign) NSInteger schoolID;
@property (nonatomic, strong) Team *currentTeam;
@property (nonatomic, strong) Athlete *currentAthlete;

+ (instancetype)sharedInstance;

- (NSArray *) mostViewedAthletes;

@end
