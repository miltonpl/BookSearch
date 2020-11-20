//
//  Book.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/13/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSString *publisher;
@property (nonatomic, strong) NSString *publishedDate;
@property (nonatomic, strong) NSString *descriptionInfo;
@property (nonatomic, strong) NSString *pageCount;
@property (nonatomic, strong) NSString *averageRating;
@property (nonatomic, strong) NSString *language;

@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *infoLink;
@property (nonatomic, strong) NSString *previewLink;
@property (nonatomic)int uniqueId;

@end

NS_ASSUME_NONNULL_END



















