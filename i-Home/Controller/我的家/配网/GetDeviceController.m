//
//  GetDeviceController.m
//  iThing
//
//  Created by Frank on 2018/7/31.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "GetDeviceController.h"
#import "MyFileHeader.h"
#import "SearchDevicesController.h"
#import "JoinNetworkController.h"
#import <QuartzCore/QuartzCore.h>
@interface GetDeviceController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *deviceImageView;

@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *firstTypeButton;
@property (nonatomic, strong) UILabel *hotTitle;
@property (nonatomic, strong) UILabel *hotDescribe;

@property (nonatomic, strong) UIButton *secondTypeButton;
@property (nonatomic, strong) UILabel *wifiTitle;
@property (nonatomic, strong) UILabel *wifiDescribe;

@property (nonatomic, strong) UIButton *helpButton;

@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *questionButton;
@end

@implementation GetDeviceController
{
    UIImageView *_navBarHairlineImageView;
    NSInteger _isConnectDeviceAP;
    NSInteger _isConnectWifi;
    NSInteger _isHotConnect;
    BOOL _isWifiConnect;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _isHotConnect = 1;
    [self createLeftBtn];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    _navBarHairlineImageView.hidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"ffffff"]];
    self.navigationController.navigationBar.translucent = NO;
//    [self longtoothHandel];
}
- (void)viewWillDisappear:(BOOL)animated{
    //如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"28a7ff"]];
}
- (void)createUI
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:26];
    self.titleLabel.text = @"Power up your Smart Plug";
    [self.view addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .topSpaceToView(self.view, 20)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(40);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.textColor = [UIColor grayColor];
    self.detailLabel.numberOfLines = 2;
    self.detailLabel.font = [UIFont systemFontOfSize:17];
    self.detailLabel.text = @"Plug in your Smart Plug. Make sure your\naccessory's green LED flashes slowly.";
    [self.view addSubview:self.detailLabel];
    self.detailLabel.sd_layout
    .topSpaceToView(self.titleLabel, 20)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(45);
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
    
    
    self.centerView = [[UIView alloc] init];
    [self.view addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _firstTypeButton = [UIButton new];
    _firstTypeButton.backgroundColor = [UIColor whiteColor];
    [_firstTypeButton addTarget:self action:@selector(firstTypeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _firstTypeButton.selected = YES;
    [_firstTypeButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    
    [self.centerView addSubview:_firstTypeButton];
    _firstTypeButton.layer.cornerRadius = 5;
    _firstTypeButton.layer.masksToBounds = YES;
    
    
    _hotTitle = [UILabel new];
    _hotTitle.textColor = [UIColor colorWithHexString:@"333333"];
    if (@available(iOS 8.2, *)) {
        [_hotTitle setFont:[UIFont systemFontOfSize:21.0 weight:UIFontWeightMedium]];
    } else {
        [_hotTitle setFont:[UIFont systemFontOfSize:21.0]];
    }
    _hotTitle.text = @"热点配网";
    [self.centerView addSubview:_hotTitle];
    
    _hotDescribe = [UILabel new];
    _hotDescribe.textColor = [UIColor colorWithHexString:@"333333"];
    if (@available(iOS 8.2, *)) {
        [_hotDescribe setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    } else {
        [_hotDescribe setFont:[UIFont systemFontOfSize:13.0]];
    }
    _hotDescribe.text = @"设备生成WI-FI热点,手机连接设备热点后将配网信息点对点发送给设备.";
    [self.centerView addSubview:_hotDescribe];
    _hotDescribe.numberOfLines = 2;
    
    
    _secondTypeButton = [UIButton new];
    _secondTypeButton.backgroundColor = [UIColor whiteColor];
    [_secondTypeButton addTarget:self action:@selector(secondTypeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    _secondTypeButton.selected = NO;
    [_secondTypeButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    [self.centerView addSubview:_secondTypeButton];
    _secondTypeButton.layer.cornerRadius = 5;
    _secondTypeButton.layer.masksToBounds = YES;
    
    
    _wifiTitle = [UILabel new];
    _wifiTitle.textColor = [UIColor colorWithHexString:@"333333"];
    if (@available(iOS 8.2, *)) {
        [_wifiTitle setFont:[UIFont systemFontOfSize:21.0 weight:UIFontWeightMedium]];
    } else {
        [_wifiTitle setFont:[UIFont systemFontOfSize:21.0]];
    }
    _wifiTitle.text = @"WI-FI快连";
    [self.centerView addSubview:_wifiTitle];
    
    _wifiDescribe = [UILabel new];
    _wifiDescribe.textColor = [UIColor colorWithHexString:@"333333"];
    if (@available(iOS 8.2, *)) {
        [_wifiDescribe setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium]];
    } else {
        [_wifiDescribe setFont:[UIFont systemFontOfSize:13]];
    }
    _wifiDescribe.text = @"确认设备已连上路由器,此时将手机连上同一路由器,将通过广播获取设备信息.";
    [self.centerView addSubview:_wifiDescribe];
    _wifiDescribe.numberOfLines = 2;
    
    
    self.helpButton = [[UIButton alloc] init];
    [self.centerView addSubview:self.helpButton];
    self.helpButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.helpButton setTitle:@"查看帮助" forState:UIControlStateNormal];
    [self.helpButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    if (@available(iOS 8.2, *)) {
        [self.helpButton.titleLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]];
    } else {
        [self.helpButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    }
    [self.helpButton addTarget:self action:@selector(helpButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    if (KScreenHeight == 568) {
        
        self.centerView.sd_layout
        .topSpaceToView(self.view, 155)
        .leftSpaceToView(self.view, 15)
        .rightSpaceToView(self.view, 15)
        .heightIs(180);
        
        _firstTypeButton.sd_layout
        .topSpaceToView(self.centerView, 20)
        .leftSpaceToView(self.centerView, 15)
        .widthIs(50)
        .heightIs(50);
        _firstTypeButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _hotTitle.sd_layout
        .topSpaceToView(self.centerView, 20)
        .leftSpaceToView(_firstTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(20);
        _hotDescribe.sd_layout
        .topSpaceToView(_hotTitle, 0)
        .leftSpaceToView(_firstTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(30);
        
        _secondTypeButton.sd_layout
        .topSpaceToView(self.firstTypeButton, 10)
        .leftSpaceToView(self.centerView, 15)
        .widthIs(50)
        .heightIs(50);
        _secondTypeButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _wifiTitle.sd_layout
        .topSpaceToView(self.firstTypeButton, 10)
        .leftSpaceToView(_secondTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(20);
        
        _wifiDescribe.sd_layout
        .topSpaceToView(_wifiTitle, 0)
        .leftSpaceToView(_secondTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(30);
        
        self.helpButton.sd_layout
        .bottomSpaceToView(self.centerView, 10)
        .centerXEqualToView(self.centerView)
        .widthIs(120)
        .heightIs(30);
        
    }else if (KScreenHeight > 568){
        if (KScreenHeight == 667) {
            self.centerView.sd_layout
            .topSpaceToView(self.view, 155)
            .leftSpaceToView(self.view, 15)
            .rightSpaceToView(self.view, 15)
            .heightIs(240);
           
            _firstTypeButton.sd_layout
            .topSpaceToView(self.centerView, 20)
            .leftSpaceToView(self.centerView, 15)
            .widthIs(70)
            .heightIs(70);
            _firstTypeButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
            _hotTitle.sd_layout
            .topSpaceToView(self.centerView, 20)
            .leftSpaceToView(_firstTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(30);
            
            _hotDescribe.sd_layout
            .topSpaceToView(_hotTitle, 0)
            .leftSpaceToView(_firstTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(40);
            
            
            _secondTypeButton.sd_layout
            .topSpaceToView(self.firstTypeButton, 10)
            .leftSpaceToView(self.centerView, 15)
            .widthIs(70)
            .heightIs(70);
            _secondTypeButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
            
            _wifiTitle.sd_layout
            .topSpaceToView(self.firstTypeButton, 10)
            .leftSpaceToView(_secondTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(30);
            
            _wifiDescribe.sd_layout
            .topSpaceToView(_wifiTitle, 0)
            .leftSpaceToView(_secondTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(40);
            self.helpButton.sd_layout
            .bottomSpaceToView(self.centerView, 10)
            .centerXEqualToView(self.centerView)
            .widthIs(120)
            .heightIs(30);
            
        }else{
            self.centerView.sd_layout
            .topSpaceToView(self.view, 155)
            .leftSpaceToView(self.view, 15)
            .rightSpaceToView(self.view, 15)
            .heightIs(280);
            
            _firstTypeButton.sd_layout
            .topSpaceToView(self.centerView, 20)
            .leftSpaceToView(self.centerView, 15)
            .widthIs(70)
            .heightIs(70);
            _firstTypeButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
            _hotTitle.sd_layout
            .topSpaceToView(self.centerView, 20)
            .leftSpaceToView(_firstTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(30);
            _hotDescribe.sd_layout
            .topSpaceToView(_hotTitle, 0)
            .leftSpaceToView(_firstTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(40);
            
            _secondTypeButton.sd_layout
            .topSpaceToView(self.firstTypeButton, 10)
            .leftSpaceToView(self.centerView, 15)
            .widthIs(70)
            .heightIs(70);
            _secondTypeButton.imageEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
            
            _wifiTitle.sd_layout
            .topSpaceToView(self.firstTypeButton, 10)
            .leftSpaceToView(_secondTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(30);
            
            _wifiDescribe.sd_layout
            .topSpaceToView(_wifiTitle, 0)
            .leftSpaceToView(_secondTypeButton, 10)
            .rightSpaceToView(self.centerView, 10)
            .heightIs(40);
            self.helpButton.sd_layout
            .bottomSpaceToView(self.centerView, 10)
            .centerXEqualToView(self.centerView)
            .widthIs(120)
            .heightIs(40);
        }
    }else{
        self.centerView.sd_layout
        .topSpaceToView(self.view, 155)
        .leftSpaceToView(self.view, 15)
        .rightSpaceToView(self.view, 15)
        .heightIs(150);
        
        _firstTypeButton.sd_layout
        .topSpaceToView(self.centerView, 20)
        .leftSpaceToView(self.centerView, 15)
        .widthIs(40)
        .heightIs(40);
        _firstTypeButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _hotTitle.sd_layout
        .topSpaceToView(self.centerView, 20)
        .leftSpaceToView(_firstTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(15);
        _hotDescribe.sd_layout
        .topSpaceToView(_hotTitle, 0)
        .leftSpaceToView(_firstTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(25);
        
        _secondTypeButton.sd_layout
        .topSpaceToView(self.firstTypeButton, 10)
        .leftSpaceToView(self.centerView, 15)
        .widthIs(40)
        .heightIs(40);
        _secondTypeButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _wifiTitle.sd_layout
        .topSpaceToView(self.firstTypeButton, 10)
        .leftSpaceToView(_secondTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(15);
        
        _wifiDescribe.sd_layout
        .topSpaceToView(_wifiTitle, 0)
        .leftSpaceToView(_secondTypeButton, 10)
        .rightSpaceToView(self.centerView, 10)
        .heightIs(25);
        self.helpButton.sd_layout
        .bottomSpaceToView(self.centerView, 10)
        .centerXEqualToView(self.centerView)
        .widthIs(120)
        .heightIs(30);
    }
    
    
    
    
   
    self.nextButton = [[UIButton alloc] init];
    [self.view addSubview:self.nextButton];
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"4382E4"];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.sd_layout
    .topSpaceToView(self.centerView, 30)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(50);
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.layer.masksToBounds = YES;
    
    
    
    
    

    
    self.questionButton = [[UIButton alloc] init];
    [self.view addSubview:self.questionButton];
    self.questionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.questionButton setTitle:@"My Wi-Fi light is not flashing green?" forState:UIControlStateNormal];
    [self.questionButton setTitleColor:[UIColor colorWithHexString:@"4382E4"] forState:UIControlStateNormal];
    [self.questionButton addTarget:self action:@selector(questionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.questionButton.sd_layout
    .topSpaceToView(self.nextButton, 20)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(50);
    
    
    //给指定元件添加动效:[yourUIView.layer addAnimation:[self AlphaLight:0.5] forKey:@"aAlpha"];
    //移除动画:[_myView.layer removeAnimationForKey:@"aAlpha"];
}

- (void)helpButtonAction
{
}
- (void)secondTypeButtonAction
{
    if (!self.secondTypeButton.selected) {
         _isHotConnect = 2;
        [_secondTypeButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [_firstTypeButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        _secondTypeButton.selected = YES;
        _firstTypeButton.selected = NO;
    }
}
- (void)firstTypeButtonAction
{
    if (!self.firstTypeButton.selected) {
         _isHotConnect = 1;
        [_firstTypeButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [_secondTypeButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        _firstTypeButton.selected = YES;
        _secondTypeButton.selected = NO;
    }
    
    
}
-(CABasicAnimation *) AlphaLight:(float)time
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;//动画循环的时间，也就是呼吸灯效果的速度
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}






- (void)questionButtonAction
{
    
}
- (void)nextButtonAction
{
    if (_isHotConnect == 1) {
        JoinNetworkController *joinCtrl = [[JoinNetworkController alloc] init];
        [self.navigationController pushViewController:joinCtrl animated:YES];
    }else{
        SearchDevicesController *searchCtrl = [[SearchDevicesController alloc] init];
        [self presentViewController:searchCtrl animated:YES completion:nil];
    }
    
}
- (void)createLeftBtn
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = itemleft;
}

- (void)leftAction
{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
