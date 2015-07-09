//
//  AthleteController.h
//  wootApp
//
//  Created by Cole Wilkes on 7/8/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamController.h"

@interface AthleteController : NSObject

@property (nonatomic, strong) Athlete *currentAthlete;

+ (instancetype)sharedInstance;

- (void)loadAthletesFromDBWithCompletion:(void (^)(BOOL success))completion;
- (void)selectAthleteWithAthleteID:(NSInteger)athleteID andCompletion:(void (^)(BOOL success, Athlete *athlete))completion;
- (void)incrementViewsForAthleteWithCompletion:(void (^)(BOOL success))completion;

@end
