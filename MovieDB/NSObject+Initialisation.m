//
//  NSObject+Initialisation.m
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import "NSObject+Initialisation.h"
#import <objc/runtime.h>

@implementation NSObject (Initialisation)

-(instancetype)initWithDictionary:(id)dict{
    unsigned int propertyCount = 0;
    objc_property_t * properties = class_copyPropertyList([self class], &propertyCount);
    
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char * name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id obj = dict[propertyName];
        if(obj != (id)[NSNull null]  && obj != nil)
            [self setValue:obj forKey:propertyName];
    }
    
    return self;
}

+(NSArray *)arrayOfModelsFromDictionary:(id)dict{
    NSMutableArray *returningArr = [NSMutableArray array];
    [dict enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSObject *object = [[self alloc] initWithDictionary:obj];
        [returningArr addObject:object];
    }];
    return returningArr;
}


@end
