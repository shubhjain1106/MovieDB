//
//  MovieDBDataController.m
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import "MovieDBDataController.h"
#import "HttpClientUtil.h"
#import "MovieDataModel.h"

@implementation MovieDBDataController

+(instancetype)sharedInstance {
    
    static MovieDBDataController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MovieDBDataController alloc] init];
    });
    return sharedInstance;
}

-(void)getMovieDataForUrl:(NSString *)urlString andCompletionBlock:(MovieResponseBlock)block {
    
    [HttpClientUtil getDataForUrl:urlString WithCompletionBlock:^(NSDictionary *movieResponse, NSError *error) {
        
        if(error) {
            
        } else {
            NSArray *movieArray = [MovieDataModel arrayOfModelsFromDictionary:[movieResponse objectForKey:@"results"]];
            block(movieArray, nil);
        }
        
    }];
}

@end
