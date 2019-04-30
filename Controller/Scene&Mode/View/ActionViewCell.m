//
//  ActionViewCell.m
//  i-Home
//
//  Created by Divella on 2019/3/5.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "ActionViewCell.h"
#import "UIView+SDAutoLayout.h"

@implementation ActionViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)createUI{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:self.imageV];
    
    self.imageV.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(40)
    .heightIs(40);
    
    self.taskName = [[UILabel alloc] init];
    [self.contentView addSubview:self.taskName];
    self.taskName.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.imageV, 15)
    .widthIs(100)
    .heightIs(20);
    
    
    self.status = [[UILabel alloc] init];
    [self.contentView addSubview:self.status];
    self.status.sd_layout
    .topSpaceToView(self.taskName, 5)
    .leftSpaceToView(self.imageV, 15)
    .widthIs(50)
    .heightIs(18);
    
    self.loc_Room = [[UILabel alloc] init];
    [self.contentView addSubview:self.loc_Room];
    self.loc_Room.sd_layout
    .topSpaceToView(self.taskName, 5)
    .leftSpaceToView(self.status, 5)
    .widthIs(50)
    .heightIs(18);
    
    self.actionName = [[UILabel alloc] init];
    [self.contentView addSubview:self.actionName];
    self.actionName.sd_layout
    .centerXEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(100)
    .heightIs(20);

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
