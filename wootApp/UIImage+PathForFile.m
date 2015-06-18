//
//  UIImage+PathForFile.m
//  wootApp
//
//  Created by Cole Wilkes on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "UIImage+PathForFile.h"
#import "NetworkController.h"

@implementation UIImage (PathForFile)

+ (void)imageWithPath:(NSString *)path WithCompletion:(void (^)(BOOL success, UIImage *image))completion {
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NetworkController baseURL] stringByAppendingFormat:@"%@", path];;
    NSURL *url = [NSURL URLWithString:urlString];
    __block UIImage *returnImage;
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data.length > 0 && error == nil) {
            returnImage = [UIImage imageWithData:data];
            completion(YES, returnImage);
        } else {
            completion(NO, nil);
            NSLog(@"error loading image");
        }
        
    }];
    
    [dataTask resume];
}

@end
