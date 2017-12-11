//
//  MovieDetailsViewController.m
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "ViewController.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *plotLabel;

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setMovieData];
    
    self.navigationItem.title = @"Movie Details";
}

-(void)viewWillAppear:(BOOL)animated {
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMovieData {
    
    //Set title
    self.movieTitleLabel.text = _movieDataModel.original_title;
    
    //Set image
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w780/%@",_movieDataModel.backdrop_path]];
    [self.movieImageVIew sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"ImagePlaceholder"] completed:nil];
    
    //Set release date
    self.dateLabel.text = [self.dateLabel.text stringByAppendingString:_movieDataModel.release_date];
    
    //Set rating
    self.ratingLabel.text = [self.ratingLabel.text stringByAppendingFormat:@"%.1f",_movieDataModel.vote_average];
    
    //Set overview
    self.plotLabel.text = _movieDataModel.overview;
    [self.plotLabel sizeToFit];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
