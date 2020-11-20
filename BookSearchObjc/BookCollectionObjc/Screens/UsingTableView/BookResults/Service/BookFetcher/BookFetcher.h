//
//  BookFetcher.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <Foundation/Foundation.h>
#import "NetworkService.h"
#import "BookParser.h"
#import"book.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BookFetcherProtocol <NSObject>
- (void) fetchBooksWithSuccessHangler: (void(^)(NSArray<Book *> *books))successHandler
                       failureHandler: (void(^)(NSError  *error))errorHanlder;
@end

@interface BookFetcher : NSObject <BookFetcherProtocol>
- (instancetype) initWithNetworkClient: (nonnull id<NetworkServiceProtocol>)client
                                parser: (nonnull id<BookParserProtocol>)parser
                                   url: (nonnull NSURL *)url;
@end

NS_ASSUME_NONNULL_END
