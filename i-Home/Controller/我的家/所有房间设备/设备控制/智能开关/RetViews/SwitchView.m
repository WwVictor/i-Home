//
//  SwitchView.m
//  iThing
//
//  Created by Frank on 2018/7/31.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "SwitchView.h"
#import "MyFileHeader.h"
@interface SwitchView();

@end

@implementation SwitchView
//@synthesize nkColorSwitch = _nkColorSwitch;

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = self.frame;
        [self addSubview:effectView];
//        [self createUI];
    }
    return self;
}
- (void)createUI
{
    
    self.switchStatusLabel = [[UILabel alloc] init];
    [self addSubview:self.switchStatusLabel];

    
    self.switchStatusLabel.textColor = [UIColor whiteColor];
    self.switchStatusLabel.font = [UIFont systemFontOfSize:21];
    self.switchStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.switchStatusLabel.sd_layout
    .topSpaceToView(self, SafeAreaTopHeight)
    .leftSpaceToView(self, 50)
    .rightSpaceToView(self, 50)
    .heightIs(20);
    
//    self.actionBtn = [[UIButton alloc] init];
//    [self.actionBtn setImage:[UIImage imageNamed:@"time_icon"] forState:UIControlStateNormal];
//    [self.actionBtn addTarget:self action:@selector(actionBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.actionBtn];
//    self.actionBtn.sd_layout
//    .topSpaceToView(self, SafeAreaTopHeight-5)
//    .rightSpaceToView(self, 15)
//    .widthIs(30)
//    .heightIs(30);
//    self.actionBtn = [[UIButton alloc] init];
//    [self.actionBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
//    [self.actionBtn addTarget:self action:@selector(actionBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.actionBtn];
//    self.actionBtn.sd_layout
//    .topSpaceToView(self, 20)
//    .rightSpaceToView(self, 15)
//    .widthIs(25)
//    .heightIs(25);
    
    
//    if (self.devStatus.serial_type == 1) {
//        self.nkColorSwitch = [[ZQTColorSwitch alloc] initWithFrame:CGRectMake((KScreenWidth-(160*KScreenWidth/375.0))/2, (KScreenHeight-(320*KScreenHeight/667.0))/2, (160*KScreenWidth/375.0), (320*KScreenHeight/667.0))];
//        self.nkColorSwitch.devStatus = self.devStatus;
//        [self.nkColorSwitch setupUI];
//        [self addSubview:self.nkColorSwitch];
//    }else{
        
        
        if (self.isActionSet) {
            self.nkColorSwitch = [[ZQTColorSwitch alloc] initWithFrame:CGRectMake((KScreenWidth-(160*KScreenWidth/375.0))/2, (KScreenHeight-(320*KScreenHeight/667.0))/2, (160*KScreenWidth/375.0), (320*KScreenHeight/667.0))];
            self.nkColorSwitch.devStatus = self.devStatus;
            [self.nkColorSwitch setupUI];
            [self addSubview:self.nkColorSwitch];
        }else{
            self.nkColorSwitch = [[ZQTColorSwitch alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-(160*KScreenWidth/375.0))/2, ([UIScreen mainScreen].bounds.size.height-(320*KScreenHeight/667.0)-110)/2, (160*KScreenWidth/375.0), (320*KScreenHeight/667.0))];
            self.nkColorSwitch.devStatus = self.devStatus;
            [self.nkColorSwitch setupUI];
            [self addSubview:self.nkColorSwitch];
            self.electricityLabel = [[UILabel alloc] init];
            [self addSubview:self.electricityLabel];
            self.electricityLabel.text = [NSString stringWithFormat:@"%@%dW",Localized(@"tx_engery"),self.devStatus.engery];
            self.electricityLabel.font = [UIFont systemFontOfSize:19];
            self.electricityLabel.textColor = [UIColor whiteColor];
            self.electricityLabel.textAlignment = NSTextAlignmentCenter;
            self.electricityLabel.sd_layout
            .topSpaceToView(self.nkColorSwitch, 20)
            .leftSpaceToView(self, 20)
            .rightSpaceToView(self, 20)
            .heightIs(20);
            
            self.electricityRecordBtn = [[UIButton alloc] init];
            [self.electricityRecordBtn setImage:[UIImage imageNamed:@"analytics"] forState:UIControlStateNormal];
            [self.electricityRecordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.electricityRecordBtn];
            self.electricityRecordBtn.sd_layout
            .topSpaceToView(self.electricityLabel, 20)
            .centerXEqualToView(self)
            .widthIs(50)
            .heightIs(50);
        }
        
        
//    }
    
    [self.nkColorSwitch addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventValueChanged];
    
    if (self.isActionSet) {
        if (self.devStatus.onoff == 0) {
            //       self.switchStatusLabel.text = Localized(@"Opened");
            //        self.nkColorSwitch.thumbBackLabel.text = Localized(@"Close");
            self.switchStatusLabel.text = Localized(@"Close");
        }else{
            self.switchStatusLabel.text = Localized(@"Open");
            
            //        self.nkColorSwitch.thumbBackLabel.text = Localized(@"Open");
        }
    }else{
        if (self.devStatus.offline == 1) {
            self.switchStatusLabel.text = Localized(@"tx_user_notice_device_status_offline");
        }else{
            if (self.devStatus.onoff == 0) {
                //       self.switchStatusLabel.text = Localized(@"Opened");
                //        self.nkColorSwitch.thumbBackLabel.text = Localized(@"Close");
                self.switchStatusLabel.text = Localized(@"Close");
            }else{
                self.switchStatusLabel.text = Localized(@"Open");
                
                //        self.nkColorSwitch.thumbBackLabel.text = Localized(@"Open");
            }
        }
    }
    
    
    
   
    
    self.nkColorSwitch.onBackLabel.text = Localized(@"Open");
    self.nkColorSwitch.onBackLabel.textColor = [UIColor blackColor];
    self.nkColorSwitch.offBackLabel.text = Localized(@"Close");
    self.nkColorSwitch.offBackLabel.textColor = [UIColor blackColor];
    typeof(self) weakSelf = self;
    [weakSelf.nkColorSwitch setStatusBlock:^(BOOL on) {
        if (on) {
            self.switchStatusLabel.text = Localized(@"Open");
            self.devStatus.onoff = 1;
            self.deviceControlBlock(self.devStatus);
        }else{
            self.switchStatusLabel.text = Localized(@"Close");
            self.devStatus.onoff = 0;
            self.deviceControlBlock(self.devStatus);
        }
    }];
    [self.nkColorSwitch setShape:kNKColorSwitchShapeRectangle];
    
    
    
    
    
//    self.cancelBtn = [[UIButton alloc] init];
//    [self.cancelBtn setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
//    [self.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.cancelBtn];
//    self.cancelBtn.sd_layout
//    .bottomSpaceToView(self, 34)
//    .centerXEqualToView(self)
//    .widthIs(50)
//    .heightIs(50);
    
    
    UIImage *iconImage = [UIImage imageNamed:@"返回"];
    self.cancelBtn = [[UIButton alloc] init];
    [self.cancelBtn setImage:[LYTools imageWithColor:[UIColor colorWithHexString:@"FFFFFF"] withImage:iconImage] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelBtn];
    self.cancelBtn.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, 15)
    .widthIs(25)
    .heightIs(25);

//    self.scheduleBtn = [[SwitchMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-104, 80, 60)];
//    [self addSubview:self.scheduleBtn];
//    self.scheduleBtn.titleImageView.image = [UIImage imageNamed:@"定时"];
//    self.scheduleBtn.titleLabel.text = Localized(@"tx_schedular_timing");
//    [self.scheduleBtn addTarget:self action:@selector(scheduleBtnAction) forControlEvents:UIControlEventTouchUpInside];
//
//
//
//
//
//
//    self.countdownBtn = [[SwitchMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
//    [self addSubview:self.countdownBtn];
//    self.countdownBtn.titleImageView.image = [UIImage imageNamed:@"倒计时"];
//    self.countdownBtn.titleLabel.text = Localized(@"tx_countdown_timing");
//    [self.countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
}
- (void)actionBtnAction
{
    self.actionBlock(1);
}
- (void)recordAction
{
    self.cancelBlock(1);
}
- (void)scheduleBtnAction
{
    self.actionBlock(2);
}

- (void)countdownBtnAction
{
    self.actionBlock(3);
}
- (void)cancelBtnAction
{
    self.cancelBlock(0);
//    NSArray *result=[self.backView subviews];
//    for (UIView *view in result) {
//        [view removeFromSuperview];
//    }
//    //动画效果淡出
//    [UIView animateWithDuration:0.2 animations:^{
//        self.alpha = 0;
//        self.backView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [self removeFromSuperview];
//        }
//    }];
}
#pragma mark NKColorSwitch
- (void)switchPressed:(id)sender
{
    ZQTColorSwitch *nkswitch = (ZQTColorSwitch *)sender;
    if (nkswitch.isOn)
        NSLog(@"switchPressed ON");
    else
        NSLog(@"switchPressed OFF");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
@implementation SwitchMoreBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self addUI];
    }
    return self;
}
- (void)addUI
{
    self.titleImageView = [[UIImageView alloc] init];
    [self addSubview:self.titleImageView];
    self.titleImageView.sd_layout
    .leftSpaceToView(self, 25)
    .topSpaceToView(self, 25)
    .widthIs(self.bounds.size.width-50)
    .heightIs(self.bounds.size.width-50);
    //    self.titleImageView.layer.cornerRadius = (self.bounds.size.width)/2.0;
    //    self.titleImageView.layer.masksToBounds = YES;
    self.titleLabel = [[UILabel alloc] init];
    //    self.titleLabel.text = @"Add Mood";
    self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"FFFFFF"];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self.titleImageView, 0)
    .rightSpaceToView(self, 0)
    .heightIs(20);
}

@end
