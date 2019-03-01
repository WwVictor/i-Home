//
//  RoomExistDeviceCell.m
//  i-Home
//
//  Created by Frank on 2019/3/1.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "RoomExistDeviceCell.h"

@implementation RoomExistDeviceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    _iconImageView = [UIImageView new];
    _iconImageView.image = [UIImage imageNamed:@"灯泡"];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(50);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    
    _deviceNameLabel = [UILabel new];
    _deviceNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [_deviceNameLabel setFont:[UIFont systemFontOfSize:21.0]];
    
    [self.contentView addSubview:_deviceNameLabel];
    [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(30);
        make.height.mas_equalTo(50);
    }];
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
