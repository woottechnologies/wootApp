//
//  Post.m
//  wootApp
//
//  Created by Cole Wilkes on 8/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.postID = [dictionary[PostIDKey] integerValue];
        self.text = dictionary[TextKey];
        self.timestamp = dictionary[TimestampKey];
    }
    
    return self;
}

@end
