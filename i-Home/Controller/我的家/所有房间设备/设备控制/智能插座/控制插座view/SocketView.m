//
//  SocketView.m
//  iThing
//
//  Created by Frank on 2018/8/2.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "SocketView.h"

@implementation SocketView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        if (@available(iOS 10.0, *)) {
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//            effectView.alpha = .96;
            effectView.frame = self.frame;
            [self addSubview:effectView];
        } else {
            // Fallback on earlier versions
        }
//        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.statusLabel = [[UILabel alloc] init];
    [self addSubview:self.statusLabel];
    
    
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.font = [UIFont systemFontOfSize:21];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.sd_layout
    .topSpaceToView(self, SafeAreaTopHeight)
    .leftSpaceToView(self, 50)
    .rightSpaceToView(self, 50)
    .heightIs(20);
    
//    self.statusLabel.textColor = [UIColor whiteColor];
//    self.statusLabel.font = [UIFont systemFontOfSize:21];
//    self.statusLabel.textAlignment = NSTextAlignmentCenter;
//    self.statusLabel.sd_layout
//    .topSpaceToView(self, 22.5)
//    .leftSpaceToView(self, 50)
//    .rightSpaceToView(self, 50)
//    .heightIs(20);
    
//    self.actionBtn = [[UIButton alloc] init];
//    [self.actionBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
//    [self.actionBtn addTarget:self action:@selector(actionBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.actionBtn];
//    self.actionBtn.sd_layout
//    .topSpaceToView(self, 20)
//    .rightSpaceToView(self, 15)
//    .widthIs(25)
//    .heightIs(25);
//    self.actionBtn = [[UIButton alloc] init];
//    [self.actionBtn setImage:[UIImage imageNamed:@"time_icon"] forState:UIControlStateNormal];
//    [self.actionBtn addTarget:self action:@selector(actionBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.actionBtn];
//    self.actionBtn.sd_layout
//    .topSpaceToView(self, SafeAreaTopHeight-5)
//    .rightSpaceToView(self, 15)
//    .widthIs(30)
//    .heightIs(30);
    
    
    
    
    
    
    
    
    self.selectButton = [[UIButton alloc] init];
    [self.selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectButton];
    
    if (self.isActionSet) {
        self.selectButton.sd_layout
        .topSpaceToView(self, (self.bounds.size.height-200)/2)
        .centerXEqualToView(self)
        .widthIs(200)
        .heightIs(200);
        
        if (self.devStatus.onoff == 0) {
            self.selectButton.selected = NO;
            [self.selectButton setImage:[UIImage imageNamed:@"socket_type_off"] forState:UIControlStateNormal];
            self.statusLabel.text = Localized(@"Close");
        }else{
            self.selectButton.selected = YES;
            [self.selectButton setImage:[UIImage imageNamed:@"socket_type_on"] forState:UIControlStateNormal];
            self.statusLabel.text = Localized(@"Open");
        }
    }else{
       
        self.selectButton.sd_layout
        .topSpaceToView(self, (self.bounds.size.height-150)/2-60)
        .centerXEqualToView(self)
        .widthIs(200)
        .heightIs(200);
        
        if (self.devStatus.offline == 1) {
            self.statusLabel.text = Localized(@"tx_user_notice_device_status_offline");
            if (self.devStatus.onoff == 0) {
                self.selectButton.selected = NO;
                [self.selectButton setImage:[UIImage imageNamed:@"socket_type_off"] forState:UIControlStateNormal];
            }else{
                self.selectButton.selected = YES;
                [self.selectButton setImage:[UIImage imageNamed:@"socket_type_on"] forState:UIControlStateNormal];
            }
        }else{
            if (self.devStatus.onoff == 0) {
                self.selectButton.selected = NO;
                [self.selectButton setImage:[UIImage imageNamed:@"socket_type_off"] forState:UIControlStateNormal];
                self.statusLabel.text = Localized(@"Close");
            }else{
                self.selectButton.selected = YES;
                [self.selectButton setImage:[UIImage imageNamed:@"socket_type_on"] forState:UIControlStateNormal];
                self.statusLabel.text = Localized(@"Open");
            }
        }
    }
    
    if (!self.isActionSet) {
        self.electricityLabel = [[UILabel alloc] init];
        [self addSubview:self.electricityLabel];
        self.electricityLabel.text = [NSString stringWithFormat:@"%@%dW",Localized(@"tx_engery"),self.devStatus.engery];
        self.electricityLabel.font = [UIFont systemFontOfSize:19];
        self.electricityLabel.textColor = [UIColor whiteColor];
        self.electricityLabel.textAlignment = NSTextAlignmentCenter;
        self.electricityLabel.sd_layout
        .topSpaceToView(self.selectButton, 20)
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
    
    UIImage *iconImage = [UIImage imageNamed:@"返回"];
    self.cancelButton = [[UIButton alloc] init];
    [self.cancelButton setImage:[LYTools imageWithColor:[UIColor colorWithHexString:@"FFFFFF"] withImage:iconImage] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    self.cancelButton.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, 15)
    .widthIs(25)
    .heightIs(25);
    
//    self.cancelButton = [[UIButton alloc] init];
//    [self.cancelButton setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
//    [self.cancelButton addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.cancelButton];
//    self.cancelButton.sd_layout
//    .bottomSpaceToView(self, 34)
//    .centerXEqualToView(self)
//    .widthIs(50)
//    .heightIs(50);
//    self.scheduleBtn = [[SocketMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-104, 80, 60)];
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
//    self.countdownBtn = [[SocketMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
//    [self addSubview:self.countdownBtn];
//    self.countdownBtn.titleImageView.image = [UIImage imageNamed:@"倒计时"];
//    self.countdownBtn.titleLabel.text = Localized(@"tx_countdown_timing");
//    [self.countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (self.devStatus.serial_type == 1) {
        self.selectButton.sd_layout
        .topSpaceToView(self, (self.bounds.size.height-200)/2)
        .centerXEqualToView(self)
        .widthIs(200)
        .heightIs(200);
        self.electricityLabel.alpha = 0;
        self.electricityRecordBtn.alpha = 0;
    }else{
        self.electricityLabel.alpha = 1;
        self.electricityRecordBtn.alpha = 1;
    }
}

- (void)scheduleBtnAction
{
    self.actionBlock(2);
}

- (void)countdownBtnAction
{
    self.actionBlock(3);
}


- (void)actionBtnAction
{
    self.actionBlock(1);
}
- (void)recordAction
{
    self.cancelBlock(1);
}
- (void)selectAction:(UIButton *)btn
{
    if (self.selectButton.selected) {
        self.selectButton.selected = !self.selectButton.selected;
        [self.selectButton setImage:[UIImage imageNamed:@"socket_type_off"] forState:UIControlStateNormal];
        
        self.statusLabel.text = Localized(@"Close");
        self.devStatus.onoff = 0;
//        self.selectBlock(NO);
    }else{
        self.selectButton.selected = !self.selectButton.selected;
        [self.selectButton setImage:[UIImage imageNamed:@"socket_type_on"] forState:UIControlStateNormal];
        self.statusLabel.text = Localized(@"Open");
        self.devStatus.onoff = 1;
//        self.selectBlock(YES);
    }
    
    self.deviceControlBlock(self.devStatus);
    
}
- (void)cancelBtnAction
{
    self.cancelBlock(0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
@implementation SocketMoreBtn

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
