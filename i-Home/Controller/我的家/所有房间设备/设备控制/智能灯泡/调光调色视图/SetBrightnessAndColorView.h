//
//  SetBrightnessAndColorView.h
//  iThing
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
@class SetBrightnessAndColorMoreBtn;
//颜色绘制类型
typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到小
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};
@interface SetBrightnessAndColorView : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, assign)BOOL isActionSet;
@property (nonatomic, strong)UILabel *brightnessSize;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *thumblView;
@property (nonatomic, strong)UIButton *actionBtn;
@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)UIImageView *colorImageView;
@property (nonatomic, strong)UIView *sliderView;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)void(^cancelBlock)(NSInteger);
@property (nonatomic, strong)void(^actionBlock)(NSInteger);
@property (nonatomic, strong)void(^deviceControlBlock)(DeviceStatusModel *devStatusModel);

@property (nonatomic, strong)SetBrightnessAndColorMoreBtn *scheduleBtn;

@property (nonatomic, strong)SetBrightnessAndColorMoreBtn *countdownBtn;
@property (nonatomic, assign)BOOL isFlag;

- (void)createUI;
@end
@interface SetBrightnessAndColorMoreBtn : UIControl
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
