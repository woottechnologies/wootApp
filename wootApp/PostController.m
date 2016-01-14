//
//  PostController.m
//  wootApp
//
//  Created by Cole Wilkes on 8/20/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "PostController.h"
#import "NetworkController.h"
#import "UserController.h"

@interface PostController()

@end

@implementation PostController

+ (instancetype)sharedInstance {
    static PostController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PostController alloc] init];
    });
    
    return sharedInstance;
}

- (void)uploadImage:(NSData *)imageData filename:(NSString *)filename withCompletion:(void (^)(BOOL success, NSString *error))completion {
    
    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"new_user_post.php"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    
    NSLog(@"%@", responseDict);
    
    NSInteger returnCode = [[responseDict objectForKey:@"returnCode"] integerValue];
    
    if (returnCode == 10) {
        completion(YES, nil);
    } else {
        completion(NO, @"error");
    }
}

//- (void)addPostWithCompletion:(void (^)(BOOL success, NSString *error))completion {
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    UserController *userController = [UserController sharedInstance];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    NSString *text = self.currentPost.text;
//    UIImage *photo = self.currentPost.photo;
//    NSString *timestamp = [dateFormatter stringFromDate:self.currentPost.timestamp];
//    
//    NSData *imageData = UIImagePNGRepresentation(photo);
//    NSString *urlString = [[NetworkController baseURL] stringByAppendingString:@"new_user_post.php"];
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    
//    NSMutableData *data = [NSMutableData data];
//    [data appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"test.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
////    NSString *moreData = [NSString stringWithFormat:@"userID=%li&text=%@timestamp=%@", userController.currentUser.userID, text, timestamp];
////    [data appendData:[moreData dataUsingEncoding:NSUTF8StringEncoding]];
//    [data appendData:[NSData dataWithData:imageData]];
//    [data appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    [request setHTTPBody:body];
//    
//    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if (data.length > 0 && error == nil) {
//           // id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            
//            
//        } else {
//            completion(NO, @"Cant complete task.");
//        }
//    }];
//        
//    [uploadTask resume];
//}

@end
