//
//  DimmerView.m
//  iThing
//
//  Created by Frank on 2018/8/15.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "DimmerView.h"
static const CGFloat kAnimateDuration = 0.3f;
#define VW(view) (view.frame.size.width)
#define VH(view) (view.frame.size.height)
@implementation DimmerView
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
//    NSLog(@"%f",KScreenHeight);
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
    
    
//    self.brightnessSize.text = Localized(@"Close");
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
    
//    self.scheduleBtn = [[DimmerMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-104, 80, 60)];
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
//    self.countdownBtn = [[DimmerMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
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
        self.deviceControlBlock(self.devStatus);
    }else{
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
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                return;
            }
            
        }
    }
    if (recognizer.state == UIGestureRecognizerStateChanged) {
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
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                return;
            }
            
        }
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
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
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                return;
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
                             self.deviceControlBlock(self.devStatus);
                         }else{
                             self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",[self getPrecnetSize:rect.size.height-20]];
                             self.devStatus.bri = [self getPrecnetSize:rect.size.height-20];
                             self.devStatus.onoff = 1;
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
                         }else{
                             self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",[self getPrecnetSize:rect.size.height-20]];
                             self.devStatus.bri = [self getPrecnetSize:rect.size.height-20];
                             self.devStatus.onoff = 1;
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
//- (void)handlePan:(UIPanGestureRecognizer *)recognizer
//{
//    CGPoint translation = [recognizer translationInView:self.thumblView];
//    recognizer.view.center = CGPointMake(recognizer.view.center.x,recognizer.view.center.y + translation.y);
//    [recognizer setTranslation:CGPointMake(0, 0) inView:self.thumblView];
//    CGPoint velocity = [recognizer velocityInView:self.thumblView];
//    NSLog(@"x= %f,y= %f",recognizer.view.center.x,recognizer.view.center.y);
//    if(recognizer.state == UIGestureRecognizerStateBegan){
//        if (velocity.y >= 0)
//        {
//            if (recognizer.view.center.y >= VH(self.bgView)-20/2)
//            {
//                [self animateToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
//                self.thumblView.backgroundColor = [UIColor blackColor];
//                return;
//            }else{
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
//                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
//            }
//        }else{
//            if (recognizer.view.center.y <= VH(self.bgView)/2)
//            {
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                [self animateToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
//            }else{
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
//                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
//                return;
//            }
//
//        }
//    }
//    if (recognizer.state == UIGestureRecognizerStateChanged) {
//        if (velocity.y >= 0)
//        {
//            if (recognizer.view.center.y >= VH(self.bgView)-20/2)
//            {
//                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
//                self.thumblView.backgroundColor = [UIColor blackColor];
//                return;
//            }else{
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
//                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
//            }
//        }else{
//            if (recognizer.view.center.y <= VH(self.bgView)/2)
//            {
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                [self animateChangeToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
//            }else{
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
//                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
//                return;
//            }
//
//        }
//    }
//    if(recognizer.state == UIGestureRecognizerStateEnded)
//    {
//        if (velocity.y >= 0)
//        {
//            if (recognizer.view.center.y >= VH(self.bgView)-20/2)
//            {
//                self.thumblView.backgroundColor = [UIColor blackColor];
//                [self animateToDestination:CGRectMake(0, VH(self.bgView)-20, VW(self.bgView), 20) withDuration:kAnimateDuration];
//                return;
//            }else{
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
//                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
//            }
//        }else{
//            if (recognizer.view.center.y <= VH(self.bgView)/2)
//            {
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                [self animateToDestination:CGRectMake(0, 0, VW(self.bgView), VH(self.bgView)) withDuration:kAnimateDuration];
//            }else{
//                self.thumblView.backgroundColor = [UIColor whiteColor];
//                CGFloat newH = (VH(self.bgView)-recognizer.view.center.y)*2;
//                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
//                return;
//            }
//
//        }
//    }
//}
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
@implementation DimmerMoreBtn

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
