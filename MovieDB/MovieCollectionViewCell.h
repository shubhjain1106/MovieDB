//
//  MovieCollectionViewCell.h
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

@end
