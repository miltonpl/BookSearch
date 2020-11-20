//
//  CoreDataManager.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/15/20.
//

#import <Foundation/Foundation.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DatabaseProviderProtocol <NSObject>
- (void) insert: (Book *)book;
- (void) deleteBook: (int)bookId;
- (NSArray <Book *> *) readBooks;
- (void) updateBook: (Book *)book bookId: (int)bookId;

@end

@interface DatabaseManager : NSObject <DatabaseProviderProtocol>

+ (id)sharedManager;
- (void)startDatabase;
-(void)dealloc;
@end

NS_ASSUME_NONNULL_END
