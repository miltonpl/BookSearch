//
//  BookDetailsViewController.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "CellModelView.h"
#import "BookDetailTableViewCell.h"
#import "UIImageView+DownloadImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookDetailsViewController : UIViewController
- (void)configureWithBook: (Book *)book;
@end

NS_ASSUME_NONNULL_END
