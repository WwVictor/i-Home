//
//  SmartTableVCell.m
//  i-Home
//
//  Created by Divella on 2019/2/28.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "SmartTableVCell.h"
#import "MyFileHeader.h"

@implementation SmartTableVCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.backgroundV = [[UIView alloc] init];
    
    self.backgroundV.backgroundColor = [UIColor whiteColor];
    self.backgroundV.layer.shadowColor = [UIColor colorWithHexString:@"999999"].CGColor;
    self.backgroundV.layer.shadowOffset = CGSizeMake(0,3);
    self.backgroundV.layer.shadowOpacity = 1;
    self.backgroundV.layer.shadowRadius = 2;
    self.backgroundV.layer.cornerRadius = 5;
    [self.contentView addSubview:self.backgroundV];
    self.backgroundV.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .bottomEqualToView(self.contentView);
    
    self.iconImagv = [[UIImageView alloc] init];
    [self.backgroundV addSubview:self.iconImagv];
    self.iconImagv.sd_layout
    .topSpaceToView(self.backgroundV, 10)
    .leftSpaceToView(self.backgroundV, 10)
    .bottomSpaceToView(self.backgroundV, 10)
    .widthIs(50);
    
    self.titleLab = [[UILabel alloc] init];
    [self.backgroundV addSubview:self.titleLab];
    
    self.titleLab.sd_layout
    .leftSpaceToView(self.iconImagv, 10)
    .centerYEqualToView(self.backgroundV)
    .heightIs(25)
    .widthIs(150);
    

    self.SwitchBtn = [[UIButton alloc] init];
    [self.backgroundV addSubview:self.SwitchBtn];
    
    self.SwitchBtn.sd_layout
    .topSpaceToView(self.backgroundV, 10)
    .rightSpaceToView(self.backgroundV, 10)
    .bottomSpaceToView(self.backgroundV, 10)
    .widthIs(50);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
