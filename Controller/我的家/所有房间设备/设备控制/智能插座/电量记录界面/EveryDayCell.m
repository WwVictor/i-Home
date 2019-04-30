//
//  EveryDayCell.m
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "EveryDayCell.h"

@implementation EveryDayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    return self;
}
- (void)configWithTitleName:(NSString *)titleName withDetailName:(NSString *)detailName
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.dataLabel = [[UILabel alloc] init];
    self.dataLabel.text = titleName;
    self.dataLabel.font = [UIFont systemFontOfSize:18];
    self.dataLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.dataLabel];
    self.dataLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(25)
    .widthIs(120);

    self.electricityLabel = [[UILabel alloc] init];
    self.electricityLabel.textAlignment = NSTextAlignmentRight;
    
    self.electricityLabel.text = detailName;
    self.electricityLabel.font = [UIFont systemFontOfSize:16];
    self.electricityLabel.textColor = [UIColor colorWithHexString:@"666666" alpha:1.0];
    [self.contentView addSubview:self.electricityLabel];
    self.electricityLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.dataLabel, 10)
    .heightIs(25);
    
}
@end
