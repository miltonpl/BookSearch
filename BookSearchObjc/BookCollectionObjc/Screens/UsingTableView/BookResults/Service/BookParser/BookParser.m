//
//  BookParser.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "BookParser.h"

@implementation BookParser

- (void)bookParser:(nonnull NSData *)bookData withSuccessHandler:(nonnull void (^)(NSArray<Book *> * _Nonnull))successHandler failureHandler:(nonnull void (^)(NSError * _Nonnull))errorHandler {
    NSError *error;
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData: bookData options:NSJSONReadingAllowFragments error: &error];
    if (error || !jsonData) {
        errorHandler(error);
    }
    
    NSArray *books = [jsonData objectForKey: @"items"];
    if (books.count == 0 || !books) {
        NSError *error = [[NSError alloc] initWithDomain: @"items not found in dictionary" code:1001 userInfo:nil];
        errorHandler(error);
    }
    
    NSMutableArray<Book *> *tempBooks = [NSMutableArray new];
    for (NSDictionary * dict in books) {
        Book *book = [[Book alloc] initWithDictionary: dict];
        [tempBooks addObject: book];
    }
    successHandler(tempBooks);
}

@end
