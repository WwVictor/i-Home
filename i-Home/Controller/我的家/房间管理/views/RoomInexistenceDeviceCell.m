//
//  RoomInexistenceDeviceCell.m
//  i-Home
//
//  Created by Frank on 2019/3/1.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "RoomInexistenceDeviceCell.h"

@implementation RoomInexistenceDeviceCell
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
    _addButton = [UIButton new];
    [_addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_addButton setImage:[UIImage imageNamed:@"加设备"] forState:UIControlStateNormal];
    [self.contentView addSubview:_addButton];
    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(25);
    }];
    
    _iconImageView = [UIImageView new];
    _iconImageView.image = [UIImage imageNamed:@"灯泡"];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_addButton.mas_right).offset(50);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    
    _deviceNameLabel = [UILabel new];
    _deviceNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [_deviceNameLabel setFont:[UIFont systemFontOfSize:21.0]];
    [self.contentView addSubview:_deviceNameLabel];
    [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    _roomNameLabel = [UILabel new];
    _roomNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
    [_roomNameLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.contentView addSubview:_roomNameLabel];
    [_roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_deviceNameLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(_iconImageView.mas_right).offset(30);
        make.height.mas_equalTo(30);
    }];
    
}
- (void)addButtonAction
{
    self.addDeviceBlock(self.deviceNameLabel.text);
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
