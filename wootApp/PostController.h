//
//  PostController.h
//  wootApp
//
//  Created by Cole Wilkes on 8/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface PostController : NSObject

@property (nonatomic, strong) Post *currentPost;

+ (instancetype)sharedInstance;
- (void)uploadImage:(NSData *)imageData filename:(NSString *)filename withCompletion:(void (^)(BOOL success, NSString *error))completion;
//- (void)addPostWithCompletion:(void (^)(BOOL success, NSString *error))completion;

@end
