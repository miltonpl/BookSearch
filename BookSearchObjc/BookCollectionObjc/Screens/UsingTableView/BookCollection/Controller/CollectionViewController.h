//
//  CollectionViewController.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/15/20.
//

#import <UIKit/UIKit.h>
#import "BooksViewModel.h"
#import "BookTableViewCell.h"
#import "BookDetailsViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
