//
//  RoomControl.m
//  iThing
//
//  Created by Frank on 2018/9/21.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "RoomControl.h"
#import "UIView+SDAutoLayout.h"
#import "CommonTools.h"
#import "UIColor+YTExtension.h"


@implementation RoomControl
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addUI];
    }
    return self;
}
- (void)addUI
{
    self.titleImageView = [[UIImageView alloc] init];
    [self addSubview:self.titleImageView];
    self.titleImageView.sd_layout
    .topSpaceToView(self, 7.5)
    .rightSpaceToView(self, 0)
    .widthIs(15)
    .bottomSpaceToView(self, 7.5);
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .rightSpaceToView(self.titleImageView, 0)
    .topSpaceToView(self, 5)
    .leftSpaceToView(self, 0)
    .heightIs(20);
}

@end
