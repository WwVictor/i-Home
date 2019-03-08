//
//  AirConditioningView.h
//  iThing
//
//  Created by Frank on 2018/8/8.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
@class AirConditioningMoreBtn;
@interface AirConditioningView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong)AirConditioningMoreBtn *scheduleBtn;

@property (nonatomic, strong)AirConditioningMoreBtn *countdownBtn;


@property (nonatomic, assign)BOOL isActionSet;
@property (nonatomic, strong)UILabel *brightnessSize;
@property (nonatomic, strong)UIButton *addButton;
@property (nonatomic, strong)UIButton *subtractButton;
@property (nonatomic, strong)UIButton *actionBtn;
@property (nonatomic, strong)UIView *bgView;


@property (nonatomic, strong)UIView *offView;
@property (nonatomic, strong)UILabel *offLabel;

@property (nonatomic, strong)UIView *heatView;
@property (nonatomic, strong)UILabel *heatLabel;

@property (nonatomic, strong)UIView *coolView;
@property (nonatomic, strong)UILabel *coolLabel;

@property(nonatomic,strong)UISegmentedControl *segment;

@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)void(^cancelBlock)(NSInteger);
@property (nonatomic, strong)void(^actionBlock)(NSInteger);
@property (nonatomic, assign)NSInteger selectStatus;
@property (nonatomic, assign)int temperatureNum;
@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)void(^deviceControlBlock)(DeviceStatusModel *devStatusModel);
- (void)createUI;
@end
@interface AirConditioningMoreBtn : UIControl
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
