//
//  StatsController.h
//  wootApp
//
//  Created by Egan Anderson on 6/22/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamController.h"

@interface StatsController : NSObject

+(instancetype) sharedInstance;
- (void)loadSummaryStatsFromDBForAthlete:(Athlete *)athlete WithCompletion:(void (^)(BOOL success, Stats *stats))completion;

@end
