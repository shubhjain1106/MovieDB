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

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *movieCollectionView;
@property (strong, nonatomic) NSArray *movieArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self getMovieData];
    
    [_movieCollectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Data Handling Methods

-(void)getMovieData {
    
    NSString *urlString = @"https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=0ddc36d953e452ac2e0de094321e5d9d";
    
    [[MovieDBDataController sharedInstance] getMovieDataForUrl:urlString andCompletionBlock:^(NSArray *movieList, NSError *error) {
       
        if(error) {
            NSLog(@"ERROR");
        } else {
            _movieArray = movieList;
            [_movieCollectionView reloadData];
        }
        
    }];
    
}


#pragma mark UICollectionViewDelegate and DataSource Methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    MovieDataModel *movieObject = [_movieArray objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_main_queue(), ^{
         cell.titleLabel.text = movieObject.original_title;
    });
   
    
//    dispatch_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
    
//    cell.titleImageView set
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _movieArray.count;
}


@end
