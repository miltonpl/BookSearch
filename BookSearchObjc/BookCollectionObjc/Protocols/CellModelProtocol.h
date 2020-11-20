//
//  CellModelProtocol.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CellModelProtocol <NSObject>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
