//
//  MovieDataModel.h
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Initialisation.h"

@interface MovieDataModel : NSObject

@property (strong, nonatomic) NSString *poster_path;
@property (strong, nonatomic) NSString *original_title;

@end
