//
//  ServiceManager.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/13/20.
//

#import "NetworkService.h"

@implementation NetworkService

- (void)dataTaskWithUrl:(nonnull NSURL *)url withSuccessHandler:(nonnull void (^)(NSData * _Nonnull))successHandler failureHandler:(nonnull void (^)(NSError * _Nonnull))errorHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest * request = [NSURLRequest requestWithURL: url];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            errorHandler(error);
        }
        
        if (!data) {
            NSError *error = [[NSError alloc] initWithDomain:@"Data Unavailable" code: 1000 userInfo:nil];
            errorHandler(error);
        }
        
        NSHTTPURLResponse *HTTURLresponse = (NSHTTPURLResponse *)response;
        if (HTTURLresponse.statusCode >= 200 && HTTURLresponse.statusCode <= 299) {
            successHandler(data);
        }
        
    }];
    [task resume];
}

@end
