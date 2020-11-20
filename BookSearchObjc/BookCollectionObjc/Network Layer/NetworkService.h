//
//  SNetworkService.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/13/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NetworkServiceProtocol <NSObject>

- (void)dataTaskWithUrl: (NSURL *)url
     withSuccessHandler: (void(^)(NSData *data))successHandler failureHandler: (void(^)(NSError *error))errorHandler;
@end

@interface NetworkService : NSObject <NetworkServiceProtocol>


@end

NS_ASSUME_NONNULL_END
