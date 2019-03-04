//
//  HomeRoomListCell.m
//  i-Home
//
//  Created by Frank on 2019/3/4.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "HomeRoomListCell.h"

@implementation HomeRoomListCell

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
    _selectButton = [UIButton new];
    [_selectButton addTarget:self action:@selector(selectButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectButton];
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    _selectButton.layer.cornerRadius = 15;
    _selectButton.layer.masksToBounds = YES;
    _selectButton.selected = YES;
    _roomNameLabel = [UILabel new];
    _roomNameLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [_roomNameLabel setFont:[UIFont systemFontOfSize:21.0]];
    [self.contentView addSubview:_roomNameLabel];
    [_roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(30);
    }];
    
}
- (void)selectButtonAction
{
    if (self.selectButton.selected == YES) {
        self.selectButton.selected = NO;
        self.selectBlock(@"0");
    }else{
        self.selectButton.selected = YES;
        self.selectBlock(@"1");
    }
    
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
