//
//  BookListViewController.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/13/20.
//

#import "BookListViewController.h"
#import "DatabaseManager.h"

@interface BookListViewController () <UITableViewDelegate, UITableViewDataSource, BooksViewModelProtocol, UISearchBarDelegate>
@property (nonatomic, strong) BooksViewModel *viewModel;
@end

@implementation BookListViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.viewModel = [BooksViewModel new];
        self.viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Google Books Search";
    self.searchBar.delegate = self;
    [self.searchBar setShowsCancelButton:TRUE];
    [self.tableView registerNib: [UINib nibWithNibName:@"BookTableViewCell" bundle:nil] forCellReuseIdentifier: @"BookTableViewCell"];
    NSLog(@"In View Didload");
//    DatabaseManager *shared = [DatabaseManager sharedManager];
//    [shared startDatabase];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Book *book = [self.viewModel bookAtIndex: [indexPath row]];
    CellModelView *model = [[CellModelView alloc] initWithBook: book];
    BookTableViewCell * cell = (BookTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: @"BookTableViewCell" forIndexPath: indexPath];
    if(!cell) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"BookTableViewCell"];
    }
    [cell configureWithCellModelProtocol:model];
    return  cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.numberOfBooks;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Book *book = [_viewModel bookAtIndex:indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle:nil];
    BookDetailsViewController *detailViewController = (BookDetailsViewController *)[storyboard instantiateViewControllerWithIdentifier: @"BookDetailsViewController"];
    if (!detailViewController) {
        detailViewController = [BookDetailsViewController alloc];
    }
    [detailViewController configureWithBook: book];
    [self.navigationController pushViewController: detailViewController animated: true];
}

- (void)failureWithError:(nonnull NSError *)error {
    
}

- (void)hideLoader {
    
}

- (void)reloadSuccess {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)showLoader {
    
}
// called when text changes (including clear)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length >= 4) {
        [self.viewModel handlerBoookSearch: searchText];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.viewModel resetData];
    
}   // called when cancel button pressed


/*
 - (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;                      // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar;                        // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;                       // called when text ends editing


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;                     // called when keyboard search button pressed
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar API_UNAVAILABLE(tvos); // called when bookmark button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar API_AVAILABLE(ios(3.2)) API_UNAVAILABLE(tvos); // called when search results button pressed

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope API_AVAILABLE(ios(3.0));
 */



@end
