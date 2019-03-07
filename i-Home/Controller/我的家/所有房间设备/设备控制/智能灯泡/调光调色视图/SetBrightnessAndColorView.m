//
//  SetBrightnessAndColorView.m
//  iThing
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "SetBrightnessAndColorView.h"

static const CGFloat kAnimateDuration = 0.3f;
#define VW(view) (view.frame.size.width)
#define VH(view) (view.frame.size.height)

@implementation SetBrightnessAndColorView

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


- (void)createUI {
    
    self.brightnessSize = [[UILabel alloc] init];
    [self addSubview:self.brightnessSize];
    if (self.isActionSet) {
        if (self.devStatus.onoff == 0) {
            self.brightnessSize.text = Localized(@"Close");
        }else{
            self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",self.devStatus.bri];
        }
    }else{
        if (self.devStatus.offline == 1) {
            self.brightnessSize.text = Localized(@"tx_user_notice_device_status_offline");
        }else{
            if (self.devStatus.onoff == 0) {
                self.brightnessSize.text = Localized(@"Close");
            }else{
                self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",self.devStatus.bri];
            }
        }
    }
    
    
    
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
    
    
    self.colorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, KScreenHeight-160, KScreenWidth-60, 50)];
    self.colorImageView.layer.cornerRadius = 10;
    self.colorImageView.layer.masksToBounds = YES;
    [self addSubview:self.colorImageView];
    [self.colorImageView setUserInteractionEnabled:YES];
    UIColor *topColor = [UIColor whiteColor];
    UIColor *bottomColor = [UIColor yellowColor];
    UIImage *bgImg = [self gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-60, 50)];
    self.colorImageView.image = bgImg;
    UITapGestureRecognizer *colorTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapGes:)];
    [colorTapGes setDelegate:self];
    [self.colorImageView addGestureRecognizer:colorTapGes];
    
    [self createSliderView];
    if (self.devStatus.sat > 0) {
        self.sliderView.frame = CGRectMake((self.devStatus.sat/100.0)*(KScreenWidth-60-20), 0, 20, 50);
    }
//    ((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100)
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

    
//    self.scheduleBtn = [[SetBrightnessAndColorMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-104, 80, 60)];
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
//    self.countdownBtn = [[SetBrightnessAndColorMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
//    [self addSubview:self.countdownBtn];
//    self.countdownBtn.titleImageView.image = [UIImage imageNamed:@"倒计时"];
//    self.countdownBtn.titleLabel.text = Localized(@"tx_countdown_timing");
//    [self.countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    
    
    
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self addSubview:self.bgView];
    self.bgView.sd_layout
    .topSpaceToView(self.brightnessSize, ((VH(self)-160-SafeAreaTopHeight-20)-(320*KScreenHeight/667.0))/2.0)
    .centerXEqualToView(self)
    .widthIs(160*KScreenWidth/375.0)
    .heightIs(320*KScreenHeight/667.0);
    self.bgView.layer.cornerRadius = 20;
    self.bgView.layer.masksToBounds = YES;
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
//    effectView.frame = self.bgView.frame;
//    [self.bgView addSubview:effectView];
    
    
    UIPanGestureRecognizer *bgPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bgPanGes:)];
    [bgPanGes setDelegate:self];
    [self.bgView addGestureRecognizer:bgPanGes];
    UITapGestureRecognizer *bgTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapGes:)];
    [bgTapGes setDelegate:self];
    [self.bgView addGestureRecognizer:bgTapGes];
    
    CGFloat bgViewW = VW(self.bgView);
    CGFloat bgViewH = VH(self.bgView);
    self.thumblView = [[UIView alloc] initWithFrame:CGRectMake(0, bgViewH-20, bgViewW, 20)];
    [self.thumblView setBackgroundColor:[UIColor blackColor]];
    [self.thumblView setUserInteractionEnabled:YES];
    [self.bgView addSubview:self.thumblView];
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [panGestureRecognizer setDelegate:self];
//    [self.thumblView addGestureRecognizer:panGestureRecognizer];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgViewW-60)/2, 5, 60, 10)];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [self.thumblView addSubview:lineImageView];
    lineImageView.layer.cornerRadius = 5;
    lineImageView.layer.masksToBounds = YES;
    
    
    if (self.devStatus.onoff == 1 && self.devStatus.bri > 0) {
        self.thumblView.frame = CGRectMake(0, bgViewH-((self.devStatus.bri*(VH(self.bgView)-20))/100+20), bgViewW, (self.devStatus.bri*(VH(self.bgView)-20))/100+20);
        [self.thumblView setBackgroundColor:[UIColor whiteColor]];
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
#pragma mark - 创建滑块视图
-(void)createSliderView{
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.sliderView.backgroundColor = [UIColor clearColor];
    [self.colorImageView addSubview:self.sliderView];
    [self.sliderView setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    [panGes setDelegate:self];
    [self.sliderView addGestureRecognizer:panGes];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, 20, 20)];
    imageView1.image = [UIImage imageNamed:@"向下箭头"];
    [self.sliderView addSubview:imageView1];
    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50-15, 20, 20)];
    imageView2.image = [UIImage imageNamed:@"向上箭头"];
    [self.sliderView addSubview:imageView2];
    
//    if (self.devStatus.hue == 0xFFFF) {
        if (self.devStatus.sat > 0) {
            self.sliderView.frame = CGRectMake((self.devStatus.sat/100.0)*(KScreenWidth-60-20), 0, 20, 50);
        }
//    }
}
#pragma mark - 滑块背景点击手势事件
- (void)colorTapGes:(UIPanGestureRecognizer *)recognizer
{
    //取得所点击的点的坐标
    CGPoint point = [recognizer locationInView:self];
    if (point.x <= 50) {
        self.sliderView.frame = CGRectMake(0, 0, 20, 50);
    }else if (point.x >= VW(self)-50){
        self.sliderView.frame = CGRectMake(VW(self.colorImageView)-20, 0, 20, 50);
    }else{
       self.sliderView.frame = CGRectMake(point.x-30, 0, 20, 50);
    }
    UIColor *clocl =[self colorAtLocation:CGPointMake(self.sliderView.center.x,25)];
    NSLog(@"（一:） 十六进制: %@  RGB: %@",[self hexStringFromColor:clocl],[self changecolor:clocl]);
//    if (self.sliderView.center.x>= KScreenWidth-60) {
        NSLog(@"centerPoint.x == %.0f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
    NSString *centerPoint = [NSString stringWithFormat:@"%.0f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100];
    
    if (self.devStatus.bri == 0) {
        self.thumblView.backgroundColor = [UIColor whiteColor];
        self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
        self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
        self.devStatus.bri = 100;
    }
    self.devStatus.hue = 0xFFFF;
    self.devStatus.onoff = 1;
    
    self.devStatus.sat = [centerPoint intValue];
    self.deviceControlBlock(self.devStatus);
//    }else if (self.sliderView.center.x<= 10){
//        NSLog(@"centerPoint.x == %f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
//    }
//    else{
//        NSLog(@"centerPoint.x == %f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
//    }
}
#pragma mark - 滑块平移手势的处理事件
- (void)panGes:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.sliderView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.sliderView];
    CGPoint velocity = [recognizer velocityInView:self.sliderView];
    if(recognizer.state == UIGestureRecognizerStateBegan ||recognizer.state == UIGestureRecognizerStateChanged){
        if (velocity.x >= 0)
        {
            if (recognizer.view.center.x <= self.colorImageView.frame.size.width - (self.sliderView.frame.size.width)/2)
            {
                [self animateToDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:NO];
            }else{
                [self animateToDestination:CGPointMake(self.colorImageView.bounds.size.width-(self.sliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
            }
        }else{
            if (recognizer.view.center.x <= (self.sliderView.frame.size.width)/2)
            {
                [self animateToDestination:CGPointMake((self.sliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
            }else{
                [self animateToDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:NO];
            }
        }
    }
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (velocity.x >= 0)
        {
            if (recognizer.view.center.x >= self.colorImageView.frame.size.width - (self.sliderView.frame.size.width)/2)
            {
                [self animateToDestination:CGPointMake(self.colorImageView.bounds.size.width-(self.sliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:YES];
            }else{
                
                [self animateToDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:YES];
            }
            UIColor *clocl =[self colorAtLocation:CGPointMake(self.sliderView.center.x,25)];
            NSLog(@"（四:）十六进制: %@  RGB: %@",[self hexStringFromColor:clocl],[self changecolor:clocl]);
//            if (self.sliderView.center.x>= KScreenWidth-60) {
                NSLog(@"centerPoint.x == %.0f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
            NSString *centerPoint = [NSString stringWithFormat:@"%.0f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100];
            if (self.devStatus.bri == 0) {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
                self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
                self.devStatus.bri = 100;
                
            }
            self.devStatus.hue = 0xFFFF;
            self.devStatus.onoff = 1;
            self.devStatus.sat = [centerPoint intValue];
            self.deviceControlBlock(self.devStatus);
//            }else if (self.sliderView.center.x<= 10){
//                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
//            }
//            else{
//                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
//            }
        }
        else
        {
            if (recognizer.view.center.x <= (self.sliderView.frame.size.width)/2)
            {
                [self animateToDestination:CGPointMake((self.sliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
            }else{
                [self animateToDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:NO];
            }
            UIColor *clocl =[self colorAtLocation:CGPointMake(self.sliderView.center.x,25)];
            NSLog(@"（四:）十六进制: %@  RGB: %@",[self hexStringFromColor:clocl],[self changecolor:clocl]);
//            if (self.sliderView.center.x>= KScreenWidth-60) {
                NSLog(@"centerPoint.x == %.0f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
            NSString *centerPoint = [NSString stringWithFormat:@"%.0f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100];
            if (self.devStatus.bri == 0) {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
                self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
                self.devStatus.bri = 100;
            }
            self.devStatus.hue = 0xFFFF;
            self.devStatus.onoff = 1;
            self.devStatus.sat = [centerPoint intValue];
            self.deviceControlBlock(self.devStatus);
//            }else if (self.sliderView.center.x<= 10){
//                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
//            }
//            else{
//                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-60-20))*100);
//            }
        }
    }
}
#pragma mark - 根据手势平移位置实时修改滑块的frame
- (void)animateToDestination:(CGPoint)centerPoint withDuration:(CGFloat)duration switch:(BOOL)on
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.sliderView.center = centerPoint;
                     }
                     completion:^(BOOL finished) {
                     }];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                     }
                     completion:^(BOOL finished) {
                     }];
}
#pragma mark - 白色框背景点击手势事件
- (void)bgTapGes:(UIPanGestureRecognizer *)recognizer
{
    //取得所点击的点的坐标
    CGPoint point = [recognizer locationInView:self];
    CGFloat point_h =VH(self.bgView) - (point.y - self.bgView.frame.origin.y);
    if (point_h <= 20) {
      self.thumblView.backgroundColor = [UIColor blackColor];
      self.thumblView.frame = CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20);
    }else if (point_h >= VH(self.bgView)){
      self.thumblView.backgroundColor = [UIColor whiteColor];
      self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
    }else{
      self.thumblView.backgroundColor = [UIColor whiteColor];
      self.thumblView.frame = CGRectMake(0, VH(self.bgView)-point_h, VW(self.bgView), point_h);
    }
    if ([self getPrecnetSize:self.thumblView.frame.size.height-20] == 0) {
        self.brightnessSize.text = Localized(@"Close");
        self.devStatus.bri = 0;
        self.devStatus.onoff = 0;
        self.devStatus.hue = 0xFFFF;
        self.deviceControlBlock(self.devStatus);
    }else{
        self.devStatus.hue = 0xFFFF;
        self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",[self getPrecnetSize:self.thumblView.frame.size.height-20]];
        self.devStatus.bri = [self getPrecnetSize:self.thumblView.frame.size.height-20];
         self.devStatus.onoff = 1;
        self.deviceControlBlock(self.devStatus);
    }
    
}
#pragma mark - 白色框背景平移手势事件
- (void)bgPanGes:(UIPanGestureRecognizer *)recognizer
{
    self.isFlag = YES;
//    if (VH(self.thumblView) == VH(self.bgView)) {
//        return;
//    }
    //得到当前手势所在视图
    UIView *view = recognizer.view;
    //得到我们在视图上移动的偏移量
    CGPoint currentPoint = [recognizer translationInView:view.superview];
    CGFloat thumbView_h = self.thumblView.frame.size.height-currentPoint.y;
    self.thumblView.frame = CGRectMake(0, VH(self.bgView)-thumbView_h, VW(self.bgView), thumbView_h);
    //复原 // 每次都是从00点开始
    [recognizer setTranslation:CGPointZero inView:view.superview];
    CGPoint velocity = [recognizer velocityInView:view];
    if(recognizer.state == UIGestureRecognizerStateBegan){
        if (velocity.y >= 0)
        {
            if (self.thumblView.center.y >= VH(self.bgView)-20/2)
            {
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
                self.thumblView.backgroundColor = [UIColor blackColor];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
            }
        }else{
            if (self.thumblView.center.y <= VH(self.bgView)/2)
            {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                [self animateToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                
            }
            
        }
    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        if (velocity.y >= 0)
        {
            if (self.thumblView.center.y >= VH(self.bgView)-20/2)
            {
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
                self.thumblView.backgroundColor = [UIColor blackColor];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
            }
        }else{
            if (self.thumblView.center.y <= VH(self.bgView)/2)
            {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                [self animateChangeToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                
            }
            
        }
    }
    if(recognizer.state == UIGestureRecognizerStateEnded){
        self.isFlag = NO;
        if (velocity.y >= 0)
        {
            if (self.thumblView.center.y >= VH(self.bgView)-20/2)
            {
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
                self.thumblView.backgroundColor = [UIColor blackColor];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
            }
        }else{
            if (self.thumblView.center.y <= VH(self.bgView)/2)
            {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                [self animateToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                
            }
            
        }
    }
}
#pragma mark - 照明亮度的thumbView的平移手势实时修改thumbview的frame
- (void)animateToDestination:(CGRect)rect withDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
//                         dispatch_async(dispatch_get_main_queue(), ^{
                             self.thumblView.frame = rect;
                         if ([self getPrecnetSize:rect.size.height-20] == 0) {
                             self.brightnessSize.text = Localized(@"Close");
                             self.devStatus.bri = 0;
                             self.devStatus.onoff = 0;
                             self.devStatus.hue = 0xFFFF;
                             self.deviceControlBlock(self.devStatus);
                         }else{
                             self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",[self getPrecnetSize:rect.size.height-20]];
                             self.devStatus.bri = [self getPrecnetSize:rect.size.height-20];
                             self.devStatus.onoff = 1;
                             self.devStatus.hue = 0xFFFF;
                             self.deviceControlBlock(self.devStatus);
                         }
                             
//                         });
                         
                     }
                     completion:^(BOOL finished) {
                     }];

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                     }
                     completion:^(BOOL finished) {
                     }];
}
#pragma mark - 照明亮度的thumbView的平移手势实时修改thumbview的frame
- (void)animateChangeToDestination:(CGRect)rect withDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //                         dispatch_async(dispatch_get_main_queue(), ^{
                         self.thumblView.frame = rect;
                         if ([self getPrecnetSize:rect.size.height-20] == 0) {
                             self.brightnessSize.text = Localized(@"Close");
                             self.devStatus.bri = 0;
                             self.devStatus.onoff = 0;
                             self.devStatus.hue = 0xFFFF;
//                             self.deviceControlBlock(self.devStatus);
                         }else{
                             self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",[self getPrecnetSize:rect.size.height-20]];
                             self.devStatus.bri = [self getPrecnetSize:rect.size.height-20];
                             self.devStatus.onoff = 1;
                             self.devStatus.hue = 0xFFFF;
//                             self.deviceControlBlock(self.devStatus);
                         }
                         
                         //                         });
                         
                     }
                     completion:^(BOOL finished) {
                     }];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                     }
                     completion:^(BOOL finished) {
                     }];
}
#pragma mark - 修改照明亮度的thumbView的平移手势处理事件
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
//    if (VH(self.thumblView) == VH(self.bgView)) {
//        return;
//    }
    CGPoint translation = [recognizer translationInView:self.thumblView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x,recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.thumblView];
    CGPoint velocity = [recognizer velocityInView:self.thumblView];
    NSLog(@"x= %f,y= %f",recognizer.view.center.x,recognizer.view.center.y);
    if(recognizer.state == UIGestureRecognizerStateBegan){
        if (velocity.y >= 0)
        {
            if (recognizer.view.center.y >= VH(self.bgView)-20/2)
            {
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
                self.thumblView.backgroundColor = [UIColor blackColor];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
            }
        }else{
         
            if (recognizer.view.center.y <= VH(self.bgView)/2)
            {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                [self animateToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
//
            }

        }
    }
    if(recognizer.state == UIGestureRecognizerStateChanged){
        if (velocity.y >= 0)
        {
            if (recognizer.view.center.y >= VH(self.bgView)-20/2)
            {
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
                self.thumblView.backgroundColor = [UIColor blackColor];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
            }
        }else{
            
            if (recognizer.view.center.y <= VH(self.bgView)/2)
            {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                [self animateChangeToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                //
            }
            
        }
    }
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (velocity.y >= 0)
        {
            if (recognizer.view.center.y >= VH(self.bgView)-20/2)
            {
                self.thumblView.backgroundColor = [UIColor blackColor];
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
            }
        }else{

            if (recognizer.view.center.y <= VH(self.bgView)/2)
            {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                [self animateToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
                return;
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                
            }
            
        }
    }
}
#pragma mark - 根据滑块的高度计算出百分比
- (int)getPrecnetSize:(CGFloat)thumbHeight
{
    CGFloat size = thumbHeight*100/(VH(self.bgView)-20);
    return (int)size;
}
#pragma mark - 根据百分比计算出滑块的高度
- (CGFloat)getThumbViewHeight:(CGFloat)precnetSize
{
    CGFloat size = (VH(self.bgView)-20)*precnetSize;
    return size;
}



#pragma mark -取消按钮的事件
- (void)cancelBtnAction
{
    self.cancelBlock(0);

}
#pragma mark- 获取颜色16进制值
/**
 
 从color中获取对应的16进制值
 @param color 颜色
 @return 返回颜色的16进制值
 */
- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}
#pragma mark- 获取颜色rgb值
/**
 从color中获取对应的rgb值
 
 @param color 颜色
 @return 返回颜色的rgb值
 */
-(NSString *)changecolor:(UIColor *)color{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"%ld, %ld, %ld",lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
}
#pragma mark-获取指定坐标位置的颜色值
/**
 *  获取指定坐标位置的颜色值
 *
 *  @param point 坐标点
 *
 *  @return 颜色值
 */
- (UIColor *)colorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    CGImageRef inImage = self.colorImageView.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            int alpha =  data[offset];
            int red = data[offset + 1];
            int green = data[offset + 2];
            int blue = data[offset + 3];
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        } @catch (NSException * e) {
            NSLog(@"%@", e.description);
        } @finally {
        }
        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}
#pragma mark-获取图像中获取对应的argb值
/**
 *  从图像中获取对应的argb值
 *
 *  @param inImage 指定图像
 *
 *  @return 绘图上下文
 */
- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow = (int)(pixelsWide * 4);
    bitmapByteCount = (int)(bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}
#pragma mark - 把颜色生成图片
- (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize {
    
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        
        [ar addObject:(id)c.CGColor];
        
    }
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    
    CGPoint start;
    
    CGPoint end;
    
    switch (gradientType) {
            
        case GradientTypeTopToBottom:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(0.0, imgSize.height);
            
            break;
            
        case GradientTypeLeftToRight:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(imgSize.width, 0.0);
            
            break;
            
        case GradientTypeUpleftToLowright:
            
            start = CGPointMake(0.0, 0.0);
            
            end = CGPointMake(imgSize.width, imgSize.height);
            
            break;
            
        case GradientTypeUprightToLowleft:
            
            start = CGPointMake(imgSize.width, 0.0);
            
            end = CGPointMake(0.0, imgSize.height);
            
            break;
            
        default:
            
            break;
            
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
    
    CGColorSpaceRelease(colorSpace);
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
@implementation SetBrightnessAndColorMoreBtn

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
