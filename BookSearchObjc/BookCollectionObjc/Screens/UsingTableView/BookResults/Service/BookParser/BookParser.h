//
//  BookParser.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <Foundation/Foundation.h>
#import "Book.h"
NS_ASSUME_NONNULL_BEGIN
@protocol BookParserProtocol <NSObject>

- (void)bookParser: (NSData *)bookData
 withSuccessHandler: (void(^)(NSArray<Book *> *books))successHandler
     failureHandler: (void(^)(NSError *error))errorHandler;

@end
@interface BookParser : NSObject <BookParserProtocol>

@end

NS_ASSUME_NONNULL_END
