//
//  SetUpViewController.m
//  iThing
//
//  Created by Frank on 2019/1/10.
//  Copyright © 2019 Frank. All rights reserved.
//
#import "SetUpViewController.h"
#import "MyFileHeader.h"
#import "ConnectSuccessController.h"
@interface SetUpViewController ()
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *remindImageView;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)UIButton *nextButton;
@property (nonatomic, strong)UIButton *questionButton;
@end

@implementation SetUpViewController
{
    NSInteger _researchLtidNum;
    NSTimer * _researchTimer;
    UIImageView *_navBarHairlineImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    _navBarHairlineImageView = backgroundView.subviews.firstObject;
    _navBarHairlineImageView.hidden = YES;
    self.title = @"SETUP";
    [self createUI];
}
- (void)researchBtnTimerAction
{
        NSString *wifiName = [[GetDeviceNetworkIP shareManager] ssid];
        NSLog(@"wifiName === %@",wifiName);
        if (([wifiName containsString:@"iThing"] || [wifiName containsString:@"iHaper"] || [wifiName containsString:@"ap-w600"])) {
            [_researchTimer invalidate];
            _researchTimer = nil;
            ConnectSuccessController *jointrl = [[ConnectSuccessController alloc] init];
            jointrl.wifiString = self.wifiString;
            jointrl.passwordString = self.passwordString;
            jointrl.oldDeviceModel = self.oldDeviceModel;
            [self.navigationController pushViewController:jointrl animated:YES];
        }
}
- (void)createUI
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:26];
    self.titleLabel.text = @"Connect your iPhone to your iThing Device";
    self.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(10);
        make.left.mas_equalTo(self.view).offset(10);
        make.width.mas_equalTo(KScreenWidth-20);
        
    }];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    
    
    self.remindImageView = [[UIImageView alloc] init];
    self.remindImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImage *bgImage = [UIImage imageNamed:@"setup_wifi.jpg"];
    self.remindImageView.image = bgImage;
    [self.view addSubview:self.remindImageView];
//    self.remindImageView.backgroundColor = [UIColor grayColor];
    [self.remindImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(10);
        make.width.mas_equalTo(KScreenWidth-20);
        make.height.mas_equalTo((KScreenWidth-20)*bgImage.size.height/bgImage.size.width);
    }];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.textColor = [UIColor blackColor];
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.font = [UIFont systemFontOfSize:17];
    self.detailLabel.text = @" Go to your Wi-Fi settings on this iPhone and select the network of the format iThing-XXX.\nIt may take up to a minute to display.After connecting your iPhone to iThing-XXX Wi-Fi,return to the iThing App to continue setup.";
    [self.view addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(10);
         make.width.mas_equalTo(KScreenWidth-20);
    }];
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
    
    
//    self.questionButton = [[UIButton alloc] init];
//    [self.view addSubview:self.questionButton];
//    self.questionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    [self.questionButton setTitle:@"DONT'T SEE THE ORANGE LIGHT RING?" forState:UIControlStateNormal];
//    [self.questionButton setTitleColor:[UIColor colorWithHexString:@"4382E4"] forState:UIControlStateNormal];
//    [self.questionButton addTarget:self action:@selector(questionButtonAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.questionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(20);
//        make.left.mas_equalTo(self.view).offset(20);
//        make.right.mas_equalTo(self.view).offset(-20);
//        make.height.mas_equalTo(50);
//    }];
    
    
    self.nextButton = [[UIButton alloc] init];
    [self.view addSubview:self.nextButton];
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"4382E4"];
    [self.nextButton setTitle:@"CANCEL SETUP" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-30-SafeAreaBottomHeight);
        make.left.mas_equalTo(self.view).offset(30);
        make.right.mas_equalTo(self.view).offset(-30);
        make.height.mas_equalTo(50);
    }];
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.layer.masksToBounds = YES;
    
    
}

- (void)nextButtonAction
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"dev_broadcast_pop_notice_quit") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"dev_broadcast_pop_quit") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 返回到任意界面
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[JoinNetworkController class]]) {
                [self->_researchTimer invalidate];
                self->_researchTimer = nil;
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

//iOS 设置导航栏全透明
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _researchLtidNum = 0;
    _researchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(researchBtnTimerAction) userInfo:nil repeats:YES];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//    self.navigationController.navigationBar.translucent = YES;
//    //设置导航栏背景图片为一个空的image，这样就透明了
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    //去掉透明后导航栏下边的黑边
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithHexString:@"ffffff"]];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    //如果不想让其他页面的导航栏变为透明 需要重置
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
