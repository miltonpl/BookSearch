//
//  Book.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/13/20.
//

#import "Book.h"

@implementation Book

- (instancetype)initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    if (self) {
        NSDictionary * volumeInfo = [[NSDictionary alloc] initWithDictionary: dictionary[@"volumeInfo"]];
        NSDictionary * imageLinks = [[NSDictionary alloc] initWithDictionary: volumeInfo[@"imageLinks"]];
        //@property NSString
        self.title = volumeInfo[@"title"];
        self.subtitle = volumeInfo[@"subtitle"];
        NSArray *tempArray = volumeInfo[@"authors"];
        self.author = [tempArray firstObject];
        
        self.publishedDate = volumeInfo[@"publishedDate"];
        self.descriptionInfo = volumeInfo[@"description"];
//        self.pageCount = volumeInfo[@"pageCount"];
//        self.averageRating = volumeInfo[@"averageRating"];

        self.pageCount = @"pageCount";
        self.averageRating = @"averageRating";

        self.language = volumeInfo[@"language"];
        self.infoLink = volumeInfo[@"infoLink"];
        self.previewLink = volumeInfo[@"previewLink"];
        //@property NSArray
        NSArray *tempArray2 = volumeInfo[@"categories"];
        self.category =  [tempArray2 firstObject];;
        self.publisher = volumeInfo[@"publisher"];
        //@property NSString
        self.thumbnail = imageLinks[@"thumbnail"];
    }
    
    return self;
}

@end
