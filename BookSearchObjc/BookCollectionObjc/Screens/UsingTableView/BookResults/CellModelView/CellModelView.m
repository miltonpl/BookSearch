//
//  CellModelView.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "CellModelView.h"

@interface CellModelView()
@property (nonatomic, strong) Book *book;

@end

@implementation CellModelView
@synthesize url = _url;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (instancetype) initWithBook:(Book *)book
{
    self = [super init];
    if (self) {
        self.book = book;
    }
    return self;
}

- (nonnull NSString*) title {
    return self.book.title;
}

- (nonnull NSString*) subtitle {
    return self.book.subtitle;
}

- (nonnull NSURL*) url {
    return [[NSURL alloc] initWithString:self.book.thumbnail];
}

@end
