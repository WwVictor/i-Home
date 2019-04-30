//
//  CurtainView.m
//  iThing
//
//  Created by Frank on 2018/8/8.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "CurtainView.h"
//static const CGFloat kAnimateDuration = 0.3f;
#define VW(view) (view.frame.size.width)
#define VH(view) (view.frame.size.height)
@implementation CurtainView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = self.frame;
        [self addSubview:effectView];
        //        [self setUserInteractionEnabled:YES];
//        [self createUI];
    }
    return self;
}
#pragma mark - 创建ui视图
- (void)createUI{
    self.brightnessSize = [[UILabel alloc] init];
    [self addSubview:self.brightnessSize];
    self.brightnessSize.textColor = [UIColor whiteColor];
    self.brightnessSize.font = [UIFont systemFontOfSize:21];
    self.brightnessSize.textAlignment = NSTextAlignmentCenter;
    self.brightnessSize.sd_layout
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

//    self.scheduleBtn = [[CurtainMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-104, 80, 60)];
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
//    self.countdownBtn = [[CurtainMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
//    [self addSubview:self.countdownBtn];
//    self.countdownBtn.titleImageView.image = [UIImage imageNamed:@"倒计时"];
//    self.countdownBtn.titleLabel.text = Localized(@"tx_countdown_timing");
//    [self.countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    self.bgView.sd_layout
    .centerYEqualToView(self)
    .centerXEqualToView(self)
    .widthIs(160*KScreenWidth/375.0)
    .heightIs(320*KScreenHeight/667.0);
    self.bgView.layer.cornerRadius = 20;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    effectView.frame = self.bgView.frame;
//    [self.bgView addSubview:effectView];
    
    
    CGFloat bgViewW = VW(self.bgView);
    CGFloat bgViewH = VH(self.bgView)/3.0;
    
    self.openView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgViewW, bgViewH)];
    if (self.selectStatus == 1) {
        [self.stopView setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.openView setBackgroundColor:[UIColor clearColor]];
    }
    [self.openView setUserInteractionEnabled:YES];
    [self.bgView addSubview:self.openView];
    UITapGestureRecognizer *openGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openHandlePan:)];
    [openGestureRecognizer setDelegate:self];
    [self.openView addGestureRecognizer:openGestureRecognizer];
    self.openLabel = [[UILabel alloc] init];
    [self.openView addSubview:self.openLabel];
    self.openLabel.text = Localized(@"Curtain_open");
    self.openLabel.textColor = [UIColor blackColor];
    self.openLabel.font = [UIFont systemFontOfSize:21];
    self.openLabel.textAlignment = NSTextAlignmentCenter;
    self.openLabel.sd_layout
    .topSpaceToView(self.openView, 0)
    .leftSpaceToView(self.openView, 0)
    .rightSpaceToView(self.openView, 0)
    .bottomSpaceToView(self.openView, 0);
    
    
    
    
    self.stopView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewH, bgViewW, bgViewH)];
    if (self.selectStatus == 0) {
        [self.stopView setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.stopView setBackgroundColor:[UIColor clearColor]];
    }
    [self.stopView setUserInteractionEnabled:YES];
    [self.bgView addSubview:self.stopView];
    UITapGestureRecognizer *stopGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopHandlePan:)];
    [stopGestureRecognizer setDelegate:self];
    [self.stopView addGestureRecognizer:stopGestureRecognizer];
    self.stopLabel = [[UILabel alloc] init];
    [self.stopView addSubview:self.stopLabel];
    self.stopLabel.text =  Localized(@"Curtain_stop");;
    self.stopLabel.textColor = [UIColor blackColor];
    self.stopLabel.font = [UIFont systemFontOfSize:19];
    self.stopLabel.textAlignment = NSTextAlignmentCenter;
    self.stopLabel.sd_layout
    .topSpaceToView(self.stopView, 0)
    .leftSpaceToView(self.stopView, 0)
    .rightSpaceToView(self.stopView, 0)
    .bottomSpaceToView(self.stopView, 0);
    
    
    self.closeView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewH*2, bgViewW, bgViewH)];
    if (self.selectStatus == 2) {
        [self.closeView setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.closeView setBackgroundColor:[UIColor clearColor]];
    }
    [self.closeView setUserInteractionEnabled:YES];
    [self.bgView addSubview:self.closeView];
    UITapGestureRecognizer *closeGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeHandlePan:)];
    [closeGestureRecognizer setDelegate:self];
    [self.closeView addGestureRecognizer:closeGestureRecognizer];
    self.closeLabel = [[UILabel alloc] init];
    [self.closeView addSubview:self.closeLabel];
    self.closeLabel.text =  Localized(@"Curtain_close");
    self.closeLabel.textColor = [UIColor blackColor];
    self.closeLabel.font = [UIFont systemFontOfSize:19];
    self.closeLabel.textAlignment = NSTextAlignmentCenter;
    self.closeLabel.sd_layout
    .topSpaceToView(self.closeView, 0)
    .leftSpaceToView(self.closeView, 0)
    .rightSpaceToView(self.closeView, 0)
    .bottomSpaceToView(self.closeView, 0);
    
    if (self.isActionSet) {
        if (self.devStatus.onoff == 0) {
            self.brightnessSize.text =  Localized(@"Curtain_stop");
            [self.openView setBackgroundColor:[UIColor clearColor]];
            [self.closeView setBackgroundColor:[UIColor clearColor]];
            [self.stopView setBackgroundColor:[UIColor whiteColor]];
        }else if (self.devStatus.onoff == 1){
            [self.openView setBackgroundColor:[UIColor whiteColor]];
            [self.closeView setBackgroundColor:[UIColor clearColor]];
            [self.stopView setBackgroundColor:[UIColor clearColor]];
            self.brightnessSize.text =  Localized(@"Curtain_open");
        }else{
            [self.openView setBackgroundColor:[UIColor clearColor]];
            [self.closeView setBackgroundColor:[UIColor whiteColor]];
            [self.stopView setBackgroundColor:[UIColor clearColor]];
            self.brightnessSize.text =  Localized(@"Curtain_close");
        }
    }else{
        if (self.devStatus.offline == 1) {
            self.brightnessSize.text = Localized(@"tx_user_notice_device_status_offline");
            if (self.devStatus.onoff == 0) {
                [self.openView setBackgroundColor:[UIColor clearColor]];
                [self.closeView setBackgroundColor:[UIColor clearColor]];
                [self.stopView setBackgroundColor:[UIColor whiteColor]];
            }else if (self.devStatus.onoff == 1){
                [self.openView setBackgroundColor:[UIColor whiteColor]];
                [self.closeView setBackgroundColor:[UIColor clearColor]];
                [self.stopView setBackgroundColor:[UIColor clearColor]];
            }else{
                [self.openView setBackgroundColor:[UIColor clearColor]];
                [self.closeView setBackgroundColor:[UIColor whiteColor]];
                [self.stopView setBackgroundColor:[UIColor clearColor]];
            }
        }else{
            if (self.devStatus.onoff == 0) {
                self.brightnessSize.text =  Localized(@"Curtain_stop");
                [self.openView setBackgroundColor:[UIColor clearColor]];
                [self.closeView setBackgroundColor:[UIColor clearColor]];
                [self.stopView setBackgroundColor:[UIColor whiteColor]];
            }else if (self.devStatus.onoff == 1){
                [self.openView setBackgroundColor:[UIColor whiteColor]];
                [self.closeView setBackgroundColor:[UIColor clearColor]];
                [self.stopView setBackgroundColor:[UIColor clearColor]];
                self.brightnessSize.text =  Localized(@"Curtain_open");
            }else{
                [self.openView setBackgroundColor:[UIColor clearColor]];
                [self.closeView setBackgroundColor:[UIColor whiteColor]];
                [self.stopView setBackgroundColor:[UIColor clearColor]];
                self.brightnessSize.text =  Localized(@"Curtain_close");
            }
        }
    }
    
    
    
    
}

- (void)actionBtnAction
{
    self.actionBlock(1);
}
- (void)scheduleBtnAction
{
    self.actionBlock(2);
}

- (void)countdownBtnAction
{
    self.actionBlock(3);
}
#pragma mark -GestureRecognizer
- (void)openHandlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.selectStatus != 1) {
        self.selectStatus = 1;
        self.brightnessSize.text = Localized(@"Curtain_open");
        [self.openView setBackgroundColor:[UIColor whiteColor]];
        [self.closeView setBackgroundColor:[UIColor clearColor]];
        [self.stopView setBackgroundColor:[UIColor clearColor]];
        self.devStatus.onoff = 1;
        self.deviceControlBlock(self.devStatus);
    }
}
- (void)stopHandlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.selectStatus != 0) {
        self.selectStatus = 0;
        self.brightnessSize.text = Localized(@"Curtain_stop");
        [self.openView setBackgroundColor:[UIColor clearColor]];
        [self.closeView setBackgroundColor:[UIColor clearColor]];
        [self.stopView setBackgroundColor:[UIColor whiteColor]];
        self.devStatus.onoff = 0;
        self.deviceControlBlock(self.devStatus);
    }
}
- (void)closeHandlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.selectStatus != 2) {
        self.selectStatus = 2;
        self.brightnessSize.text = Localized(@"Curtain_close");
        [self.openView setBackgroundColor:[UIColor clearColor]];
        [self.closeView setBackgroundColor:[UIColor whiteColor]];
        [self.stopView setBackgroundColor:[UIColor clearColor]];
        self.devStatus.onoff = 2;
        self.deviceControlBlock(self.devStatus);
    }
}

#pragma mark -取消按钮的事件
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
@implementation CurtainMoreBtn

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
