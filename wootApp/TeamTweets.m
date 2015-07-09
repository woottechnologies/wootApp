//
//  TeamTweets.m
//  wootApp
//
//  Created by Egan Anderson on 7/8/15.
//  Copyright (c) 2015 Woot Technologies. All rights reserved.
//

#import "TeamTweets.h"



@implementation TeamTweets
+ (TeamTweets *)sharedInstance {
    
    static TeamTweets *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [TeamTweets new];
    });
    return sharedInstance;
    
}

//// https://api.themoviedb.org/3/search/movie?api_key=8f4d94bf8c273bcb1899f9c853b6d8a2&query=warrior
//
//- (void)networkController{
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    if ([self.searchString containsString:@" "]){
//        self.searchString = [self.searchString stringByReplacingOccurrencesOfString:@" " withString:@"&query="];
//    }
//    
//    NSString *rootURL = @"https://api.themoviedb.org/3/search/movie?api_key=8f4d94bf8c273bcb1899f9c853b6d8a2&query=";
//    NSString *searchURL = [NSString stringWithFormat:@"%@%@", rootURL, self.searchString];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        
//        NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        
//        NSArray *arrayOfResults = serializedResults[@"results"];
//        
//        NSMutableArray *convertedResults = [NSMutableArray new];
//        
//        NSLog(@"%@", serializedResults);
//        
//        for (NSDictionary *dictionary in arrayOfResults){
//            Movie *result = [[Movie alloc] initWithDictionary:dictionary];
//            [convertedResults addObject:result];
//        }
//        self.resultMovies = convertedResults;
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"requestFinished" object:nil];
//        
//        
//    }];
//    
//    [dataTask resume];
//}
//
//- (void)detailNetworkController:(NSString *)movieID{
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    NSString *idURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@?api_key=8f4d94bf8c273bcb1899f9c853b6d8a2", movieID];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:idURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        
//        NSLog(@"Starting Now \n \n");
//        NSLog(@"%@", serializedResults);
//        
//        self.movieDetail = [[Movie alloc]initWithDictionary:serializedResults];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"detailMovie" object:nil];
//        
//        
//    }];
//    
//    [dataTask resume];
//}
//
//- (void)imageNetworkController:(NSString *)posterPath{
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    // https://image.tmdb.org/t/p/w185/hNFMawyNDWZKKHU4GYCBz1krsRM.jpg
//    
//    NSString *imageURL = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w185%@", posterPath];
//    
//    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *serializedResults = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        
//        //        NSLog(@"Starting Now \n \n");
//        //        NSLog(@"%@", serializedResults);
//        
//        self.posterImage = [UIImage imageWithData:data];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"posterImage" object:nil];
//        
//        
//    }];
//    
//    [dataTask resume];
//}


@end
