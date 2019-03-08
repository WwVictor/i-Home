//
//  DeviceListCell.h
//  i-Home
//
//  Created by Frank on 2019/2/28.
//  Copyright © 2019 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface DeviceListCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *deviceNameLabel;
@property (nonatomic, strong)UILabel *devStatusLabel;
@property (nonatomic, strong)UIButton *onoffButton;
@property (nonatomic, strong)DeviceInformationModel *deviceInfo;
@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)void(^deviceBlock)(DeviceInformationModel *devInfo,DeviceStatusModel *devSta);
-(void)configWithInfo:(DeviceInformationModel *)devInfoModel andStatusModel:(DeviceStatusModel *)devStatusModel;
@end

NS_ASSUME_NONNULL_END
