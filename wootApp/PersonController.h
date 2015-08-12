//
//  PersonController.h
//  wootApp
//
//  Created by Egan Anderson on 8/11/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "Person.h"

@interface PersonController : NSObject

@property (nonatomic, strong) Person *currentPerson;

+ (instancetype)sharedInstance;

- (void)selectPersonWithUserID:(NSInteger)userID andCompletion:(void (^)(BOOL success, Person *person))completion;
- (void)incrementViewsForPersonWithCompletion:(void (^)(BOOL success))completion;


@end
