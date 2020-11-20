//
//  BookDetailTableViewCell.h
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import <UIKit/UIKit.h>
#import "CellModelView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BookDetailTableViewCell : UITableViewCell
- (void) configureWithCellViewModelProtocol :(nonnull id<CellModelProtocol>) model;
@end

NS_ASSUME_NONNULL_END
