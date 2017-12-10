//
//  MovieCollectionViewCell.m
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import "MovieCollectionViewCell.h"
#import "MovieDataModel.h"

@interface MovieCollectionViewCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidthConstraint;

@end

@implementation MovieCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _labelWidthConstraint.constant = [UIScreen mainScreen].bounds.size.width/2 - 16;
}

-(UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    return [super preferredLayoutAttributesFittingAttributes:layoutAttributes];
}

@end
