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
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://image.tmdb.org/t/p/w780/%@",_movieDataModel.poster_path]];
    [self.movieImageVIew sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed];
    
    //Set release date
    self.dateLabel.text = _movieDataModel.release_date;
    
    //Set rating
    self.ratingLabel.text = [NSString stringWithFormat:@"%f",_movieDataModel.vote_average]; ;
    
    //Set overview
    self.plotLabel.text = _movieDataModel.overview;
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
