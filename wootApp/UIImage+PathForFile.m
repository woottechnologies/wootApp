//
//  UIImage+PathForFile.m
//  wootApp
//
//  Created by Cole Wilkes on 6/9/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "UIImage+PathForFile.h"
#import "NetworkController.h"

@implementation UIImage (More)

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

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
