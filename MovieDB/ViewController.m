//
//  ViewController.m
//  MovieDB
//
//  Created by Shubham on 09/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import "ViewController.h"
#import "MovieCollectionViewCell.h"
#import "MovieDBDataController.h"
#import "MovieDataModel.h"
#import "UIImageView+WebCache.h"
#import "MovieDetailsViewController.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *movieCollectionView;
@property (strong, nonatomic) NSMutableArray *movieArray;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) BOOL alreadyLoading;

@end

@implementation ViewController

NSString* const IMAGE_HOST = @"https://image.tmdb.org/t/p/w500/";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //To remove extra space at the top of collection view
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Initialise data array
    _movieArray = [[NSMutableArray alloc] init];
    
    //default
    _pageNumber = 1;
    
    //Get data
    [self getMovieData];
    
    //Set navigation item title
    self.navigationItem.title = @"Movie List";
    
    
    [_movieCollectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Data Handling Methods

-(void)getMovieData {
    
    //To avoid duplicate data requests from scrollview load more scroll limit while data fetching
    if(_alreadyLoading)
        return;
    
    _alreadyLoading = true;
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?api_key=0ddc36d953e452ac2e0de094321e5d9d&page=%d",(int)_pageNumber];
    
    [[MovieDBDataController sharedInstance] getMovieDataForUrl:urlString andCompletionBlock:^(NSArray *movieList, NSError *error) {
       
        _alreadyLoading = false;
        
        if(error) {
            NSLog(@"ERROR");
        } else {
            
            //Current data array size
            NSInteger itemCount = [self.movieArray count];
            
            //Array of idex paths
            NSMutableArray *indexArray = [[NSMutableArray alloc] init];
            
            //Get index path array for current batch of items
            for(int i=0;i < [movieList count] ; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:(itemCount+i) inSection:0];
                [indexArray addObject:indexPath];
            }
            
            //Append api response to the data array
            [_movieArray addObjectsFromArray:movieList];
            
            //Insert items in the collection view
            [_movieCollectionView insertItemsAtIndexPaths:indexArray];
            
            //Increment page number on success
            _pageNumber++;
        }
    }];
}

#pragma mark UICollectionViewDelegate and DataSource Methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    MovieDataModel *movieObject = [_movieArray objectAtIndex:indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,movieObject.poster_path]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
         cell.titleLabel.text = movieObject.title;
        [cell.titleImageView sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageRetryFailed];
    });
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _movieArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieDetailsViewController *detailsViewController = [[MovieDetailsViewController alloc] initWithNibName:@"MovieDetailsViewController" bundle:nil];
    detailsViewController.movieDataModel = [_movieArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger loadMoreIndex = [_movieArray count] - 4;
    
    //Initiate call for new batch of data as the last 2nd row gets allocated (last 4th element)
    if ((loadMoreIndex > 0) && (indexPath.row == loadMoreIndex)) {
        [self getMovieData];
    }
}


@end
