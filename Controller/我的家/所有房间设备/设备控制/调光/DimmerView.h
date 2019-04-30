//
//  DimmerView.h
//  iThing
//
//  Created by Frank on 2018/8/15.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
@class DimmerMoreBtn;
@interface DimmerView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, assign)BOOL isActionSet;
@property (nonatomic, strong)UILabel *brightnessSize;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *thumblView;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIButton *actionBtn;

@property (nonatomic, strong)DimmerMoreBtn *scheduleBtn;
@property (nonatomic, strong)DimmerMoreBtn *countdownBtn;


@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)void(^cancelBlock)(NSInteger);
@property (nonatomic, strong)void(^actionBlock)(NSInteger);
//@property (nonatomic, strong)void(^selectDimmerBlock)(BOOL isOn, int brightSize);
@property (nonatomic, strong)void(^deviceControlBlock)(DeviceStatusModel *devStatusModel);
@property (nonatomic, assign)BOOL isFlag;
- (void)createUI;
@end
@interface DimmerMoreBtn : UIControl
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *titleLabel;

@end
