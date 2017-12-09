//
//  HttpClientUtil.h
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieDBDataController.h"

typedef void(^APIResponseBlock)(NSDictionary *dictionary,NSError *error);

@interface HttpClientUtil : NSObject

+(void)getDataForUrl:(NSString *)urlString WithCompletionBlock:(APIResponseBlock)block;

@end
