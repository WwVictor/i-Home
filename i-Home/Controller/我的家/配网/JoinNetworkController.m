//
//  JoinNetworkController.m
//  iThing
//
//  Created by Frank on 2018/7/31.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "JoinNetworkController.h"
#import <NetworkExtension/NetworkExtension.h>
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#include <arpa/inet.h>
#import "GetDeviceNetworkIP.h"
#import "SetUpViewController.h"
#import "ConnectSuccessController.h"
@interface JoinNetworkController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *detailTitleLabel;
@property (nonatomic, strong)UILabel *detailFirstLabel;
@property (nonatomic, strong)UILabel *detailSecondLabel;
@property (nonatomic, strong)TuYeTextField *wifiTextField;
@property (nonatomic, strong)TuYeTextField *pwTextField;
@property (nonatomic, strong)UIButton *choosewifiButton;
@property (nonatomic, strong)UIButton *eyeButton;
@property (nonatomic, strong)UIButton *nextButton;

@property (nonatomic, strong)DeviceMessageModel *deviceMessModel;

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *wifiListArray;

@end

@implementation JoinNetworkController
{
    UIImageView *_navBarHairlineImageView;
    NSInteger _isConnectDeviceAP;
}
#pragma mark - 懒加载
-(NSMutableArray *)wifiListArray
{
    if (_wifiListArray == nil) {
        _wifiListArray = [NSMutableArray array];
    }
    return _wifiListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self scanf];
//    [self scanWifiInfos];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.hidden = NO;
//    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
//    _navBarHairlineImageView = backgroundView.subviews.firstObject;
//    _navBarHairlineImageView.hidden = YES;
    [self addNotificationObserver];
    if (@available(iOS 11.0, *)) {
        [[NEHotspotConfigurationManager sharedManager] getConfiguredSSIDsWithCompletionHandler:^(NSArray * array) {
            for(NSString* str in array) {
                NSLog(@"结果：%@",str);
                [self.wifiListArray addObject:str];
            }
        }];
    } else {
        // Fallback on earlier versions
    }
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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)createUI
{
    self.scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollView];
    self.scrollView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomEqualToView(self.view);
    self.scrollView.contentSize = CGSizeMake(KScreenWidth, 0);
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    [self.scrollView addGestureRecognizer:myTap];
    

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:26];
    self.titleLabel.text = @"Joining your network";
    [self.scrollView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .topSpaceToView(self.scrollView, 20)
    .leftSpaceToView(self.scrollView, 10)
    .rightSpaceToView(self.scrollView, 10)
    .heightIs(40);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.detailTitleLabel = [[UILabel alloc] init];
    self.detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTitleLabel.textColor = [UIColor grayColor];
    
    self.detailTitleLabel.numberOfLines = 0;
    self.detailTitleLabel.font = [UIFont systemFontOfSize:15];
    self.detailTitleLabel.text = @"Make sure to enter the correct Wi-Fi password to\nprevent the installation from failing.";
    [self.scrollView addSubview:self.detailTitleLabel];
    self.detailTitleLabel.sd_layout
    .topSpaceToView(self.titleLabel, 20)
    .leftSpaceToView(self.scrollView, 15)
    .rightSpaceToView(self.scrollView, 15)
    .heightIs(50);
    [self.detailTitleLabel sizeToFit];
    self.detailTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    
    self.detailFirstLabel = [[UILabel alloc] init];
    self.detailFirstLabel.textAlignment = NSTextAlignmentCenter;
    self.detailFirstLabel.textColor = [UIColor grayColor];
    self.detailFirstLabel.numberOfLines = 0;
    self.detailFirstLabel.font = [UIFont systemFontOfSize:15];
    self.detailFirstLabel.text = @"1.Accessories do NOT work on any 5 GHz Wi-Fi\nnetwork.";
    [self.scrollView addSubview:self.detailFirstLabel];
    self.detailFirstLabel.sd_layout
    .topSpaceToView(self.detailTitleLabel, 20)
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .heightIs(40);
    self.detailFirstLabel.adjustsFontSizeToFitWidth = YES;
    
    self.detailSecondLabel = [[UILabel alloc] init];
    self.detailSecondLabel.textAlignment = NSTextAlignmentCenter;
    self.detailSecondLabel.textColor = [UIColor grayColor];
    self.detailSecondLabel.numberOfLines = 2;
    self.detailSecondLabel.font = [UIFont systemFontOfSize:15];
    self.detailSecondLabel.text = @"2.If you have a dual band router,please connect\nyour phone to the 2.4 GHz Wi-Fi network.";
    [self.scrollView addSubview:self.detailSecondLabel];
    self.detailSecondLabel.sd_layout
    .topSpaceToView(self.detailFirstLabel, 0)
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .heightIs(40);
    self.detailSecondLabel.adjustsFontSizeToFitWidth = YES;
    
    // wifi输入框
    self.wifiTextField = [[TuYeTextField alloc] init];
//    self.wifiTextField.text = @"longtooth";
    self.wifiTextField.font = [UIFont systemFontOfSize:18];
    self.wifiTextField.borderStyle = UITextBorderStyleRoundedRect;
//    NSString *wifiName = [[GetDeviceNetworkIP shareManager] ssid];
    self.wifiTextField.text = [[GetDeviceNetworkIP shareManager] ssid];
//    self.wifiTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"wifi_name"];
    [self.scrollView addSubview:self.wifiTextField];
    self.wifiTextField.sd_layout
    .topSpaceToView(self.detailSecondLabel, 40)
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .heightIs(50);
    self.wifiTextField.returnKeyType = UIReturnKeyGo;
    // wifi输入框右侧的图标
    self.choosewifiButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [self.choosewifiButton addTarget:self action:@selector(choosewifiButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.choosewifiButton.selected = NO;
    [self.choosewifiButton setImage:[UIImage imageNamed:@"关闭wifi列表"] forState:UIControlStateNormal];
    self.wifiTextField.rightView = self.choosewifiButton;
    self.wifiTextField.rightViewMode = UITextFieldViewModeAlways;
    // wifi输入框左侧的图标
    UIImageView *wifiImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    wifiImageView.image = [UIImage imageNamed:@"WiFi_icon"];
    self.wifiTextField.leftView = wifiImageView;
    self.wifiTextField.leftViewMode = UITextFieldViewModeAlways;
    self.wifiTextField.placeholder = @"请先连接Wi-Fi";
    
    // wifi密码输入框
    self.pwTextField = [[TuYeTextField alloc] init];
    self.pwTextField.font = [UIFont systemFontOfSize:18];
    
//    self.pwTextField.text = [[GetDeviceNetworkIP shareManager] ssid];
    self.pwTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.pwTextField.secureTextEntry = YES;
    [self.scrollView addSubview:self.pwTextField];
    self.pwTextField.sd_layout
    .topSpaceToView(self.wifiTextField, -1)
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .heightIs(50);
    self.pwTextField.returnKeyType = UIReturnKeyGo;
    // wifi密码输入框右侧的图标
    self.eyeButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [self.eyeButton addTarget:self action:@selector(eyeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.eyeButton.selected = NO;
    [self.eyeButton setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    self.pwTextField.rightView = self.eyeButton;
    self.pwTextField.rightViewMode = UITextFieldViewModeAlways;
    // wifi密码输入框左侧的图标
    self.pwTextField.placeholder = @"请输入WiFi密码";
    
    self.nextButton = [[UIButton alloc] init];
    [self.scrollView addSubview:self.nextButton];
//    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"008DD4"];
    self.nextButton.backgroundColor = [UIColor colorWithHexString:@"4382E4"];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.sd_layout
    .topSpaceToView(self.pwTextField, 60)
    .leftSpaceToView(self.scrollView, 20)
    .rightSpaceToView(self.scrollView, 20)
    .heightIs(50);
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.layer.masksToBounds = YES;
}

- (void)scrollTap:(id)sender {
    [self.view endEditing:YES];
}
- (void)addNotificationObserver
{
    //1.获取通知中心
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //2.添加要监听的频道
    //第一个参数：表示谁来监听通知中心发送的消息
    //第二个参数：当通知中心发送了你监听的消息时触发的方法
    //第三个参数：监听的通知的名称
    //第四个参数：表示传递的参数
    [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary * dict = notification.userInfo;
    //获取键盘弹出所需的时间
    CGFloat duration = [dict[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    //修改输入框的位置
    [UIView animateWithDuration:duration animations:^{
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dict = notification.userInfo;
    CGRect frame = self.pwTextField.frame;
    //获取键盘高度
    CGSize kbSize = [[dict objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    //140是文本框的高度，如果你的文本框高度不一样，则可以进行不同的调整
    CGFloat offSet = frame.origin.y + 216 - (self.view.frame.size.height - kbSize.height);
    //将试图的Y坐标向上移动offset个单位，以使界面腾出开的地方用于软键盘的显示
    //获取键盘弹出所需的时间
    CGFloat duration = [dict[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    if (offSet > 0.01) {
        //修改输入框的位置
        [UIView animateWithDuration:duration animations:^{
            self.scrollView.contentOffset = CGPointMake(0, offSet);
        }];
    }
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)nextButtonAction
{
    if (self.wifiTextField.text.length == 0) {
        [SVProgressHUD doAnyRemindWithHUDMessage:@"请选择要连接的wifi" withDuration:1.5];
    }else{
        if (self.pwTextField.text.length == 0) {
            [SVProgressHUD doAnyRemindWithHUDMessage:@"请输入WiFi密码" withDuration:1.5];
        }else{
            if (self.pwTextField.text.length < 8) {
                [SVProgressHUD doAnyRemindWithHUDMessage:@"请输入正确的WiFi密码" withDuration:1.5];
            }else{
//                if (self->_isConnectDeviceAP == 0) {
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"tx_user_notice_con_device_ap") message:Localized(@"tx_user_notice_select_device_ap") preferredStyle:UIAlertControllerStyleActionSheet];
//                    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"Cancel") style:UIAlertActionStyleCancel handler:nil]];
//                    [alert addAction:[UIAlertAction actionWithTitle:Localized(@"tx_user_notice_con_device") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    self->_isConnectDeviceAP = 1;
                    SetUpViewController *jointrl = [[SetUpViewController alloc] init];
                    jointrl.wifiString = self.wifiTextField.text;
                    jointrl.passwordString = self.pwTextField.text;
                    jointrl.oldDeviceModel = self.deviceMessModel;
                    [self.navigationController pushViewController:jointrl animated:YES];
//                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        if ([[UIApplication sharedApplication] canOpenURL:url]) {
//                            [[UIApplication sharedApplication] openURL:url];
//                        }
//                        NSString * urlString = @"App-Prefs:root=WIFI";
//                        NSData *encryptString = [[NSData alloc] initWithBytes:(unsigned char []){0x41,0x70,0x70,0x2d,0x50,0x72,0x65,0x66,0x73,0x3a,0x72,0x6f,0x6f,0x74,0x3d,0x4e,0x4f,0x54,0x49,0x46,0x49,0x43,0x41,0x54,0x49,0x4f,0x4e,0x53,0x5f,0x49,0x44} length:27];
                        
//                        NSString *urlString = [[NSString alloc] initWithData:encryptString encoding:NSUTF8StringEncoding];
                        
                        //                        NSURL * urlString = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//                        NSURL * urlString = [NSURL URLWithString:string];
//                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
//                            if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
//                                if (@available(iOS 10.0, *)) {
//                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
//                                } else {
//                                    // Fallback on earlier versions
//                                }
//                            } else {
//                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
//                            }
//                        }
//                    }]];
//                    [self presentViewController:alert animated:YES completion:nil];
//                }else{
//                    NSString *wifiName = [[GetDeviceNetworkIP shareManager] ssid];
//                    if ([wifiName containsString:@"iThing"] || [wifiName containsString:@"iHaper"] || [wifiName containsString:@"ap-w600"]) {
//                        ConfigureDataController *jointrl = [[ConfigureDataController alloc] init];
//                        jointrl.wifiString = self.wifiTextField.text;
//                        jointrl.passwordString = self.pwTextField.text;
//                        jointrl.oldDeviceModel = self.deviceMessModel;
//                        [self.navigationController pushViewController:jointrl animated:YES];
//                    }else{
//                        [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"tx_user_notice_con_device_ap_failed") withDuration:1.5];
//                    }
//
//                }
                
                
                
            }
        }
    }
}
- (void)eyeButtonAction
{
    if (self.eyeButton.selected) {
        self.eyeButton.selected = NO;
        self.pwTextField.secureTextEntry = YES;
       [self.eyeButton setImage:[UIImage imageNamed:@"密码不可见"] forState:UIControlStateNormal];
    }else{
        self.eyeButton.selected = YES;
        self.pwTextField.secureTextEntry = NO;
        [self.eyeButton setImage:[UIImage imageNamed:@"密码可见"] forState:UIControlStateNormal];
    }
}
- (void)choosewifiButtonAction
{
    if (self.choosewifiButton.selected) {
        self.choosewifiButton.selected = NO;
        [self.choosewifiButton setImage:[UIImage imageNamed:@"关闭wifi列表"] forState:UIControlStateNormal];
        self.listTableView.frame = CGRectZero;
        [self.listTableView removeFromSuperview];
        
        
    }else{
        self.choosewifiButton.selected = YES;
        [self.choosewifiButton setImage:[UIImage imageNamed:@"打开wifi列表"] forState:UIControlStateNormal];
        
        self.listTableView = [[UITableView alloc] init];
        self.listTableView.showsVerticalScrollIndicator = NO;
        self.listTableView.delegate = self;
        self.listTableView.dataSource = self;
        self.listTableView.layer.cornerRadius = 5.0;
        self.listTableView.layer.masksToBounds = YES;
        self.listTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:self.listTableView];
        if (self.wifiListArray.count <=5) {
            self.listTableView .sd_layout
            .topSpaceToView(self.wifiTextField,0)
            .leftEqualToView(self.wifiTextField)
            .rightEqualToView(self.wifiTextField)
            .heightIs(self.wifiListArray.count*45);
        }else{
            self.listTableView .sd_layout
            .topSpaceToView(self.wifiTextField,0)
            .leftEqualToView(self.wifiTextField)
            .rightEqualToView(self.wifiTextField)
            .heightIs(5*45);
        }
        if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.listTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.listTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [self.listTableView reloadData];
        
    }
}



#pragma mark - UITableViewDelegate and UITableViewDataSource
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wifiListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
     [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *wifiLabel = [[UILabel alloc] initWithFrame:cell.contentView.frame];
    [cell.contentView addSubview:wifiLabel];
    if (@available(iOS 8.2, *)) {
        wifiLabel.font = [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium];
    }else {
        wifiLabel.font = [UIFont systemFontOfSize:17.0];
    }
    wifiLabel.textColor = [UIColor colorWithHexString:@"333333"];
    wifiLabel.textAlignment = NSTextAlignmentCenter;
    NSString *wifiString = self.wifiListArray[indexPath.row];
    wifiLabel.text = wifiString;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.listTableView.frame = CGRectZero;
    [self.listTableView removeFromSuperview];
    self.wifiTextField.text = self.wifiListArray[indexPath.row];
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scanf{
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    [options setObject:@"新网程" forKey:kNEHotspotHelperOptionDisplayName];
    
    dispatch_queue_t queue = dispatch_queue_create("com.pronetway.GetwifiList", NULL);
    BOOL returnType = [NEHotspotHelper registerWithOptions:options queue:queue handler: ^(NEHotspotHelperCommand * cmd) {
        NEHotspotNetwork* network;
        NSLog(@"COMMAND TYPE:   %ld", (long)cmd.commandType);
        [cmd createResponse:kNEHotspotHelperResultAuthenticationRequired];
        if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType ==kNEHotspotHelperCommandTypeFilterScanList) {
            NSLog(@"WIFILIST:   %@", cmd.networkList);
            for (network  in cmd.networkList) {
                // NSLog(@"COMMAND TYPE After:   %ld", (long)cmd.commandType);
                if ([network.SSID isEqualToString:@"ssid"]|| [network.SSID isEqualToString:@"@ProWIFI"]) {
                    
                    double signalStrength = network.signalStrength;
                    NSLog(@"Signal Strength: %f", signalStrength);
                    [network setConfidence:kNEHotspotHelperConfidenceHigh];
                    [network setPassword:@"password"];
                    
                    NEHotspotHelperResponse *response = [cmd createResponse:kNEHotspotHelperResultSuccess];
                    NSLog(@"Response CMD %@", response);
                    
                    [response setNetworkList:@[network]];
                    [response setNetwork:network];
                    [response deliver];
                }
            }
        }
    }];
    NSLog(@"result :%d", returnType);
    NSArray *array = [NEHotspotHelper supportedNetworkInterfaces];
    NSLog(@"wifiArray:%@", array);
    NEHotspotNetwork *connectedNetwork = [array lastObject];
    NSLog(@"supported Network Interface: %@", connectedNetwork);
}


-(void)scanWifiInfos{
    NSLog(@"in wifi scan");
    NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
    //NSMutableDictionary* infos = [[NSMutableDictionary alloc] init];
    
    [options setObject:@"meme" forKey:kNEHotspotHelperOptionDisplayName];
    
    dispatch_queue_t queue = dispatch_queue_create("LiyiZhan.WifiDemo", 0);
    
    BOOL returnType = [NEHotspotHelper registerWithOptions:options queue:queue handler:^(NEHotspotHelperCommand * cmd){
        NSLog(@"returnType is ---> %d",returnType);
        NSLog(@"in block");
        [cmd createResponse:kNEHotspotHelperResultAuthenticationRequired];
        if(cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType == kNEHotspotHelperCommandTypeFilterScanList){
            NSLog(@"bbbb = %lu",cmd.networkList.count);
            for(NEHotspotNetwork* network in cmd.networkList){
                
                //                if (_networkListArr.count<=cmd.networkList.count) {
                if (network.SSID!= nil || ![network.SSID isEqualToString:@""]) {
                    //                        NetworkListModel *model = [[NetworkListModel alloc]init];
                    //                        model.ssid = network.SSID;
                    //                        model.bssid = network.BSSID;
                    //                        model.signalStrength = network.signalStrength;
                    //                        NSLog(@"---ssid --- is %@",model.ssid);
                    //                        [self.networkListArr addObject:model];
                }
                //                }else {
                
                NSLog(@"不做操作");
                //                }
                //                NSString* ssid = network.SSID;
                //                NSString* bssid = network.BSSID;
                //                BOOL secure = network.secure;
                //                BOOL autoJoined = network.autoJoined;
                //                double signalStrength = network.signalStrength;
                //
                //                NSLog(@"SSID:->%@\n BSSID:--->%@ \n SIGNAL:---->%f",ssid,bssid,signalStrength);
                
                
            }
        }
        //        NetworkListModel *model = _networkListArr[0];
        //        NSLog(@"数组里面第一个ssid 是 ---> %@ \n  数组的个数是--->%lu",model.ssid,(unsigned long)_networkListArr.count);
        
    }];
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
