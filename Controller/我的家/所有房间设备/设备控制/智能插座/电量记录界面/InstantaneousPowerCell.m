//
//  InstantaneousPowerCell.m
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "InstantaneousPowerCell.h"
#import "Masonry.h"
@implementation InstantaneousPowerCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    return self;
}
- (void)configWithTitleName:(NSString *)titleName withDetailName:(NSString *)detailName
{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.dataLabel = [[UILabel alloc] init];
    self.dataLabel.text = titleName;
    if (@available(iOS 8.2, *)) {
        self.dataLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }else {
        self.dataLabel.font = [UIFont systemFontOfSize:18.0];
    }
    self.dataLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.dataLabel];
    [self.dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.height.mas_equalTo(30);
    }];
    self.electricityLabel = [[UILabel alloc] init];
    self.electricityLabel.textAlignment = NSTextAlignmentRight;
    self.electricityLabel.text = detailName;
    self.electricityLabel.textColor = [UIColor colorWithHexString:@"FF4849" alpha:1.0];
    if (@available(iOS 8.2, *)) {
        self.electricityLabel.font = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }else {
        self.electricityLabel.font = [UIFont systemFontOfSize:18.0];
    }
    [self.contentView addSubview:self.electricityLabel];
    [self.electricityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.left.mas_equalTo(self.dataLabel.mas_right).offset(15);
        make.height.mas_equalTo(30);
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
