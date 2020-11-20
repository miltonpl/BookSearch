//
//  BookDetail.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "BookDetail.h"
@implementation BookDetail;
@synthesize subtitle;
@synthesize url;
@synthesize title;

- (instancetype)initWithTitle: (NSString *) title description: (NSString *)description
{
    self = [super init];
    if (self) {
        self.title = title;
        self.subtitle =description;
    }
    return self;
}

@end
