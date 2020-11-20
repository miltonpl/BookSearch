//
//  BookTableViewCell.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <UIKit/UIKit.h>
#import "CellModelView.h"
#import "UIImageView+DownloadImage.h"
NS_ASSUME_NONNULL_BEGIN

@interface BookTableViewCell : UITableViewCell
- (void)configureWithCellModelProtocol: (nonnull id<CellModelProtocol>)model;

@end

NS_ASSUME_NONNULL_END
