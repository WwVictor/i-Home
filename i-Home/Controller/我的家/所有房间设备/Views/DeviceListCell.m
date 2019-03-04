//
//  DeviceListCell.m
//  i-Home
//
//  Created by Frank on 2019/2/28.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "DeviceListCell.h"

@implementation DeviceListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _backView = [UIView new];
    _backView.backgroundColor = [UIColor whiteColor];
//    _backView.layer.shadowColor = [UIColor colorWithHexString:@"999999"].CGColor;
//    _backView.layer.shadowOffset = CGSizeMake(0,3);
//    _backView.layer.shadowOpacity = 1;
//    _backView.layer.shadowRadius = 2;
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.contentView).offset(5);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
    }];
    
    _bgView = [UIView new];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_backView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backView).offset(20);
        make.top.mas_equalTo(_backView).offset(20);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
    }];
    _bgView.layer.borderWidth = 0.5;
    _bgView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    
    _iconImageView = [UIImageView new];
    _iconImageView.image = [UIImage imageNamed:@"灯泡"];
    [_bgView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bgView);
        make.centerY.mas_equalTo(_bgView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    
    _deviceNameLabel = [UILabel new];
    _deviceNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    if (@available(iOS 8.2, *)) {
        [_deviceNameLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
    } else {
        [_deviceNameLabel setFont:[UIFont systemFontOfSize:16.0]];
    }
    
    [_backView addSubview:_deviceNameLabel];
    [_deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView.mas_right).offset(15);
        make.top.mas_equalTo(_backView).offset(20+15);
        make.right.mas_equalTo(_backView.mas_right).offset(-80);
        make.height.mas_equalTo(20);
    }];
    
    _devStatusLabel = [UILabel new];
    _devStatusLabel.textColor = [UIColor colorWithHexString:@"999999"];
    if (@available(iOS 8.2, *)) {
        [_devStatusLabel setFont:[UIFont systemFontOfSize:12.0 weight:UIFontWeightMedium]];
    } else {
        [_devStatusLabel setFont:[UIFont systemFontOfSize:12.0]];
    }
    
    [_backView addSubview:_devStatusLabel];
    [_devStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bgView.mas_right).offset(15);
        make.top.mas_equalTo(_deviceNameLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(_backView.mas_right).offset(-80);
        make.height.mas_equalTo(20);
    }];
    
    
    _onoffButton = [UIButton new];
    [_onoffButton addTarget:self action:@selector(onoffButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_onoffButton setImage:[UIImage imageNamed:@"开关_online"] forState:UIControlStateNormal];
    [_backView addSubview:_onoffButton];
    
    [_onoffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backView.mas_right).offset(-15);
        make.top.mas_equalTo(_backView).offset(30);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    _onoffButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    _onoffButton.layer.borderWidth = 0.5;
    _onoffButton.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
    _onoffButton.layer.cornerRadius = 25;
    _onoffButton.layer.masksToBounds = YES;
    
    
}
-(void)configWithInfo:(DeviceInformationModel *)devInfoModel andStatusModel:(DeviceStatusModel *)devStatusModel
{
    _deviceNameLabel.text = devInfoModel.name;
    if (devStatusModel.offline == 0) {
        _devStatusLabel.text = @"离线";
    }else{
        if (devStatusModel.onoff == 1) {
            _devStatusLabel.text = @"已打开";
        }else{
            _devStatusLabel.text = @"已关闭";
        }
    }
    
}

- (void)onoffButtonAction
{
    
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
