//
//  SetRGBDeviceView.m
//  iThing
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "SetRGBDeviceView.h"
#import "ColorPickerView.h"
#import "MyFileHeader.h"
static const CGFloat kAnimateDuration = 0.3f;
#define VW(view) (view.frame.size.width)
#define VH(view) (view.frame.size.height)
@implementation SetRGBDeviceView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        effectView.frame = self.frame;
        [self addSubview:effectView];
    }
    return self;
}
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)createUI{
    
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
//
    
    
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

    
//    self.scheduleBtn = [[SetRGBDeviceMoreBtn alloc] initWithFrame:CGRectMake(35 , KScreenHeight-104, 80, 60)];
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
//    self.countdownBtn = [[SetRGBDeviceMoreBtn alloc] initWithFrame:CGRectMake(KScreenWidth-115, KScreenHeight-104, 80, 60)];
//    [self addSubview:self.countdownBtn];
//    self.countdownBtn.titleImageView.image = [UIImage imageNamed:@"倒计时"];
//    self.countdownBtn.titleLabel.text = Localized(@"tx_countdown_timing");
//    [self.countdownBtn addTarget:self action:@selector(countdownBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.devStatus.serial_type == 3) {
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        self.bgView.sd_layout
        .topSpaceToView(self.brightnessSize, 30)
        .centerXEqualToView(self)
        .widthIs(160*KScreenWidth/375.0)
        .heightIs(VH(self)-SafeAreaTopHeight-20-70-70-160);
        self.bgView.layer.cornerRadius = 20;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];

        UIPanGestureRecognizer *bgPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bgPanGes:)];
        [bgPanGes setDelegate:self];
        [self.bgView addGestureRecognizer:bgPanGes];
        UITapGestureRecognizer *bgTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTapGes:)];
        [bgTapGes setDelegate:self];
        [self.bgView addGestureRecognizer:bgTapGes];



//        CGFloat he_sep = ((VH(self)-160-SafeAreaTopHeight-20)-(320*KScreenHeight/667.0-30))/2.0-50 +320*KScreenHeight/667.0-30+30+SafeAreaTopHeight;

        self.tempColorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, VH(self)-160-80, KScreenWidth-80, 50)];
        self.tempColorImageView.layer.cornerRadius = 10;
        self.tempColorImageView.layer.masksToBounds = YES;
        [self addSubview:self.tempColorImageView];
        [self.tempColorImageView setUserInteractionEnabled:YES];
        UIColor *topColor = [UIColor whiteColor];
        UIColor *bottomColor = [UIColor colorWithHexString:@"D3FA01"];
        UIImage *bgImg = [self gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
        self.tempColorImageView.image = bgImg;
        UITapGestureRecognizer *colorTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tempColorTapGes:)];
        [colorTapGes setDelegate:self];
        [self.tempColorImageView addGestureRecognizer:colorTapGes];


        self.tempSliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
        self.tempSliderView.backgroundColor = [UIColor clearColor];
        [self.tempColorImageView addSubview:self.tempSliderView];
        [self.tempSliderView setUserInteractionEnabled:YES];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tempPanGes:)];
        [panGes setDelegate:self];
        [self.tempSliderView addGestureRecognizer:panGes];

        self.tempImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, 20, 20)];
        self.tempImageView1.image = [UIImage imageNamed:@"向下箭头"];
        [self.tempSliderView addSubview:self.tempImageView1];
        self.tempImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50-15, 20, 20)];
        self.tempImageView2.image = [UIImage imageNamed:@"向上箭头"];
        [self.tempSliderView addSubview:self.tempImageView2];
        if (self.devStatus.hue == 0xFFFF) {
            if (self.devStatus.sat > 0) {
                self.tempSliderView.frame = CGRectMake((self.devStatus.sat/100.0)*(KScreenWidth-80-20), 0, 20, 50);
            }
        }
        
        
    }else{
        self.bgView = [[UIView alloc] init];
        //    self.bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        self.bgView.sd_layout
        .topSpaceToView(self.brightnessSize, ((VH(self)-160-SafeAreaTopHeight-20)-(320*KScreenHeight/667.0))/2.0)
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
    }

    
    
    
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
    
    
    NSArray * segmentArray = @[Localized(@"Brightness"),Localized(@"Colour"),Localized(@"Pattern")];
    self.segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
//    self.segment.backgroundColor = [UIColor colorWithHexString:@"848587"];
    [self addSubview:self.segment];
    self.segment.sd_layout
    .leftSpaceToView(self, 40)
    .rightSpaceToView(self, 40)
    .topSpaceToView(self, KScreenHeight-160)
    .heightIs(40);
    
    self.segment.selectedSegmentIndex = 0;
    self.segment.tintColor = [UIColor whiteColor];
    UIColor *segmentColor = [UIColor blackColor];
    
    NSDictionary *colorAttr = [NSDictionary dictionaryWithObjectsAndKeys:segmentColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [self.segment setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
    self.segment.layer.cornerRadius = 20;
    self.segment.layer.masksToBounds = YES;
    self.segment.layer.borderColor = [UIColor whiteColor].CGColor;
    self.segment.layer.borderWidth = 1;
    
    [self.segment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
    [self createModelButtons];
    [self createColorViews];
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
#pragma mark -创建调色视图
- (void)createColorViews
{
    
//    if (self.devStatus.serial_type == 2) {
//        self.colorBgView = [[UIView alloc] init];
//        self.colorBgView.backgroundColor = [UIColor clearColor];
//        [self addSubview:self.colorBgView];
//        self.colorBgView.sd_layout
//        .topSpaceToView(self, SafeAreaTopHeight+50+(KScreenHeight-SafeAreaTopHeight-50-160-KScreenWidth+80)/2)
//        .centerXEqualToView(self)
//        .widthIs(KScreenWidth-80)
//        .heightIs(KScreenWidth-80);
//    }else{
    
        CGFloat he_sep = (KScreenHeight-SafeAreaTopHeight-50-160-KScreenWidth+80)/2;
        
        self.colorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, KScreenHeight-160-KScreenWidth+80-he_sep-50-he_sep/2, KScreenWidth-80, 50)];
        self.colorImageView.layer.cornerRadius = 10;
        self.colorImageView.layer.masksToBounds = YES;
        [self addSubview:self.colorImageView];
        [self.colorImageView setUserInteractionEnabled:YES];
        UIColor *topColor = [UIColor whiteColor];
        UIColor *bottomColor = [UIColor colorWithHexString:@"D3FA01"];
        UIImage *bgImg = [self gradientColorImageFromColors:@[topColor, bottomColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
        self.colorImageView.image = bgImg;
        UITapGestureRecognizer *colorTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorTapGes:)];
        [colorTapGes setDelegate:self];
        [self.colorImageView addGestureRecognizer:colorTapGes];
        
        
        self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
        self.sliderView.backgroundColor = [UIColor clearColor];
        [self.colorImageView addSubview:self.sliderView];
        [self.sliderView setUserInteractionEnabled:YES];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
        [panGes setDelegate:self];
        [self.sliderView addGestureRecognizer:panGes];
        
        self.imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, 20, 20)];
        self.imageView1.image = [UIImage imageNamed:@"向下箭头"];
        [self.sliderView addSubview:self.imageView1];
        self.imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50-15, 20, 20)];
        self.imageView2.image = [UIImage imageNamed:@"向上箭头"];
        [self.sliderView addSubview:self.imageView2];
//        self.sliderView.frame = CGRectMake((100/100.0)*(KScreenWidth-80-20), 0, 20, 50);
        self.colorBgView = [[UIView alloc] init];
        self.colorBgView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.colorBgView];
        self.colorBgView.sd_layout
        .topSpaceToView(self, KScreenHeight-160-KScreenWidth+80-he_sep)
        .centerXEqualToView(self)
        .widthIs(KScreenWidth-80)
        .heightIs(KScreenWidth-80);
//    }
    
    
    
    self.colorPickerView = [[ColorPickerView alloc] init];
    self.colorPickerView.devStatus = self.devStatus;
    [self.colorBgView addSubview:self.colorPickerView];
    self.colorPickerView.sd_layout
    .topSpaceToView(self.colorBgView, 0)
    .leftSpaceToView(self.colorBgView, 0)
    .widthIs(KScreenWidth-80)
    .heightIs(KScreenWidth-80);
    
//    self.colorImageView1 = [[UIImageView alloc] init];
//    [self.colorBgView addSubview:self.colorImageView1];
//    self.colorImageView1.sd_layout
//    .centerYEqualToView(self.colorBgView)
//    .centerXEqualToView(self.colorBgView)
//    .widthIs((KScreenWidth-80)*118/254)
//    .heightIs((KScreenWidth-80)*118/254);
//    self.colorImageView1.layer.cornerRadius = ((KScreenWidth-80)*118/254)/2;
//    self.colorImageView1.layer.masksToBounds = YES;
    
    __weak typeof(self) weakself = self;
    [weakself.colorPickerView setPickerStyle:ZWColorPickerStyleRing andBlock:^(UIColor *color,int colorNum) {
        
        weakself.sliderView.frame = CGRectMake(VW(self.colorImageView)-20, 0, 20, 50);
        if (weakself.devStatus.bri == 0) {
            weakself.thumblView.backgroundColor = [UIColor whiteColor];
            weakself.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
            weakself.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
            weakself.devStatus.bri = 100;
        }
        weakself.devStatus.onoff = 1;
        weakself.devStatus.sat = 100;
        weakself.devStatus.hue = colorNum;
        weakself.deviceControlBlock(weakself.devStatus);
        NSLog(@"十六进制: %@ RGB : %@",[self hexStringFromColor:color],[self changecolor:color]);
//        self.colorImageView1.backgroundColor = color;
        self.colorImageView.image = [self gradientColorImageFromColors:@[[UIColor whiteColor], color] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
    }];
    if (ZWColorPickerStyleRing) {
    [self.colorPickerView setPickerInnerRadius:(CGFloat)((KScreenWidth-80)*0.31)];
    }
//    if (self.devStatus.hue> 0) {
       self.colorImageView.image = [self gradientColorImageFromColors:@[[UIColor whiteColor], [self colorAtLocation:[self radianToCenterRadiu:self.devStatus.hue]]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
//    }
//    if (self.devStatus.serial_type == 2) {
//
//    }else{
        self.colorImageView.alpha = 0;
        self.sliderView.alpha = 0;
        self.imageView1.alpha = 0;
        self.imageView2.alpha = 0;
//    }
   
    self.colorPickerView.alpha = 0;
    self.colorBgView.alpha = 0;
}
- (CGPoint)radianToCenterRadiu:(int)radiu {
    CGPoint point = CGPointZero;
    if (radiu>= 0 && radiu < 90) {
//        NSLog(@"x === %lf",((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180));
//        NSLog(@"y === %lf",((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180));
        point.x = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180);
        point.y = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180);
    }else if (radiu >= 90 && radiu <= 180){
//        NSLog(@"x === %lf",((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180));
//        NSLog(@"y === %lf",((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180));
        point.x = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180);
        point.y = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180);
    }else if (radiu > 180 && radiu < 270){
//        NSLog(@"x === %lf",((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180));
//        NSLog(@"y === %lf",((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180));
        point.x = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180);
        point.y = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180);
    }else{
//        NSLog(@"x === %lf",((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180));
//        NSLog(@"y === %lf",((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180));
        point.x = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*cosf((M_PI*radiu)/180);
        point.y = (KScreenWidth-80)/2 - ((KScreenWidth-80)/2-30)*sinf((M_PI*radiu)/180);
    }
    return point;
}
/**
 *  获取指定坐标位置的颜色值
 *
 *  @param point 坐标点
 *
 *  @return 颜色值
 */
- (UIColor *)colorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    CGImageRef inImage = self.colorPickerView.image.CGImage;
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
#pragma mark - 色温滑块背景点击手势事件
- (void)tempColorTapGes:(UIPanGestureRecognizer *)recognizer
{
    //取得所点击的点的坐标
    CGPoint point = [recognizer locationInView:self];
    if (point.x <= 50) {
        self.tempSliderView.frame = CGRectMake(0, 0, 20, 50);
    }else if (point.x >= VW(self)-50){
        self.tempSliderView.frame = CGRectMake(VW(self.tempColorImageView)-20, 0, 20, 50);
    }else{
        self.tempSliderView.frame = CGRectMake(point.x-40, 0, 20, 50);
    }
    UIColor *clocl =[self colorAtLocation:CGPointMake(self.tempSliderView.center.x,25)];
    NSLog(@"（一:） 十六进制: %@  RGB: %@",[self hexStringFromColor:clocl],[self changecolor:clocl]);
    //    if (self.sliderView.center.x>= KScreenWidth-80) {
    NSLog(@"centerPoint.x == %.0f",((self.tempSliderView.center.x-10)/(KScreenWidth-80-20))*100);
    NSString *str = [NSString stringWithFormat:@"%.0f",((self.tempSliderView.center.x-10)/(KScreenWidth-80-20))*100];
    if (self.devStatus.bri == 0) {
        self.thumblView.backgroundColor = [UIColor whiteColor];
        self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
        self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
        self.devStatus.bri = 100;
    }
    self.devStatus.hue = 0xFFFF;
    self.devStatus.onoff = 1;
    self.devStatus.sat = [str intValue];
    self.deviceControlBlock(self.devStatus);
    //    }else if (self.sliderView.center.x<= 10){
    //        NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
    //    }
    //    else{
    //        NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
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
        self.sliderView.frame = CGRectMake(point.x-40, 0, 20, 50);
    }
    UIColor *clocl =[self colorAtLocation:CGPointMake(self.sliderView.center.x,25)];
    NSLog(@"（一:） 十六进制: %@  RGB: %@",[self hexStringFromColor:clocl],[self changecolor:clocl]);
//    if (self.sliderView.center.x>= KScreenWidth-80) {
        NSLog(@"centerPoint.x == %.0f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
    NSString *str = [NSString stringWithFormat:@"%.0f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100];
    if (self.devStatus.bri == 0) {
        self.thumblView.backgroundColor = [UIColor whiteColor];
        self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
        self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
        self.devStatus.bri = 100;
    }
    self.devStatus.onoff = 1;
    self.devStatus.sat = [str intValue];
    self.deviceControlBlock(self.devStatus);
//    }else if (self.sliderView.center.x<= 10){
//        NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
//    }
//    else{
//        NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
//    }

}
- (void)colorPickerDidSelectColor:(UIColor * __nullable)color {
//    self.view.backgroundColor = color;
    
}
#pragma mark - 色温滑块平移手势处理事件
- (void)tempPanGes:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.tempSliderView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.tempSliderView];
    CGPoint velocity = [recognizer velocityInView:self.tempSliderView];
    if(recognizer.state == UIGestureRecognizerStateBegan ||recognizer.state == UIGestureRecognizerStateChanged){
        if (velocity.x >= 0)
        {
            if (recognizer.view.center.x >= self.tempColorImageView.frame.size.width - (self.tempSliderView.frame.size.width)/2)
            {
                [self animateToTempDestination:CGPointMake(self.tempColorImageView.bounds.size.width-(self.tempSliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
                
            }else{
                [self animateToTempDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:NO];
            }
        }else{
            if (recognizer.view.center.x <= (self.tempSliderView.frame.size.width)/2)
            {
                [self animateToTempDestination:CGPointMake((self.tempSliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
                return;
            }else{
                [self animateToTempDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:NO];
            }
        }
    }
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (velocity.x >= 0)
        {
            if (recognizer.view.center.x >= self.tempColorImageView.frame.size.width - (self.tempSliderView.frame.size.width)/2)
            {
                [self animateToTempDestination:CGPointMake(self.tempColorImageView.bounds.size.width-(self.tempSliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:YES];
            }else{
                
                [self animateToTempDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:YES];
            }
            UIColor *clocl =[self colorAtLocation:CGPointMake(self.tempSliderView.center.x,25)];
            NSLog(@"（四:）十六进制: %@  RGB: %@",[self hexStringFromColor:clocl],[self changecolor:clocl]);
            //            if (self.sliderView.center.x>= KScreenWidth-80) {
            NSLog(@"centerPoint.x == %.0f",((self.tempSliderView.center.x-10)/(KScreenWidth-80-20))*100);
            NSString *str = [NSString stringWithFormat:@"%.0f",((self.tempSliderView.center.x-10)/(KScreenWidth-80-20))*100];
            if (self.devStatus.bri == 0) {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
                self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
                self.devStatus.bri = 100;
            }
            self.devStatus.hue = 0xFFFF;
            self.devStatus.onoff = 1;
            self.devStatus.sat = [str intValue];
            self.deviceControlBlock(self.devStatus);
            //            }else if (self.sliderView.center.x<= 10){
            //               NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
            //            }
            //            else{
            //                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
            //            }
        }
        else
        {
            if (recognizer.view.center.x <= (self.tempSliderView.frame.size.width)/2)
            {
                [self animateToTempDestination:CGPointMake((self.tempSliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
            }else{
                [self animateToTempDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:NO];
            }
            UIColor *clocl =[self colorAtLocation:CGPointMake(self.tempSliderView.center.x,25)];
            NSLog(@"（四:）十六进制: %@  RGB: %@",[self hexStringFromColor:clocl],[self changecolor:clocl]);
            //            if (self.sliderView.center.x>= KScreenWidth-80) {
            NSLog(@"centerPoint.x == %.0f",((self.tempSliderView.center.x-10)/(KScreenWidth-80-20))*100);
            NSString *str = [NSString stringWithFormat:@"%.0f",((self.tempSliderView.center.x-10)/(KScreenWidth-80-20))*100];
            if (self.devStatus.bri == 0) {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
                self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
                self.devStatus.bri = 100;
            }
            self.devStatus.hue = 0xFFFF;
            self.devStatus.onoff = 1;
            self.devStatus.sat = [str intValue];
            self.deviceControlBlock(self.devStatus);
            //            }else if (self.sliderView.center.x<= 10){
            //                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
            //            }
            //            else{
            //                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
            //            }
        }
    }
}

#pragma mark - 滑块平移手势处理事件
- (void)panGes:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.sliderView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.sliderView];
    CGPoint velocity = [recognizer velocityInView:self.sliderView];
    if(recognizer.state == UIGestureRecognizerStateBegan ||recognizer.state == UIGestureRecognizerStateChanged){
        if (velocity.x >= 0)
        {
            if (recognizer.view.center.x >= self.colorImageView.frame.size.width - (self.sliderView.frame.size.width)/2)
            {
                [self animateToDestination:CGPointMake(self.colorImageView.bounds.size.width-(self.sliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
                
            }else{
                [self animateToDestination:CGPointMake(recognizer.view.center.x,25) withDuration:kAnimateDuration switch:NO];
            }
        }else{
            if (recognizer.view.center.x <= (self.sliderView.frame.size.width)/2)
            {
                [self animateToDestination:CGPointMake((self.sliderView.frame.size.width)/2,25) withDuration:kAnimateDuration switch:NO];
                return;
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
//            if (self.sliderView.center.x>= KScreenWidth-80) {
                NSLog(@"centerPoint.x == %.0f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
            NSString *str = [NSString stringWithFormat:@"%.0f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100];
            if (self.devStatus.bri == 0) {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
                self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
                self.devStatus.bri = 100;
            }
            self.devStatus.onoff = 1;
            self.devStatus.sat = [str intValue];
            self.deviceControlBlock(self.devStatus);
//            }else if (self.sliderView.center.x<= 10){
//               NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
//            }
//            else{
//                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
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
//            if (self.sliderView.center.x>= KScreenWidth-80) {
                NSLog(@"centerPoint.x == %.0f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
            NSString *str = [NSString stringWithFormat:@"%.0f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100];
            if (self.devStatus.bri == 0) {
                self.thumblView.backgroundColor = [UIColor whiteColor];
                self.thumblView.frame = CGRectMake(0, 0, VW(self.bgView), VH(self.bgView));
                self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",100];
                self.devStatus.bri = 100;
            }
            self.devStatus.onoff = 1;
            self.devStatus.sat = [str intValue];
            self.deviceControlBlock(self.devStatus);
//            }else if (self.sliderView.center.x<= 10){
//                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
//            }
//            else{
//                NSLog(@"centerPoint.x == %.1f",((self.sliderView.center.x-10)/(KScreenWidth-80-20))*100);
//            }
        }
    }
}
#pragma mark - 色温滑块平移手势实时修改位置
- (void)animateToTempDestination:(CGPoint)centerPoint withDuration:(CGFloat)duration switch:(BOOL)on
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.tempSliderView.center = centerPoint;
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
#pragma mark - 滑块平移手势实时修改位置
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
#pragma mark-将颜色生成图片
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
#pragma mark - 创建模式按钮
- (void)createModelButtons
{
    self.sweetBtn = [[UIButton alloc] init];
    self.sweetBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self.sweetBtn setTitle:Localized(@"Pattern_sweet") forState:UIControlStateNormal];
    [self.sweetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sweetBtn addTarget:self action:@selector(sweetBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sweetBtn];
    self.sweetBtn.sd_layout
    .topSpaceToView(self, (KScreenHeight-80)/2-30)
    .centerXEqualToView(self)
    .widthIs(80)
    .heightIs(80);
    self.sweetBtn.layer.cornerRadius = 40;
    self.sweetBtn.layer.masksToBounds = YES;
    
    self.changesBtn = [[UIButton alloc] init];
    self.changesBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self.changesBtn setTitle:Localized(@"Pattern_fluctuate") forState:UIControlStateNormal];
    [self.changesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changesBtn addTarget:self action:@selector(changesBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.changesBtn];
    self.changesBtn.sd_layout
    .bottomSpaceToView(self.sweetBtn, 20)
    .centerXEqualToView(self)
    .widthIs(80)
    .heightIs(80);
    self.changesBtn.layer.cornerRadius = 40;
    self.changesBtn.layer.masksToBounds = YES;
    
    self.jumpBtn = [[UIButton alloc] init];
    self.jumpBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self.jumpBtn setTitle:Localized(@"Pattern_active") forState:UIControlStateNormal];
    [self.jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.jumpBtn addTarget:self action:@selector(jumpBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.jumpBtn];
    self.jumpBtn.sd_layout
    .topSpaceToView(self.sweetBtn, 20)
    .centerXEqualToView(self)
    .widthIs(80)
    .heightIs(80);
    self.jumpBtn.layer.cornerRadius = 40;
    self.jumpBtn.layer.masksToBounds = YES;
    
    self.romanceBtn = [[UIButton alloc] init];
    self.romanceBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self.romanceBtn setTitle:Localized(@"Pattern_romance") forState:UIControlStateNormal];
    [self.romanceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.romanceBtn addTarget:self action:@selector(romanceBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.romanceBtn];
    self.romanceBtn.sd_layout
    .topSpaceToView(self, (KScreenHeight-80)/2-30)
    .rightSpaceToView(self.sweetBtn, 20)
    .widthIs(80)
    .heightIs(80);
    self.romanceBtn.layer.cornerRadius = 40;
    self.romanceBtn.layer.masksToBounds = YES;
    
    self.illuminationBtn = [[UIButton alloc] init];
    self.illuminationBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
    [self.illuminationBtn setTitle:Localized(@"Pattern_illumination") forState:UIControlStateNormal];
    [self.illuminationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.illuminationBtn addTarget:self action:@selector(illuminationBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.illuminationBtn];
    self.illuminationBtn.sd_layout
    .topSpaceToView(self, (KScreenHeight-80)/2-30)
    .leftSpaceToView(self.sweetBtn, 20)
    .widthIs(80)
    .heightIs(80);
    self.illuminationBtn.layer.cornerRadius = 40;
    self.illuminationBtn.layer.masksToBounds = YES;
    self.sweetBtn.alpha = 0;
    self.changesBtn.alpha = 0;
    self.romanceBtn.alpha = 0;
    self.jumpBtn.alpha = 0;
    self.illuminationBtn.alpha = 0;
    
}
#pragma mark - 模式照明按钮事件
- (void)illuminationBtnAction
{
//    NSString *uuid =[[NSUUID UUID] UUIDString];
//    NSLog(@"照明 === %@",uuid);
    self.devStatus.hue = 160;
    self.deviceControlBlock(self.devStatus);
    if (self.devStatus.hue> 0) {
        self.colorImageView.image = [self gradientColorImageFromColors:@[[UIColor whiteColor], [self colorAtLocation:[self radianToCenterRadiu:self.devStatus.hue]]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
        CGPoint point = [self radianToCenterRadiu:self.devStatus.hue];
        self.colorPickerView.indicator.center = CGPointMake(point.x, point.y);
    }
}
#pragma mark - 模式浪漫按钮事件
- (void)romanceBtnAction
{
//    NSString *uuid =[[NSUUID UUID] UUIDString];
//    NSLog(@"浪漫 === %@",uuid);
    self.devStatus.hue = 80;
    self.deviceControlBlock(self.devStatus);
    if (self.devStatus.hue> 0) {
        self.colorImageView.image = [self gradientColorImageFromColors:@[[UIColor whiteColor], [self colorAtLocation:[self radianToCenterRadiu:self.devStatus.hue]]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
        CGPoint point = [self radianToCenterRadiu:self.devStatus.hue];
        self.colorPickerView.indicator.center = CGPointMake(point.x, point.y);
    }
}
#pragma mark - 模式跳跃按钮事件
- (void)jumpBtnAction
{
//    NSString *uuid =[[NSUUID UUID] UUIDString];
//    NSLog(@"跳跃 === %@",uuid);
    self.devStatus.hue = 200;
    self.deviceControlBlock(self.devStatus);
    if (self.devStatus.hue> 0) {
        self.colorImageView.image = [self gradientColorImageFromColors:@[[UIColor whiteColor], [self colorAtLocation:[self radianToCenterRadiu:self.devStatus.hue]]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
        CGPoint point = [self radianToCenterRadiu:self.devStatus.hue];
        self.colorPickerView.indicator.center = CGPointMake(point.x, point.y);
    }
}
#pragma mark - 模式变幻按钮事件
- (void)changesBtnAction
{
//    NSString *uuid =[[NSUUID UUID] UUIDString];
//    NSLog(@"变幻 === %@",uuid);
    self.devStatus.hue = 320;
    self.deviceControlBlock(self.devStatus);
    if (self.devStatus.hue> 0) {
        self.colorImageView.image = [self gradientColorImageFromColors:@[[UIColor whiteColor], [self colorAtLocation:[self radianToCenterRadiu:self.devStatus.hue]]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
        CGPoint point = [self radianToCenterRadiu:self.devStatus.hue];
        self.colorPickerView.indicator.center = CGPointMake(point.x, point.y);
    }
}
#pragma mark - 模式温馨按钮事件
- (void)sweetBtnAction
{
//    NSString *uuid =[[NSUUID UUID] UUIDString];
//    NSLog(@"温馨 === %@",uuid);
    self.devStatus.hue = 40;
    self.deviceControlBlock(self.devStatus);
    if (self.devStatus.hue> 0) {
        self.colorImageView.image = [self gradientColorImageFromColors:@[[UIColor whiteColor], [self colorAtLocation:[self radianToCenterRadiu:self.devStatus.hue]]] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(KScreenWidth-80, 50)];
        CGPoint point = [self radianToCenterRadiu:self.devStatus.hue];
        self.colorPickerView.indicator.center = CGPointMake(point.x, point.y);
    }
}
#pragma mark -取消按钮事件
- (void)cancelBtnAction
{
    self.cancelBlock(0);
    
}
#pragma mark - segment选择按钮事件
-(void)segmentSelect:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
    if (index==0) {
        self.sweetBtn.alpha = 0;
        self.changesBtn.alpha = 0;
        self.romanceBtn.alpha = 0;
        self.jumpBtn.alpha = 0;
        self.illuminationBtn.alpha = 0;
        
//        if (self.devStatus.serial_type == 2) {
//
//        }else{
            self.colorImageView.alpha = 0;
            self.sliderView.alpha = 0;
            self.imageView1.alpha = 0;
            self.imageView2.alpha = 0;
//        self.colorImageView1.alpha = 0;
//        }
        
        self.colorPickerView.alpha = 0;
        self.colorBgView.alpha = 0;
        
        self.brightnessSize.alpha = 1;
        self.bgView.alpha = 1;
        self.thumblView.alpha = 1;
        
        self.tempColorImageView.alpha = 1;
        self.tempSliderView.alpha = 1;
        self.tempImageView1.alpha = 1;
        self.tempImageView2.alpha = 1;
        
        
        CGFloat bgViewW = VW(self.bgView);
        CGFloat bgViewH = VH(self.bgView);
        if (self.devStatus.onoff == 1 && self.devStatus.bri > 0) {
            self.thumblView.frame = CGRectMake(0, bgViewH-((self.devStatus.bri*(VH(self.bgView)-20))/100+20), bgViewW, (self.devStatus.bri*(VH(self.bgView)-20))/100+20);
            [self.thumblView setBackgroundColor:[UIColor whiteColor]];
        }
    }else if (index == 1){
        
        self.brightnessSize.alpha = 0;
        self.bgView.alpha = 0;
        self.thumblView.alpha = 0;
        self.tempColorImageView.alpha = 0;
        self.tempSliderView.alpha = 0;
        self.tempImageView1.alpha = 0;
        self.tempImageView2.alpha = 0;
        
        
        self.sweetBtn.alpha = 0;
        self.changesBtn.alpha = 0;
        self.romanceBtn.alpha = 0;
        self.jumpBtn.alpha = 0;
        self.illuminationBtn.alpha = 0;
        
        self.colorBgView.alpha = 1;
        
//        if (self.devStatus.serial_type == 2) {
//
//        }else{
            self.colorImageView.alpha = 1;
            self.sliderView.alpha = 1;
            self.imageView1.alpha = 1;
            self.imageView2.alpha = 1;
//        }
//        self.colorImageView1.alpha = 1;
        self.colorPickerView.alpha = 1;
        if (self.devStatus.hue != 0xFFFF) {
            if (self.devStatus.sat > 0) {
                self.sliderView.frame = CGRectMake((self.devStatus.sat/100.0)*(KScreenWidth-80-20), 0, 20, 50);
            }
        }
        
        
    }else{
        self.brightnessSize.alpha = 0;
        self.bgView.alpha = 0;
        self.thumblView.alpha = 0;
        self.tempColorImageView.alpha = 0;
        self.tempSliderView.alpha = 0;
        self.tempImageView1.alpha = 0;
        self.tempImageView2.alpha = 0;
//        if (self.devStatus.serial_type == 2) {
//
//        }else{
            self.colorImageView.alpha = 0;
            self.sliderView.alpha = 0;
            self.imageView1.alpha = 0;
            self.imageView2.alpha = 0;
//        }
        self.colorPickerView.alpha = 0;
        self.colorBgView.alpha = 0;
//        self.colorImageView1.alpha = 0;
        
        self.sweetBtn.alpha = 1;
        self.changesBtn.alpha = 1;
        self.romanceBtn.alpha = 1;
        self.jumpBtn.alpha = 1;
        self.illuminationBtn.alpha = 1;
        
    }
    
}
#pragma mark - 修改亮度实时修改thumbView位置
- (void)animateToDestination:(CGRect)rect withDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
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
                         self.thumblView.frame = rect;
                         if ([self getPrecnetSize:rect.size.height-20] == 0) {
                             self.brightnessSize.text = Localized(@"Close");
                             self.devStatus.bri = 0;
                             self.devStatus.onoff = 0;
//                             self.deviceControlBlock(self.devStatus);
                         }else{
                             self.brightnessSize.text = [NSString stringWithFormat:@"%d%%",[self getPrecnetSize:rect.size.height-20]];
                             self.devStatus.bri = [self getPrecnetSize:rect.size.height-20];
                             self.devStatus.onoff = 1;
//                             self.deviceControlBlock(self.devStatus);
                         }
                         
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
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateChangeToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                return;
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
            }else{
                self.thumblView.backgroundColor = [UIColor whiteColor];
                CGFloat newH = (VH(self.bgView)-self.thumblView.center.y)*2;
                [self animateToDestination:CGRectMake(0, VH(self.bgView)-newH, VW(self.bgView), newH) withDuration:kAnimateDuration];
                return;
            }
            
        }
    }
}
#pragma mark - thumbView平移手势的事件
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
//    if(recognizer.state == UIGestureRecognizerStateChanged){
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
//根据滑块的高度计算出百分比
- (int)getPrecnetSize:(CGFloat)thumbHeight
{
    CGFloat size = thumbHeight*100/(VH(self.bgView)-20);
    return (int)size;
}
//根据百分比计算出滑块的高度
- (CGFloat)getThumbViewHeight:(CGFloat)precnetSize
{
    CGFloat size = (VH(self.bgView)-20)*precnetSize;
    return size;
}

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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
@implementation SetRGBDeviceMoreBtn

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
