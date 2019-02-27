//
//  AddMoodButton.m
//  iThing
//
//  Created by Frank on 2018/7/30.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "AddMoodButton.h"

@implementation AddMoodButton
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addUI];
    }
    return self;
}
- (void)addUI
{
    self.iconBtn = [[UIButton alloc] init];
    self.iconBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:.9];
    self.iconBtn.userInteractionEnabled = NO;
    [self addSubview:self.iconBtn];
    self.iconBtn.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .widthIs(self.bounds.size.width)
    .heightIs(self.bounds.size.width);
    self.iconBtn.layer.cornerRadius = (self.bounds.size.width)/2.0;
    self.iconBtn.layer.masksToBounds = YES;
    
//    self.titleImageView = [[UIImageView alloc] init];
//    [self addSubview:self.titleImageView];
//    self.titleImageView.sd_layout
//    .leftSpaceToView(self, 0)
//    .topSpaceToView(self, 0)
//    .widthIs(self.bounds.size.width)
//    .heightIs(self.bounds.size.width);
//    self.titleImageView.layer.cornerRadius = (self.bounds.size.width)/2.0;
//    self.titleImageView.layer.masksToBounds = YES;
    
    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.text = @"Add Mood";
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"008DD4"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self.iconBtn, 5)
    .rightSpaceToView(self, 0)
    .heightIs(20);
}
//- (void)addDeviceBtnAction
//{
//    self.selectBlock(0);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
