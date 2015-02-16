//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "Business.h"
#import "BusinessTableViewCell.h"
#import "FiltersViewController.h"
#import "MapViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FiltersViewControllerDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *businesses;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *queryWord;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSIndexPath *scrollBottomPath;

@end

@implementation MainViewController

const int paginatedLimit = 10;
int offset;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        offset = 0;
        self.queryWord = @"Thai";
        self.filters = nil;
        self.scrollBottomPath = nil;
        [self fetchBusinessWithQuery:self.queryWord params:self.filters limit:paginatedLimit offset:offset];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.searchBar = [[UISearchBar alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    //self.title = @"Yelp";
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(onFilterButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(onMapButton)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessTableViewCell"];
    
    self.tableView.estimatedRowHeight = 85;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
    if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        if (!self.scrollBottomPath) {
            //first time
            offset = offset + paginatedLimit;
            [self fetchBusinessWithQuery:self.queryWord params:self.filters limit:paginatedLimit offset:offset];
            self.scrollBottomPath = [self.tableView indexPathForRowAtPoint:bottomOffset];
        } else {
            if (self.scrollBottomPath != [self.tableView indexPathForRowAtPoint:bottomOffset]) {
                offset = offset + paginatedLimit;
                [self fetchBusinessWithQuery:self.queryWord params:self.filters limit:paginatedLimit offset:offset];
                self.scrollBottomPath = [self.tableView indexPathForRowAtPoint:bottomOffset];
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessTableViewCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

#pragma mark - Filter delegate methods

- (void) filtersViewController:(FiltersViewController *)filtersViewController didChangeFilters:(NSDictionary *)filters {
    offset = 0;
    self.queryWord = @"Restaurants";
    self.filters = filters;
    [self fetchBusinessWithQuery:self.queryWord params:self.filters limit:paginatedLimit offset:offset];
}

#pragma mark - Search bar methods

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        offset = 0;
        self.queryWord = searchText;
        [self fetchBusinessWithQuery:self.queryWord params:self.filters limit:paginatedLimit offset:offset];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
}

#pragma mark - Private Methods

-(void) fetchBusinessWithQuery:(NSString *)query params:(NSDictionary *)params limit:(int)limit offset:(int)offset {
    [self.client searchWithTerm:query limit:limit offset:offset params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *businessDictionaries = response[@"businesses"];
        
        if (offset > 0) {
            NSMutableArray *newResults = [[NSMutableArray alloc] initWithArray:self.businesses];
            [newResults addObjectsFromArray:[Business businessesWithDictionaries:businessDictionaries]];
            self.businesses = newResults;
        } else {
            self.businesses = [Business businessesWithDictionaries:businessDictionaries];
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void) onFilterButton {
    FiltersViewController *vc = [[FiltersViewController alloc] init];
    vc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void) onMapButton {
    MapViewController *vc = [[MapViewController alloc] init];    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
