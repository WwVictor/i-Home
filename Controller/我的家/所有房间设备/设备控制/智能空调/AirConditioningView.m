//
//  AirConditioningView.m
//  iThing
//
//  Created by Frank on 2018/8/8.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "AirConditioningView.h"
#define VW(view) (view.frame.size.width)
#define VH(view) (view.frame.size.height)
@implementation AirConditioningView
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
    if (self.isActionSet) {
        if (self.devStatus.mode == 0) {
            self.brightnessSize.text = Localized(@"Close");
        }else{
            self.temperatureNum = self.devStatus.set_temp;
            self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
        }
    }else{
        if (self.devStatus.offline == 1) {
            self.brightnessSize.text = Localized(@"tx_user_notice_device_status_offline");
            if (self.devStatus.mode == 0) {
                //            self.brightnessSize.text = Localized(@"Close");
            }else{
                self.temperatureNum = self.devStatus.set_temp;
                //            self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
            }
        }else{
            if (self.devStatus.mode == 0) {
                self.brightnessSize.text = Localized(@"Close");
            }else{
                self.temperatureNum = self.devStatus.set_temp;
                self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
            }
        }
    }
    
    
    
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
    
    
    
    self.addButton = [[UIButton alloc] init];
    self.addButton.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    self.addButton.sd_layout
    .topSpaceToView(self.brightnessSize, 30)
    .leftSpaceToView(self, (KScreenWidth-100-60)/2.0)
    .widthIs(50)
    .heightIs(50);
    self.addButton.imageEdgeInsets = UIEdgeInsetsMake(8,8, 8, 8);
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"温度按钮背景"] forState:UIControlStateNormal];
    [self.addButton setImage:[UIImage imageNamed:@"加温_icon"] forState:UIControlStateNormal];
    self.addButton.layer.cornerRadius = 25;
    self.addButton.layer.masksToBounds = YES;
    
    self.subtractButton = [[UIButton alloc] init];
    self.subtractButton.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self.subtractButton addTarget:self action:@selector(subtractButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.subtractButton];
    self.subtractButton.sd_layout
    .topSpaceToView(self.brightnessSize, 30)
    .leftSpaceToView(self.addButton, 60)
    .widthIs(50)
    .heightIs(50);
    self.subtractButton.imageEdgeInsets = UIEdgeInsetsMake(8,8, 8, 8);
    [self.subtractButton setBackgroundImage:[UIImage imageNamed:@"温度按钮背景"] forState:UIControlStateNormal];
    [self.subtractButton setImage:[UIImage imageNamed:@"减温_icon"] forState:UIControlStateNormal];
    self.subtractButton.layer.cornerRadius = 25;
    self.subtractButton.layer.masksToBounds = YES;
    
    
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

//    if (SafeAreaBottomHeight == 0) {
//        self.scheduleBtn = [[AirConditioningMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-84, 80, 60)];
    
//    }else{
//       self.scheduleBtn = [[AirConditioningMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-84, 80, 60)];
//       self.countdownBtn = [[AirConditioningMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
//    }
//    [self addSubview:self.scheduleBtn];
//    self.scheduleBtn.titleImageView.image = [UIImage imageNamed:@"定时"];
//    self.scheduleBtn.titleLabel.text = Localized(@"tx_schedular_timing");
//    [self.scheduleBtn addTarget:self action:@selector(scheduleBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.countdownBtn = [[AirConditioningMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
//    [self addSubview:self.countdownBtn];
//    self.countdownBtn.titleImageView.image = [UIImage imageNamed:@"倒计时"];
//    self.countdownBtn.titleLabel.text = Localized(@"tx_countdown_timing");
//    [self.countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray * segmentArray = @[ Localized(@"Air_conditioner_low"), Localized(@"Air_conditioner_mid"), Localized(@"Air_conditioner_high")];
    self.segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
    [self addSubview:self.segment];
    self.segment.sd_layout
    .centerXEqualToView(self)
    .widthIs(200)
    .bottomSpaceToView(self, 104)
    .heightIs(50);
    
    if (self.devStatus.speed == 0) {
       self.segment.selectedSegmentIndex = 0;
    }else if (self.devStatus.speed == 1){
        self.segment.selectedSegmentIndex = 1;
    }else{
        self.segment.selectedSegmentIndex = 2;
    }
    
    self.segment.tintColor = [UIColor whiteColor];
    UIColor *segmentColor = [UIColor blackColor];
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObjectsAndKeys:segmentColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [self.segment setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    self.segment.layer.cornerRadius = 12.5;
    self.segment.layer.masksToBounds = YES;
    self.segment.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segment.layer.borderWidth = 1;
    [self.segment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
    
    
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bgView];
    self.bgView.sd_layout
    .topSpaceToView(self.addButton, 40)
    .centerXEqualToView(self)
    .widthIs(160*KScreenWidth/375.0)
    .heightIs(VH(self)-(34+50+60+50+20+40+30+SafeAreaTopHeight+20+40));
    self.bgView.layer.cornerRadius = 20;
    self.bgView.layer.masksToBounds = YES;
    CGFloat bgViewW = VW(self.bgView);
    CGFloat bgViewH = VH(self.bgView)/3.0;
    self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    effectView.frame = self.bgView.frame;
//    [self.bgView addSubview:effectView];
    
    
    self.offView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgViewW, bgViewH)];
    if (self.selectStatus == 1) {
        [self.offView setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.offView setBackgroundColor:[UIColor clearColor]];
    }
    [self.offView setUserInteractionEnabled:YES];
    [self.bgView addSubview:self.offView];
    UITapGestureRecognizer *offGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offHandlePan:)];
    [offGestureRecognizer setDelegate:self];
    [self.offView addGestureRecognizer:offGestureRecognizer];
    self.offLabel = [[UILabel alloc] init];
    [self.offView addSubview:self.offLabel];
    self.offLabel.text = Localized(@"Air_conditioner_off");
    self.offLabel.textColor = [UIColor blackColor];
    self.offLabel.font = [UIFont systemFontOfSize:21];
    self.offLabel.textAlignment = NSTextAlignmentCenter;
    self.offLabel.sd_layout
    .topSpaceToView(self.offView, 0)
    .leftSpaceToView(self.offView, 0)
    .rightSpaceToView(self.offView, 0)
    .bottomSpaceToView(self.offView, 0);
    
    
    
    
    self.heatView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewH, bgViewW, bgViewH)];
    if (self.selectStatus == 0) {
        [self.heatView setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.heatView setBackgroundColor:[UIColor clearColor]];
    }
    [self.heatView setUserInteractionEnabled:YES];
    [self.bgView addSubview:self.heatView];
    UITapGestureRecognizer *heatGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heatHandlePan:)];
    [heatGestureRecognizer setDelegate:self];
    [self.heatView addGestureRecognizer:heatGestureRecognizer];
    self.heatLabel = [[UILabel alloc] init];
    [self.heatView addSubview:self.heatLabel];
    self.heatLabel.text = Localized(@"Air_conditioner_heat");
    self.heatLabel.textColor = [UIColor blackColor];
    self.heatLabel.font = [UIFont systemFontOfSize:19];
    self.heatLabel.textAlignment = NSTextAlignmentCenter;
    self.heatLabel.sd_layout
    .topSpaceToView(self.heatView, 0)
    .leftSpaceToView(self.heatView, 0)
    .rightSpaceToView(self.heatView, 0)
    .bottomSpaceToView(self.heatView, 0);
    
    
    self.coolView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewH*2, bgViewW, bgViewH)];
    if (self.selectStatus == 2) {
        [self.coolView setBackgroundColor:[UIColor whiteColor]];
    }else{
        [self.coolView setBackgroundColor:[UIColor clearColor]];
    }
    [self.coolView setUserInteractionEnabled:YES];
    [self.bgView addSubview:self.coolView];
    UITapGestureRecognizer *coolGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coolHandlePan:)];
    [coolGestureRecognizer setDelegate:self];
    [self.coolView addGestureRecognizer:coolGestureRecognizer];
    self.coolLabel = [[UILabel alloc] init];
    [self.coolView addSubview:self.coolLabel];
    self.coolLabel.text = Localized(@"Air_conditioner_cool");
    self.coolLabel.textColor = [UIColor blackColor];
    self.coolLabel.font = [UIFont systemFontOfSize:19];
    self.coolLabel.textAlignment = NSTextAlignmentCenter;
    self.coolLabel.sd_layout
    .topSpaceToView(self.coolView, 0)
    .leftSpaceToView(self.coolView, 0)
    .rightSpaceToView(self.coolView, 0)
    .bottomSpaceToView(self.coolView, 0);
    
    if (self.devStatus.offline == 1) {
        self.brightnessSize.text = Localized(@"tx_user_notice_device_status_offline");
        if (self.devStatus.mode == 0) {
            [self.offView setBackgroundColor:[UIColor whiteColor]];
            [self.heatView setBackgroundColor:[UIColor clearColor]];
            [self.coolView setBackgroundColor:[UIColor clearColor]];
        }else if (self.devStatus.onoff == 2){
            [self.offView setBackgroundColor:[UIColor clearColor]];
            [self.heatView setBackgroundColor:[UIColor whiteColor]];
            [self.coolView setBackgroundColor:[UIColor clearColor]];
            self.temperatureNum = self.devStatus.set_temp;
        }else{
            [self.offView setBackgroundColor:[UIColor clearColor]];
            [self.heatView setBackgroundColor:[UIColor clearColor]];
            [self.coolView setBackgroundColor:[UIColor whiteColor]];
            self.temperatureNum = self.devStatus.set_temp;
        }
    }else{
        if (self.devStatus.mode == 0) {
            self.brightnessSize.text =  Localized(@"Close");
            [self.offView setBackgroundColor:[UIColor whiteColor]];
            [self.heatView setBackgroundColor:[UIColor clearColor]];
            [self.coolView setBackgroundColor:[UIColor clearColor]];
        }else if (self.devStatus.onoff == 2){
            [self.offView setBackgroundColor:[UIColor clearColor]];
            [self.heatView setBackgroundColor:[UIColor whiteColor]];
            [self.coolView setBackgroundColor:[UIColor clearColor]];
            self.temperatureNum = self.devStatus.set_temp;
            self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
        }else{
            [self.offView setBackgroundColor:[UIColor clearColor]];
            [self.heatView setBackgroundColor:[UIColor clearColor]];
            [self.coolView setBackgroundColor:[UIColor whiteColor]];
            self.temperatureNum = self.devStatus.set_temp;
            self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
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
#pragma mark - segment选择按钮事件
-(void)segmentSelect:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
   
    if (index==0) {
       
        self.devStatus.speed = 0;
        self.deviceControlBlock(self.devStatus);
    }else if (index == 1){
        self.devStatus.speed = 1;
        self.deviceControlBlock(self.devStatus);
        
        
    }else{
        self.devStatus.speed = 2;
        self.deviceControlBlock(self.devStatus);
        
    }
    
}
#pragma mark - 加温按钮事件
 - (void)addButtonAction
{
    if (self.devStatus.mode == 0) {
    }else{
        if (self.devStatus.mode == 1) {
            if (self.temperatureNum == 32) {
                [SVProgressHUD doAnyRemindWithHUDMessage:@"已是最高温度" withDuration:1.5];
                return;
            }
        }else if (self.devStatus.mode == 2){
            if (self.temperatureNum == 30) {
                [SVProgressHUD doAnyRemindWithHUDMessage:@"已是最高温度" withDuration:1.5];
                return;
            }
        }else{
            
        }
        self.temperatureNum++;
        self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
        self.devStatus.set_temp = self.temperatureNum;
        self.devStatus.currentTemp = self.temperatureNum;
        self.deviceControlBlock(self.devStatus);
    }
   
}
#pragma mark - 减温按钮事件
- (void)subtractButtonAction
{
    if (self.devStatus.mode == 0) {
    }else{
        if (self.devStatus.mode == 1) {
            if (self.temperatureNum == 16) {
                [SVProgressHUD doAnyRemindWithHUDMessage:@"已是最低温度" withDuration:1.5];
                return;
            }
        }else if (self.devStatus.mode == 2){
            if (self.temperatureNum == 10) {
                [SVProgressHUD doAnyRemindWithHUDMessage:@"已是最低温度" withDuration:1.5];
                return;
            }
        }else{
            
        }
        self.temperatureNum--;
        self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
        self.devStatus.set_temp = self.temperatureNum;
        self.devStatus.currentTemp = self.temperatureNum;
        self.deviceControlBlock(self.devStatus);
    }
    
}
#pragma mark -GestureRecognizer
- (void)offHandlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.selectStatus != 1) {
        self.selectStatus = 1;
        [self.offView setBackgroundColor:[UIColor whiteColor]];
        [self.coolView setBackgroundColor:[UIColor clearColor]];
        [self.heatView setBackgroundColor:[UIColor clearColor]];
         self.brightnessSize.text = Localized(@"Close");
        self.devStatus.mode = 0;
        self.deviceControlBlock(self.devStatus);
    }
}
- (void)heatHandlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.selectStatus != 0) {
        self.selectStatus = 0;
//        self.brightnessSize.text = Localized(@"Air_conditioner_heat");
        [self.offView setBackgroundColor:[UIColor clearColor]];
        [self.coolView setBackgroundColor:[UIColor clearColor]];
        [self.heatView setBackgroundColor:[UIColor whiteColor]];
        self.temperatureNum = self.devStatus.set_temp;
        self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
        self.devStatus.mode = 2;
        self.deviceControlBlock(self.devStatus);
    }
}
- (void)coolHandlePan:(UIPanGestureRecognizer *)recognizer
{
    if (self.selectStatus != 2) {
        self.selectStatus = 2;
//        self.brightnessSize.text = Localized(@"Air_conditioner_cool");
        [self.offView setBackgroundColor:[UIColor clearColor]];
        [self.coolView setBackgroundColor:[UIColor whiteColor]];
        [self.heatView setBackgroundColor:[UIColor clearColor]];
        self.temperatureNum = self.devStatus.set_temp;
        self.brightnessSize.text = [NSString stringWithFormat:@"%d°C",self.temperatureNum];
        self.devStatus.mode = 2;
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
@implementation AirConditioningMoreBtn

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
