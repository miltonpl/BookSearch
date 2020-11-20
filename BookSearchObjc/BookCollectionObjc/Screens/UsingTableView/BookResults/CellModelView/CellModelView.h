//
//  CellModelView.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <Foundation/Foundation.h>
#import "CellModelProtocol.h"
#import "Book.h"
NS_ASSUME_NONNULL_BEGIN

@interface CellModelView : NSObject <CellModelProtocol>

- (instancetype)initWithBook: (nonnull Book *) book;
@end

NS_ASSUME_NONNULL_END
