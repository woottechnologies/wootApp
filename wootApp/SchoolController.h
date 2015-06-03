//
//  SchoolController.h
//  wootApp
//
//  Created by Egan Anderson on 6/3/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolController : NSObject

@property (nonatomic, strong) NSArray *schools;

+(instancetype) sharedInstance;

@end
