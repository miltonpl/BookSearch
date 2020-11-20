//
//  BookDetail.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <Foundation/Foundation.h>
#import "CellModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface BookDetail : NSObject <CellModelProtocol>

- (instancetype)initWithTitle: (NSString *) title description: (NSString *)description;
@end

NS_ASSUME_NONNULL_END
