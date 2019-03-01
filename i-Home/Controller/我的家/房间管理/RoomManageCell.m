//
//  RoomManageCell.m
//  i-Home
//
//  Created by Frank on 2019/3/1.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "RoomManageCell.h"

@implementation RoomManageCell
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
    
    _roomNameLabel = [UILabel new];
    _roomNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    if (@available(iOS 8.2, *)) {
        [_roomNameLabel setFont:[UIFont systemFontOfSize:21.0 weight:UIFontWeightMedium]];
    } else {
        [_roomNameLabel setFont:[UIFont systemFontOfSize:21.0]];
    }
    
    [self.contentView addSubview:_roomNameLabel];
    [_roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(50);
    }];
    
    _deviceNumLabel = [UILabel new];
    _deviceNumLabel.textAlignment = NSTextAlignmentRight;
    _deviceNumLabel.textColor = [UIColor colorWithHexString:@"999999"];
//    if (@available(iOS 8.2, *)) {
//        [_deviceNumLabel setFont:[UIFont systemFontOfSize:19.0 weight:UIFontWeightMedium]];
//    } else {
        [_deviceNumLabel setFont:[UIFont systemFontOfSize:17.0]];
//    }
    
    [self.contentView addSubview:_deviceNumLabel];
    [_deviceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
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
