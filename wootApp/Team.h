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

@interface Team : NSObject

@property (nonatomic, assign) NSInteger teamID;
//@property (nonatomic, assign) NSInteger schoolID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *record;
@property (nonatomic, strong) NSArray *athletes;
//@property (nonatomic, assign) NSArray *schedule;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
