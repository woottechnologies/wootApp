//
//  SearchController.h
//  wootApp
//
//  Created by Egan Anderson on 7/23/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolController.h"
#import "TeamController.h"

@interface SearchController : NSObject

@property (nonatomic, strong) NSArray *teams;
@property (nonatomic, strong) NSString *schoolNameSearch;
@property (nonatomic, strong) NSString *peopleNameSearch;
@property (nonatomic, strong) NSArray *people;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, assign) BOOL hasSearched;

+(instancetype) sharedInstance;
- (void)searchTeamsWithCompletion:(void (^)(BOOL success))completion;
- (void)searchPeopleWithCompletion:(void (^)(BOOL success))completion;

@end
