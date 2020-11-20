//
//  CollectionViewController.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/15/20.
//

#import "CollectionViewController.h"

@interface CollectionViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray<Book *> *books;

@end

@implementation CollectionViewController

- (instancetype) initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.books = [NSMutableArray alloc];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CellModelView *model = [[CellModelView alloc] initWithBook: self.books[indexPath.row]];
    BookTableViewCell * cell = (BookTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: @"BookTableViewCell" forIndexPath: indexPath];
    if(!cell) {
        cell = [[BookTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"BookTableViewCell"];
    }
    [cell configureWithCellModelProtocol:model];
    return  cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.books.count;
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleDestructive title: @"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        
        [self.books removeObjectAtIndex:indexPath.row];
        completionHandler(YES);
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    }];
    deleteAction.backgroundColor = [UIColor purpleColor];
    UISwipeActionsConfiguration *swipeActionCofig = [UISwipeActionsConfiguration configurationWithActions: @[deleteAction]];
    swipeActionCofig.performsFirstActionWithFullSwipe = NO;
    return swipeActionCofig;
}

@end
