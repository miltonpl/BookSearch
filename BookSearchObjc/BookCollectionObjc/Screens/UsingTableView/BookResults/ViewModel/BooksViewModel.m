//
//  BooksViewModel.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "BooksViewModel.h"
@interface BooksViewModel()
@property (nonatomic, strong) NSArray<Book *> *books;
@property (nonatomic, strong) id<BookFetcherProtocol> fetcher;
@end

@implementation BooksViewModel
static dispatch_block_t searchBlock = nil;

- (instancetype)init
{
    self = [super init];
    return self;
}

- (NSInteger)numberOfBooks {
    return self.books.count;
}
- (Book *)bookAtIndex: (NSInteger)index {
    return [self.books objectAtIndex: index];
}
- (void)resetData {
    self.books = NULL;
    [self.delegate reloadSuccess];
    [self.delegate hideLoader];
}

- (void)fetchBookCotegory: (NSString *)query {
    
    [self.delegate showLoader];
    NSString *tempQuery = [query stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *api = @"https://www.googleapis.com";
    NSString *endPoint = @"/books/v1/volumes?q=";
    NSString *strUrl = [NSString stringWithFormat: @"%@%@%@", api, endPoint, tempQuery];
    NSLog(@"url: %@",strUrl);
    NSURL *url = [[NSURL alloc] initWithString: strUrl];
    self.fetcher = [[BookFetcher alloc] initWithNetworkClient: [NetworkService new] parser: [BookParser new] url:url];

    [self.fetcher fetchBooksWithSuccessHangler:^(NSArray<Book *> * _Nonnull books) {
        self.books = books;
        [self.delegate reloadSuccess];
        [self.delegate hideLoader];
        
    } failureHandler:^(NSError * _Nonnull error) {
        [self.delegate failureWithError: error];
        [self.delegate hideLoader];
    }];
}

- (void)handlerBoookSearch: (NSString * )text {
    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE,0);
  
    if(searchBlock) {dispatch_block_cancel(searchBlock);}
    
    searchBlock = dispatch_block_create(0, ^{
        [self fetchBookCotegory: text];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //start search
        dispatch_async(queue, searchBlock);
    });
}

@end
