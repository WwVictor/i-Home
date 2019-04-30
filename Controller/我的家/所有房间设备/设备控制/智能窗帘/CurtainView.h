//
//  CurtainView.h
//  iThing
//
//  Created by Frank on 2018/8/8.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
@class CurtainMoreBtn;
@interface CurtainView : UIView<UIGestureRecognizerDelegate>


@property (nonatomic, strong)CurtainMoreBtn *scheduleBtn;

@property (nonatomic, strong)CurtainMoreBtn *countdownBtn;


@property (nonatomic, strong)UILabel *brightnessSize;
@property (nonatomic, strong)UIView *bgView;
@property (nonatomic, strong)UIButton *actionBtn;
@property (nonatomic, strong)UIView *openView;
@property (nonatomic, strong)UILabel *openLabel;

@property (nonatomic, strong)UIView *stopView;
@property (nonatomic, strong)UILabel *stopLabel;

@property (nonatomic, assign)BOOL isActionSet;

@property (nonatomic, strong)UIView *closeView;
@property (nonatomic, strong)UILabel *closeLabel;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)void(^cancelBlock)(NSInteger);
@property (nonatomic, strong)void(^actionBlock)(NSInteger);
@property (nonatomic, assign)NSInteger selectStatus;
@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)void(^deviceControlBlock)(DeviceStatusModel *devStatusModel);
- (void)createUI;
@end
@interface CurtainMoreBtn : UIControl
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
