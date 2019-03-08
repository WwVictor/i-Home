//
//  SwitchView.h
//  iThing
//
//  Created by Frank on 2018/7/31.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZQTColorSwitch.h"

@class SwitchMoreBtn;
@interface SwitchView : UIView

@property (nonatomic, strong)SwitchMoreBtn *scheduleBtn;
@property (nonatomic, strong)SwitchMoreBtn *countdownBtn;


@property (nonatomic, assign)BOOL isActionSet;

@property (nonatomic, strong)UILabel *switchStatusLabel;
@property (nonatomic, strong)ZQTColorSwitch *nkColorSwitch;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *actionBtn;
@property (nonatomic, strong)UILabel *electricityLabel;
@property (nonatomic, strong)UIButton *electricityRecordBtn;
@property (nonatomic, strong)void(^cancelBlock)(NSInteger);
@property (nonatomic, strong)void(^actionBlock)(NSInteger);
@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)void(^deviceControlBlock)(DeviceStatusModel *devStatusModel);
- (void)createUI;
@end
@interface SwitchMoreBtn : UIControl
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
