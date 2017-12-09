//
//  MovieDBDataController.h
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^MovieResponseBlock)(NSArray *movieList, NSError *error);

@interface MovieDBDataController : NSObject

+(instancetype)sharedInstance;
-(void)getMovieDataForUrl:(NSString *)urlString andCompletionBlock:(MovieResponseBlock)block;

@end
