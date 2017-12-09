//
//  HttpClientUtil.m
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import "HttpClientUtil.h"

@implementation HttpClientUtil

+(void)getDataForUrl:(NSString *)urlString WithCompletionBlock:(APIResponseBlock)block {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString: urlString];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dictionary,error);
            } else {
                block(nil,error);
            }
        });
    }];
    [dataTask resume];
}


@end
