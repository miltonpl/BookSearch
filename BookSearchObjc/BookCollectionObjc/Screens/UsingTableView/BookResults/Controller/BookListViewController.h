//
//  BookListViewController.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/13/20.
//

#import <UIKit/UIKit.h>
#import "BooksViewModel.h"
#import "BookTableViewCell.h"
#import "BookDetailsViewController.h"
@interface BookListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

