//
//  EditRoomNameCell.m
//  i-Home
//
//  Created by Frank on 2019/3/1.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "EditRoomNameCell.h"

@implementation EditRoomNameCell
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
    _roomNameLabel.text = @"房间";
    _roomNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [_roomNameLabel setFont:[UIFont systemFontOfSize:21.0]];
    [self.contentView addSubview:_roomNameLabel];
    [_roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(50);
    }];
    
    
    // 房间名称输入框
    self.roomNameTextField = [[UITextField alloc] init];
    self.roomNameTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.roomNameTextField.font = [UIFont systemFontOfSize:21];
    self.roomNameTextField.borderStyle = UITextBorderStyleNone;
    [self.contentView addSubview:self.roomNameTextField];
    [self.roomNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(_roomNameLabel.mas_right).offset(50);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
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
