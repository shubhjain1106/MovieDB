//
//  SortSelectionViewController.h
//  MovieDB
//
//  Created by Shubham on 10/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SortOrder) {
    SortOrderMostPopular,
    SortOrderHighestRated,
};

@protocol SortOrderProtocol <NSObject>

-(void)setSortOrder:(SortOrder)sortOrder;

@property (weak, nonatomic) id <SortOrderProtocol> sortOrderDelegate;

@end

@interface SortSelectionViewController : UIViewController

@property (weak, nonatomic) id sortOrderDelegate;

@end
