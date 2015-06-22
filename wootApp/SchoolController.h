//
//  SchoolController.h
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "School.h"

@interface SchoolController : NSObject

@property (nonatomic, strong, readonly) NSArray *schools;
@property (nonatomic, strong) School *currentSchool;

+(instancetype) sharedInstance;
- (void)loadSchoolsFromDatabaseWithCompletion:(void (^)(BOOL success))completion;

@end
