//
//  DeviceSceneCell.m
//  iThing
//
//  Created by Frank on 2018/8/3.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "DeviceSceneCell.h"

@implementation DeviceSceneCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    self.iconImageView.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 20)
    .heightIs(30)
    .widthIs(30);
    
    self.sceneName = [[UILabel alloc] init];
    [self.contentView addSubview:self.sceneName];
    self.sceneName.sd_layout
    .centerYEqualToView(self.contentView)
    .leftSpaceToView(self.iconImageView, 30)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(30);
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
