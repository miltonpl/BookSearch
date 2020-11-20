//
//  BookDetailTableViewCell.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "BookDetailTableViewCell.h"

@implementation BookDetailTableViewCell {
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *infoLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) configureWithCellViewModelProtocol :(nonnull id<CellModelProtocol>) model {
//    NSLog(@"%@, %@",model.title, model.subtitle);
    titleLabel.text = model.title;
    infoLabel.text = model.subtitle;
}
@end
