//
//  BookFetcher.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "BookFetcher.h"

@interface BookFetcher()
@property (nonatomic, strong) id<BookParserProtocol> parser;
@property (nonatomic, strong) id<NetworkServiceProtocol> client;
@property (nonatomic, strong) NSURL *url;
@end

@implementation BookFetcher

- (instancetype) initWithNetworkClient: (nonnull id<NetworkServiceProtocol>)client
                                parser: (nonnull id<BookParserProtocol>)parser
                                   url: (nonnull NSURL *)url {
    self = [super init];
    if (self) {
        self.client = client;
        self.parser = parser;
        self.url = url;
    }
    return self;
}

- (void)fetchBooksWithSuccessHangler: (nonnull void (^)(NSArray<Book *> * _Nonnull))successHandler failureHandler: (nonnull void (^)(NSError * _Nonnull))errorHanlder {
    
    [self.client dataTaskWithUrl:self.url withSuccessHandler:^(NSData * _Nonnull data) {
        //Book Parse used Here
        [self.parser bookParser: data withSuccessHandler:^(NSArray<Book *> * _Nonnull books) {
            successHandler(books);
            
        } failureHandler:^(NSError * _Nonnull error) {
            errorHanlder(error);
        }];
        
    } failureHandler:^(NSError * _Nonnull error) {
        errorHanlder(error);
    }];
    
}

@end
