//
//  BooksViewModel.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <Foundation/Foundation.h>
#import "BookFetcher.h"
#import "Book.h"
NS_ASSUME_NONNULL_BEGIN
@protocol BooksViewModelProtocol <NSObject>

- (void)reloadSuccess;
- (void)failureWithError: (NSError *)error;
- (void)hideLoader;
- (void)showLoader;

@end
@interface BooksViewModel : NSObject
@property (weak, nonatomic) id<BooksViewModelProtocol> delegate;

- (NSInteger)numberOfBooks;
- (Book * _Nonnull)bookAtIndex: (NSInteger)index;
- (void)fetchBookCotegory: (NSString *)category;
- (void)handlerBoookSearch: (NSString * )text;
- (void)resetData;

@end

NS_ASSUME_NONNULL_END


























