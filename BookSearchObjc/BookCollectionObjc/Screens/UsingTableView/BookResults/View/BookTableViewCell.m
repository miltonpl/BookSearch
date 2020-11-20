//
//  BookTableViewCell.m
//  BookCollectionObjc
//
//  Created by Milton Palaguachi on 11/14/20.
//

#import "BookTableViewCell.h"

@implementation BookTableViewCell {
    
    __weak IBOutlet UIImageView *bookImageView;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *subtitleLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}
- (void)configureWithCellModelProtocol: (nonnull id<CellModelProtocol>)model {
    titleLabel.text = model.title;
    subtitleLabel.text = model.subtitle;
    [bookImageView downloadImage: model.url];
    
}


@end
