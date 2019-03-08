//
//  SetRGBDeviceView.h
//  iThing
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerView.h"
//#import "MyFileHeader.h"
@class SetRGBDeviceMoreBtn;
@interface SetRGBDeviceView : UIView<UIGestureRecognizerDelegate,ZWColorPickerDelegate>
@property(nonatomic,strong)UISegmentedControl *segment;
@property (nonatomic, strong)UIButton *actionBtn;
@property (nonatomic, strong)UILabel *brightnessSize;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIView *thumblView;

@property (nonatomic, assign)BOOL isActionSet;

@property (nonatomic, strong)UIImageView *colorImageView;
@property (nonatomic, strong)UIView *sliderView;
@property (nonatomic, strong)UIImageView *imageView1;
@property (nonatomic, strong)UIImageView *imageView2;

@property (nonatomic, strong)UIImageView *tempColorImageView;
@property (nonatomic, strong)UIView *tempSliderView;
@property (nonatomic, strong)UIImageView *tempImageView1;
@property (nonatomic, strong)UIImageView *tempImageView2;

@property (nonatomic, strong)UIImageView *colorImageView1;


@property (nonatomic, strong)UIView *colorBgView;
@property (nonatomic, strong)ColorPickerView *colorPickerView;

@property (nonatomic, strong)UIButton *sweetBtn;
@property (nonatomic, strong)UIButton *changesBtn;
@property (nonatomic, strong)UIButton *illuminationBtn;
@property (nonatomic, strong)UIButton *romanceBtn;
@property (nonatomic, strong)UIButton *jumpBtn;
@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)void(^cancelBlock)(NSInteger);
@property (nonatomic, strong)void(^actionBlock)(NSInteger);
@property (nonatomic, strong)void(^deviceControlBlock)(DeviceStatusModel *devStatusModel);
- (void)createUI;
@property (nonatomic, assign)BOOL isFlag;

@property (nonatomic, strong)SetRGBDeviceMoreBtn *scheduleBtn;
@property (nonatomic, strong)SetRGBDeviceMoreBtn *countdownBtn;

@end
@interface SetRGBDeviceMoreBtn : UIControl
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
