//
//  SortSelectionViewController.m
//  MovieDB
//
//  Created by Shubham on 10/12/17.
//  Copyright © 2017 Shubham. All rights reserved.
//

#import "SortSelectionViewController.h"

@interface SortSelectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *sortTableView;
@property (strong, nonatomic) NSArray *sortOrderArray;

@end

@implementation SortSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initialiseSortArray];
    [_sortTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCell"];
    
    //To remove extraneous cell separators
    _sortTableView.tableFooterView.frame = CGRectZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialiseSortArray {
    _sortOrderArray = @[@"Most Popular",@"Highest Rated"];
}

#pragma mark UITableView Delegate and Datasource Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    
    cell.textLabel.text = [_sortOrderArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sortOrderArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.sortOrderDelegate respondsToSelector:@selector(setSortOrder:)]){
        [self.sortOrderDelegate setSortOrder:(SortOrder)indexPath.row];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
