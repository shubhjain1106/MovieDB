//
//  NSObject+Initialisation.h
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Initialisation)

-(instancetype)initWithDictionary:(id)dict;
+(NSArray *)arrayOfModelsFromDictionary:(id)dict;

@end
