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
#import "SortSelectionViewController.h"

#define SortType(x) [@[@"popularity.desc",@"vote_average.desc"] objectAtIndex:x]
#define SEARCH_BAR_PLACEHOLDER_TEXT @"Search for movies here"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, SortOrderProtocol, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *movieCollectionView;
@property (strong, nonatomic) NSMutableArray *movieArray;
@property (assign, nonatomic) NSInteger pageNumber;
@property (assign, nonatomic) BOOL alreadyLoading;
@property (strong, nonatomic) NSString *sortTypeString;
@property (assign, nonatomic) SortOrder currentSortOrder;
@property (assign, nonatomic) SortOrder newSortOrder;
@property (strong, nonatomic) UISearchBar *movieSearchBar;
@property (strong, nonatomic) NSMutableString *queryString;

@end

@implementation ViewController

NSString* const IMAGE_HOST = @"https://image.tmdb.org/t/p/w300/";
NSString* const API_HOST = @"https://api.themoviedb.org/3/";

#pragma mark Lazy initialisers

-(UISearchBar *)movieSearchBar {
    
    if(!_movieSearchBar) {
        
        _movieSearchBar = [[UISearchBar alloc] init];
        _movieSearchBar.barStyle = UISearchBarStyleMinimal;
        _movieSearchBar.placeholder = SEARCH_BAR_PLACEHOLDER_TEXT;
        _movieSearchBar.translucent = NO;
        _movieSearchBar.enablesReturnKeyAutomatically = YES;
        [_movieSearchBar setShowsCancelButton:YES animated:YES];
        _movieSearchBar.delegate = self;
    }
    return _movieSearchBar;
}

#pragma mark UIView Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //To remove extra space at the top of collection view
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //initialise sort orders by default value (lets say 99)
    _currentSortOrder = INT_MAX;
    _newSortOrder = SortOrderMostPopular;
    
    //Setup navigation bar
    [self setupNavigationItems];
    
    //Register nib for collection view
    [_movieCollectionView registerNib:[UINib nibWithNibName:@"MovieCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionViewCell"];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.movieCollectionView.collectionViewLayout;
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    layout.estimatedItemSize = CGSizeMake(screenWidth / 2, 160.0);
}

-(void)viewWillAppear:(BOOL)animated {
    
    //Get data only if sort order is changed
    if(_currentSortOrder != _newSortOrder) {
        
        //Set sort order
        _currentSortOrder = _newSortOrder;
        
        [self resetDataParameters];
        [self getMovieData];
    }
}

-(void)resetDataParameters {
    
    //reset page number
    _pageNumber = 1;
    
    //Initialise data array
    _movieArray = [[NSMutableArray alloc] init];
    
    //reset query string
    _queryString = [[NSMutableString alloc] init];
    
    //Emoty colection view
    [_movieCollectionView reloadData];
    
    //Invalidate layout
    [_movieCollectionView.collectionViewLayout invalidateLayout];
    
    //Reset collection view offset
    _movieCollectionView.contentOffset = CGPointMake(0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupNavigationItems {
    
    //Set navigation item title
    self.navigationItem.title = @"Movie List";
    
    self.navigationItem.leftBarButtonItem = [self initialiseSortButtonItem];
    self.navigationItem.rightBarButtonItem = [self initialiseSearchButtonItem];
}

-(UIBarButtonItem *)initialiseSortButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"Sort By" style:UIBarButtonItemStylePlain target:self action:@selector(sortButtonClicked:)];
}

-(UIBarButtonItem *)initialiseSearchButtonItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchButtonClicked:)];
}

#pragma mark Action Methods

-(void)sortButtonClicked:(UIBarButtonItem *)barButtonItem {
    
    SortSelectionViewController *sortViewController = [[SortSelectionViewController alloc] initWithNibName:@"SortSelectionViewController" bundle:nil];
    sortViewController.sortOrderDelegate = self;
    [self.navigationController pushViewController:sortViewController animated:YES];
}

-(void)searchButtonClicked:(UIBarButtonItem *)barButtonItem {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.titleView = self.movieSearchBar;
    [_movieSearchBar becomeFirstResponder];
}

#pragma mark Data Handling Methods

-(void)getMovieData {
    
    //To avoid duplicate data requests from scrollview load more scroll limit while data fetching
    if(_alreadyLoading)
        return;
    
    _alreadyLoading = true;
    
    NSString *urlString = [self getUrl];
    
//    NSLog(@"%@",urlString);
    
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

-(NSString *)getUrl {
    
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:API_HOST];
    
    if(self.navigationItem.titleView == self.movieSearchBar) {
        [urlString appendString:@"search/movie?api_key=0ddc36d953e452ac2e0de094321e5d9d&"];
    } else {
        [urlString appendString:@"discover/movie?api_key=0ddc36d953e452ac2e0de094321e5d9d&"];
    }
    
    [urlString appendFormat:@"page=%d&sort_by=%@&query=%@",(int)_pageNumber,SortType(_currentSortOrder),_queryString];
    
    return urlString;
}

#pragma mark UICollectionViewDelegate and DataSource Methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    MovieDataModel *movieObject = [_movieArray objectAtIndex:indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,movieObject.backdrop_path]];
    
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

#pragma mark UIScrollView Delegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isEqual:self.movieCollectionView])
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;

        float y = offset.y + bounds.size.height;
        float h = size.height;
        
        if(y > h) {
            
            __weak ViewController * weakSelf = self;
            [weakSelf getMovieData];
        }
    }
}

#pragma mark Search Bar Delegate Methods

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.navigationItem.titleView = nil;
    
    [_movieSearchBar resignFirstResponder];
    
    searchBar.text = @"";
    
    [self setupNavigationItems];
    [self resetDataParameters];
    [self getMovieData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Set first row from the auto complete table view on search button click (indexPathForSelectedRow -> default value - zero)
    if(!searchBar.text)
        return;
    
    [_movieSearchBar resignFirstResponder];
    [self resetDataParameters];
    
    //Get encoded search string (for space etc.)
    _queryString = [[searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]] mutableCopy];
    
    [self getMovieData];
    
}

#pragma mark SortOrderProtocol Delegate Methods

-(void)setSortOrder:(SortOrder)sortOrder {
    _newSortOrder = sortOrder;
}

@end
