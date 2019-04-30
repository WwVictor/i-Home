//
//  SocketView.h
//  iThing
//
//  Created by Frank on 2018/8/2.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
@class SocketMoreBtn;
@interface SocketView : UIView


@property (nonatomic, strong)SocketMoreBtn *scheduleBtn;

@property (nonatomic, strong)SocketMoreBtn *countdownBtn;


@property (nonatomic, assign)BOOL isActionSet;

@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIButton *selectButton;
@property (nonatomic, strong)UILabel *electricityLabel;
@property (nonatomic, strong)UIButton *electricityRecordBtn;
@property (nonatomic, strong)UIButton *actionBtn;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)void(^cancelBlock)(NSInteger);
@property (nonatomic, strong)void(^actionBlock)(NSInteger);
@property (nonatomic, strong)void(^selectBlock)(BOOL);
@property (nonatomic, strong)DeviceStatusModel *devStatus;
@property (nonatomic, strong)void(^deviceControlBlock)(DeviceStatusModel *devStatusModel);
- (void)createUI;
@end
@interface SocketMoreBtn : UIControl
@property (nonatomic,strong)UIImageView *titleImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@end
