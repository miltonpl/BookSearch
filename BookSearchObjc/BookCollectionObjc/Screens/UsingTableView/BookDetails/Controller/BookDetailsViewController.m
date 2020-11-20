//
//  BookDetailsViewController.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "BookDetailsViewController.h"
#import "BookDetail.h"
#import "DatabaseManager.h"

@interface BookDetailsViewController ()

@property (nonatomic, strong) Book *book;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (nonatomic, strong) NSMutableArray<BookDetail *> *details;
- (void)downloadImage:(NSURL * _Nonnull ) url;

@end

@implementation BookDetailsViewController
static DatabaseManager *shared;
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.details = [NSMutableArray new];
    }
    return  self;
}
#pragma mark - UIView lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setEstimatedRowHeight:100.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"BookDetailTableViewCell"];
    [self setupTabBarItem];
    shared = [DatabaseManager sharedManager];
    [shared startDatabase];

}
- (void)setupTabBarItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Save" style: UIBarButtonItemStylePlain target:self action: @selector(saveBook:)];
    [self.navigationItem setRightBarButtonItem:item animated:YES];
}
- (void)saveBook:(id)sender {
//    DatabaseManager *dbManager= [DatabaseManager sharedManager];
    [shared insert: self.book];
    NSLog(@"save tapped");
    
}

- (void)configureWithBook: (Book *)book {
    self.book = book;
    if (book.title) {
        [self.details addObject: [[BookDetail alloc] initWithTitle: @"Title" description: book.title]];
    }
    
    if (book.subtitle) {
        [self.details addObject: [[BookDetail alloc] initWithTitle: @"Subtitle" description: book.subtitle]];
    }
   
    if (book.category) {
//        NSString *categories = [[book.category valueForKey:@"description"] componentsJoinedByString:@""];
        [self.details addObject: [[BookDetail alloc] initWithTitle: @"Caterogy" description: book.category]];
    }
    
    if (book.author) {
//        NSString *authors = [[book.author valueForKey:@"description"] componentsJoinedByString:@""];
        [self.details addObject: [[BookDetail alloc] initWithTitle: @"Authors" description: book.author]];
    }
    
    if (book.descriptionInfo) {
        [self.details addObject: [[BookDetail alloc] initWithTitle: @"Description" description: book.descriptionInfo]];
    }
    
    if (book.language) {
        [self.details addObject: [[BookDetail alloc] initWithTitle: @"Language" description: book.language]];
    }
    
    if (book.publisher) {
        [self.details addObject: [[BookDetail alloc] initWithTitle: @"Publisher" description: book.publisher]];
    }
   
//    [self.details addObject: [[BookDetail alloc] initWithTitle: @"Avg Rating" description: book.averageRating]];
//    [self.details addObject: [[BookDetail alloc] initWithTitle: @"Page Count" description: book.pageCount]];
    [self downloadImage: [[NSURL alloc] initWithString:book.thumbnail]];
    [self.tableView reloadData];
}

- (void)downloadImage: (NSURL * _Nonnull ) url {
    
    if (@available(iOS 13.0, *)) {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL:url];
            if(!data) {
                NSLog(@"Error no data"); return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.bookImage.image = [UIImage imageWithData: data];
            });
        });
    } else {
        NSLog(@"// Fallback on earlier versions");
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BookDetailTableViewCell * cell = (BookDetailTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier: @"BookDetailTableViewCell" forIndexPath: indexPath];
    if(!cell) {
        cell = [[BookDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"BookDetailTableViewCell"];
    }
    [cell configureWithCellViewModelProtocol: self.details[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.details.count;
}



@end
