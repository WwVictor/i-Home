//
//  ConfigureDataController.m
//  iThing
//
//  Created by Frank on 2018/7/31.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "ConfigureDataController.h"
#import "CircleProgressView.h"
#import <NetworkExtension/NetworkExtension.h>
#import <NetworkExtension/NEHotspotConfigurationManager.h>
#import "DeviceTypeManager.h"
#include <arpa/inet.h>
#import "DeclareAbnormalAlertView.h"
#import "LongToothHandler.h"
#import "MyFileHeader.h"
#import "LTNetWorkReachability.h"
#import "SetUpViewController.h"
#import "MYHomeViewController.h"
@interface ConfigureDataController ()<HandleEventDelegate,DeclareAbnormalAlertViewDelegate>

@property (nonatomic, strong) CircleProgressView *circleProgress;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailTitleLabel;
@property (nonatomic, strong) UIImageView *fisrtImageView;
@property (nonatomic, strong) UILabel *firstLabel;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UILabel *thirdLabel;
@property (nonatomic, strong) UIImageView *forthImageView;
@property (nonatomic, strong) UILabel *forthLabel;
@property (nonatomic, strong) LongToothHandler *longtoothHandler;
@property (nonatomic, strong) DeviceInformationModel *deviceInfoModel;

@property (nonatomic) LTNetWorkReachability *hostReachability;
@end

@implementation ConfigureDataController
{
    UIImageView *_navBarHairlineImageView;
    NSInteger _researchLtidNum;
    NSTimer * _researchTimer;
    NSMutableDictionary *_deviceDict;
    NSString *_deviceName;
    NSMutableArray *_devicesNameArr;
    NSInteger _selectNextNum;
    
    NSInteger _epsGet_dev_info;
    NSInteger _get_dev_info;
    NSInteger _dev_changeWifi;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.longtoothHandler = [LongToothHandler sharedInstance];
    [[LongToothHandler sharedInstance] configHandleEventDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
    _navBarHairlineImageView = backgroundView.subviews.firstObject;
    _navBarHairlineImageView.hidden = YES;
    [self createLeftBtn];
    [self createUI];
    
}

- (void)handleEventNotification:(id)objc andServiceName:(NSString *)serviceName
{
     if ([serviceName isEqualToString:GET_DEVICEINFO]){
        if (_get_dev_info > 3) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.circleProgress.centerLabel.font = [UIFont systemFontOfSize:17];
                self.circleProgress.centerLabel.text = Localized(@"tx_user_notice_search_device_failed");
                [self->_researchTimer invalidate];
                self->_researchTimer = nil;
                [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"tx_user_notice_search_device_failed") withDuration:1.0];
            });
        }else{
                self->_get_dev_info++;
            UserMessageModel *usermodel = KGetUserMessage;
            
            NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\"}",usermodel.userID];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                [self.longtoothHandler sendRequestWithRemoteLtid:objc[@"ltid"] ServiceName:GET_DEVICEINFO insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                    if ([serviceName isEqualToString:GET_DEVICEINFO]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.secondImageView.image = [UIImage imageNamed:@"已完成"];
                            self.secondLabel.textColor = [UIColor blackColor];
                            self.deviceMessModel = [DeviceMessageModel mj_objectWithKeyValues:receiveStr];
                            self.deviceMessModel.dev_mac = [self.deviceMessModel.dev_mac substringToIndex:12];
                            self.deviceMessModel.longtooth_id = receiveStr[@"ltid"];
                            NSLog(@"dev_mac === %@",self.deviceMessModel.dev_mac);
                            
                            self->_deviceDict = [[NSMutableDictionary alloc] initWithDictionary:receiveStr];
                            [self->_deviceDict setValue:[self->_deviceDict[@"dev_mac"] substringToIndex:12] forKey:@"dev_mac"];
                            NSLog(@"deviceMessDict === %@",self->_deviceDict);
                            self->_selectNextNum = 0;
                            self->_devicesNameArr = [NSMutableArray array];
                            [self remindHandel];
                        });
                        
                    }
                }];
        }
    }else if ([serviceName isEqualToString:DEV_CHANGEWIFI]){
        if (_dev_changeWifi > 2) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.circleProgress.centerLabel.font = [UIFont systemFontOfSize:17];
                self.circleProgress.centerLabel.text = Localized(@"tx_user_notice_network_device_failed");
                [self->_researchTimer invalidate];
                self->_researchTimer = nil;
                [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"tx_user_notice_network_device_failed") withDuration:1.0];
            });
        }else{
            _dev_changeWifi++;
            [self RequsetDeviceChangeWifiHandel:objc[@"ltid"]];
        }
    }
}

- (void)broadcast8266Handel
{
    NSString *ltidString = [LongTooth getId];
    NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"srv_name\":\"%@\"}",ltidString,REPORT_DEV_LTID];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.longtoothHandler sendInsWithRemoteLtid:ltidString BroadcastKey:DEV_LTID ServiceName:REPORT_DEV_LTID insData:data block:^(NSDictionary *returnStr,NSString *serviceName) {
        if ([serviceName isEqualToString:REPORT_DEV_LTID]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self RequsetDeviceChangeWifiHandel:returnStr[@"ltid"]];
            });
        }
    }];
}
- (void)RequsetDeviceChangeWifiHandel:(NSString *)ltid
{
    _dev_changeWifi ++;
    NSString *str = [NSString stringWithFormat:@"{\"ssid\":\"%@\",\"pwd\":\"%@\"}",self.wifiString,self.passwordString];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.longtoothHandler sendRequestWithRemoteLtid:ltid ServiceName:DEV_CHANGEWIFI insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
        NSLog(@"配网后设备response的数据 ====== %@",receiveStr);
        if ([serviceName isEqualToString:DEV_CHANGEWIFI]) {
            if ([receiveStr[@"result"] intValue] == 0) {
                
                if (@available(iOS 11.0, *)) {
                    NEHotspotConfiguration * hotspotConfig = [[NEHotspotConfiguration alloc] initWithSSID:self.wifiString passphrase:self.passwordString isWEP:NO];
                    [[NEHotspotConfigurationManager sharedManager] applyConfiguration:hotspotConfig completionHandler:^(NSError * _Nullable error) {
                        if([[[GetDeviceNetworkIP shareManager] ssid] isEqualToString:self.wifiString]) {
                            if(error) {
                                NSLog(@"错误原因：%@",error);
                            }else{
                                NSLog(@"加入网络成功");
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    self->_get_dev_info ++;
                                    UserMessageModel *usermodel = KGetUserMessage;
                                    
                                    NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\"}",usermodel.userID];
                                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                                    [self.longtoothHandler sendRequestWithRemoteLtid:ltid ServiceName:GET_DEVICEINFO insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                                        if ([serviceName isEqualToString:GET_DEVICEINFO]) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                
                                                self.secondImageView.image = [UIImage imageNamed:@"已完成"];
                                                self.secondLabel.textColor = [UIColor blackColor];
                                                
                                                self.deviceMessModel = [DeviceMessageModel mj_objectWithKeyValues:receiveStr];
                                                self.deviceMessModel.dev_mac = [self.deviceMessModel.dev_mac substringToIndex:12];
                                                self.deviceMessModel.longtooth_id = receiveStr[@"ltid"];
                                                NSLog(@"dev_mac === %@",self.deviceMessModel.dev_mac);
                                                self->_deviceDict = [[NSMutableDictionary alloc] initWithDictionary:receiveStr];
                                                [self->_deviceDict setValue:[self->_deviceDict[@"dev_mac"] substringToIndex:12] forKey:@"dev_mac"];
                                                NSLog(@"deviceMessDict === %@",self->_deviceDict);
                                                self->_selectNextNum = 0;
                                                self->_devicesNameArr = [NSMutableArray array];
                                                [self remindHandel];
                                                
                                            });
                                        }
                                    }];
                                });
                            }
                        }
                    }];
                }else {
                    // Fallback on earlier versions
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self->_get_dev_info ++;
                        UserMessageModel *usermodel = KGetUserMessage;
                        
                        NSString *str = [NSString stringWithFormat:@"{\"user_id\":\"%@\"}",usermodel.userID];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        [self.longtoothHandler sendRequestWithRemoteLtid:ltid ServiceName:GET_DEVICEINFO insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                            if ([serviceName isEqualToString:GET_DEVICEINFO]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    self.secondImageView.image = [UIImage imageNamed:@"已完成"];
                                    self.secondLabel.textColor = [UIColor blackColor];
                                    
                                    self.deviceMessModel = [DeviceMessageModel mj_objectWithKeyValues:receiveStr];
                                    self.deviceMessModel.dev_mac = [self.deviceMessModel.dev_mac substringToIndex:12];
                                    self.deviceMessModel.longtooth_id = receiveStr[@"ltid"];
                                    NSLog(@"dev_mac === %@",self.deviceMessModel.dev_mac);
                                    self->_deviceDict = [[NSMutableDictionary alloc] initWithDictionary:receiveStr];
                                    [self->_deviceDict setValue:[self->_deviceDict[@"dev_mac"] substringToIndex:12] forKey:@"dev_mac"];
                                    NSLog(@"deviceMessDict === %@",self->_deviceDict);
                                    self->_selectNextNum = 0;
                                    self->_devicesNameArr = [NSMutableArray array];
                                    [self remindHandel];
                                    
                                });
                            }
                        }];
                    });
                }
            }
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _researchLtidNum = 0;
    _researchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(researchBtnTimerAction) userInfo:nil repeats:YES];
    [self broadcast8266Handel];
}

- (void)remindHandel
{
    if ([self.deviceMessModel.no_of_ep intValue] == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DeclareAbnormalAlertView *alertView = [[DeclareAbnormalAlertView alloc]initWithImageIcon:[[DeviceTypeManager shareManager] getDeviceIcon:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]] deviceName:[[DeviceTypeManager shareManager] setDeviceName:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]] delegate:self buttonTitle:Localized(@"Next")];
            [alertView show];
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            DeclareAbnormalAlertView *alertView = [[DeclareAbnormalAlertView alloc]initWithImageIcon:[[DeviceTypeManager shareManager] getDeviceIcon:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]] deviceName:[[DeviceTypeManager shareManager] setDeviceName:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]] delegate:self buttonTitle:Localized(@"Next")];
            [alertView show];
        });
        
    }
    
}
#pragma mark -输入框弹窗的button点击时回调
- (void)declareAbnormalAlertView:(DeclareAbnormalAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.deviceMessModel.no_of_ep intValue] == 1) {
        [_devicesNameArr  addObject:alertView.textView.text];
        [self registerDeviceHandel];
    }else{
        _selectNextNum++;
        [_devicesNameArr  addObject:alertView.textView.text];
        if (_selectNextNum < [self.deviceMessModel.no_of_ep integerValue]) {
            NSString *deviceName =_devicesNameArr[0];
            NSString *buttonTitle;
            if ((_selectNextNum + 1) == [self.deviceMessModel.no_of_ep integerValue]) {
                buttonTitle = Localized(@"Next");
            }else{
                buttonTitle = Localized(@"Next");
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                DeclareAbnormalAlertView *alertView = [[DeclareAbnormalAlertView alloc]initWithImageIcon:[[DeviceTypeManager shareManager] getDeviceIcon:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]] deviceName:[NSString stringWithFormat:@"%@-%ld",deviceName,self->_selectNextNum] delegate:self buttonTitle:buttonTitle];
                [alertView show];
            });
        }else if (_selectNextNum == [self.deviceMessModel.no_of_ep integerValue]){
            [self registerDeviceHandel];
        }else{
        }
    }
}
- (void)researchBtnTimerAction
{
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    self->_researchLtidNum++;
    self.circleProgress.percent = (float)self->_researchLtidNum/100;
    self.circleProgress.centerLabel.text = [NSString stringWithFormat:@"%1.0f%@",self.circleProgress.percent*100,@"%"];
    if (self->_researchLtidNum == 100) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.circleProgress.centerLabel.font = [UIFont systemFontOfSize:17];
            self.circleProgress.centerLabel.text = Localized(@"tx_user_notice_search_device_failed");
            [self->_researchTimer invalidate];
            self->_researchTimer = nil;
            [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"tx_user_notice_search_device_failed") withDuration:1.0];
//            [self->_researchTimer invalidate];
//            self->_researchTimer = nil;
//            self->_researchLtidNum = 0;
        });
    }
    //    });
    
    
}

- (void)registerDeviceHandel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",self.deviceMessModel);
        HomeInformationModel *homeInfo = KGetHome;
        UserMessageModel *userModel = KGetUserMessage;
        RoomInformationModel *roomInfo = [[DBManager shareManager] selectFromRoomTableWithRoomId:@"1000000000000" andHomeId:homeInfo.homeID andUserId:userModel.userID];
        
        if ([self.deviceMessModel.no_of_ep intValue] == 1) {
            
            for (NSString *device_name in self->_devicesNameArr) {
               
                DeviceInformationModel *dev_info = [[DeviceInformationModel alloc] init];
                
                dev_info.dev_id = [[DeviceTypeManager shareManager] get16Deviceid];
                dev_info.ep = @"0";
                dev_info.hw_ver = self.deviceMessModel.hw_ver;
                dev_info.icon_order = @"0";
                dev_info.icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]];
                dev_info.longtooth_id = self.deviceMessModel.longtooth_id;
                dev_info.dev_mac = [self.deviceMessModel.dev_mac lowercaseString];
                dev_info.manufacturer = self.deviceMessModel.manufacturer;
                dev_info.model = self.deviceMessModel.model;
                dev_info.name = device_name;
                dev_info.room_id = roomInfo.room_id;
                dev_info.serial_type = self.deviceMessModel.serial_type;
                dev_info.sw_ver = self.deviceMessModel.sw_ver;
                dev_info.type = self.deviceMessModel.type;
                dev_info.home_id = homeInfo.homeID;
                dev_info.user_id = userModel.userID;
                [[DBManager shareManager] insertRoomDeviceTableWithFile:dev_info];
            }
            self.circleProgress.percent = 1;
            self.circleProgress.centerLabel.text = @"100%";
            self.thirdImageView.image = [UIImage imageNamed:@"已完成"];
            self.thirdLabel.textColor = [UIColor blackColor];
            self.forthImageView.image = [UIImage imageNamed:@"已完成"];
            self.forthLabel.textColor = [UIColor blackColor];
            self->_researchLtidNum = 100;
            self.circleProgress.percent = 1;
            self.circleProgress.centerLabel.text = @"100%";
            self.thirdImageView.image = [UIImage imageNamed:@"已完成"];
            self.thirdLabel.textColor = [UIColor blackColor];
            self.forthImageView.image = [UIImage imageNamed:@"已完成"];
            self.forthLabel.textColor = [UIColor blackColor];
            self->_researchLtidNum = 100;
            MYHomeViewController *myControl = nil;
            for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                UIViewController *cv = self.navigationController.viewControllers[i];
                if ([cv isKindOfClass:[MYHomeViewController class]]) {
                    myControl = (MYHomeViewController *)cv;
                    break;
                }
            }
            [self.navigationController popToViewController:myControl animated:YES];
        }else{

            for (int i = 0; i < self->_devicesNameArr.count; i++) {
                NSString *device_name = self->_devicesNameArr[i];
                DeviceInformationModel *dev_info = [[DeviceInformationModel alloc] init];
                
                dev_info.dev_id = [[DeviceTypeManager shareManager] get16Deviceid];
                dev_info.ep = [NSString stringWithFormat:@"%d",i];
                dev_info.hw_ver = self.deviceMessModel.hw_ver;
                dev_info.icon_order = @"0";
                dev_info.icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]];
                dev_info.longtooth_id = self.deviceMessModel.longtooth_id;
                dev_info.dev_mac = [self.deviceMessModel.dev_mac lowercaseString];
                dev_info.manufacturer = self.deviceMessModel.manufacturer;
                dev_info.model = self.deviceMessModel.model;
                dev_info.name = device_name;
                dev_info.room_id = roomInfo.room_id;
                dev_info.serial_type = self.deviceMessModel.serial_type;
                dev_info.sw_ver = self.deviceMessModel.sw_ver;
                dev_info.type = self.deviceMessModel.type;
                dev_info.home_id = homeInfo.homeID;
                dev_info.user_id = userModel.userID;
                [[DBManager shareManager] insertRoomDeviceTableWithFile:dev_info];

            }
            self.circleProgress.percent = 1;
            self.circleProgress.centerLabel.text = @"100%";
            self.thirdImageView.image = [UIImage imageNamed:@"已完成"];
            self.thirdLabel.textColor = [UIColor blackColor];
            self.forthImageView.image = [UIImage imageNamed:@"已完成"];
            self.forthLabel.textColor = [UIColor blackColor];
            self->_researchLtidNum = 100;
            MYHomeViewController *myControl = nil;
            for (int i = 0; i < self.navigationController.viewControllers.count; i++) {
                UIViewController *cv = self.navigationController.viewControllers[i];
                if ([cv isKindOfClass:[MYHomeViewController class]]) {
                    myControl = (MYHomeViewController *)cv;
                    break;
                }
            }
            [self.navigationController popToViewController:myControl animated:YES];
        }
    });
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)createUI
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont systemFontOfSize:24];
    self.titleLabel.text = @"Looking for your Smart Device";
    [self.view addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .topSpaceToView(self.view, 20)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(40);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.circleProgress = [[CircleProgressView alloc] init];
    self.circleProgress.backgroundColor = [UIColor clearColor];
    self.circleProgress.percent = 0;
    [self.view addSubview:self.circleProgress];
    self.circleProgress.sd_layout
    .topSpaceToView(self.titleLabel, 20)
    .centerXEqualToView(self.view)
    .widthIs(160)
    .heightIs(160);
    self.circleProgress.centerLabel.text = @"1%";
    
    self.detailTitleLabel = [[UILabel alloc] init];
    self.detailTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTitleLabel.textColor = [UIColor blackColor];
    self.detailTitleLabel.numberOfLines = 0;
    self.detailTitleLabel.font = [UIFont systemFontOfSize:21];
    self.detailTitleLabel.text = @"Sending configuration to device";
    [self.view addSubview:self.detailTitleLabel];
    self.detailTitleLabel.sd_layout
    .topSpaceToView(self.circleProgress, 20)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(30);
    self.detailTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.firstLabel = [[UILabel alloc] init];
    self.firstLabel.textColor = [UIColor blackColor];
    self.firstLabel.font = [UIFont systemFontOfSize:17];
    self.firstLabel.text = @"Sending configuration to device";
    [self.view addSubview:self.firstLabel];
    
    self.firstLabel.adjustsFontSizeToFitWidth = YES;
    
    self.fisrtImageView = [[UIImageView alloc] init];
    self.fisrtImageView.image = [UIImage imageNamed:@"已完成"];
    [self.view addSubview:self.fisrtImageView];
    
    if (KScreenHeight == 568) {
        self.firstLabel.sd_layout
        .topSpaceToView(self.detailTitleLabel, 50)
        .rightSpaceToView(self.view, (KScreenWidth-[self widthLabelWithModel:self.firstLabel.text withFont:17]-20-10)/2)
        .widthIs([self widthLabelWithModel:self.firstLabel.text withFont:17])
        .heightIs(20);
        self.fisrtImageView.sd_layout
        .topSpaceToView(self.detailTitleLabel, 50)
        .rightSpaceToView(self.firstLabel, 10)
        .widthIs(20)
        .heightIs(20);
    }else if (KScreenHeight > 568){
        if (KScreenHeight == 667) {
            self.firstLabel.sd_layout
            .topSpaceToView(self.detailTitleLabel, 60)
            .rightSpaceToView(self.view, (KScreenWidth-[self widthLabelWithModel:self.firstLabel.text withFont:17]-20-10)/2)
            .widthIs([self widthLabelWithModel:self.firstLabel.text withFont:17])
            .heightIs(20);
            self.fisrtImageView.sd_layout
            .topSpaceToView(self.detailTitleLabel, 60)
            .rightSpaceToView(self.firstLabel, 10)
            .widthIs(20)
            .heightIs(20);
        }else{
            self.firstLabel.sd_layout
            .topSpaceToView(self.detailTitleLabel, 80)
            .rightSpaceToView(self.view, (KScreenWidth-[self widthLabelWithModel:self.firstLabel.text withFont:17]-20-10)/2)
            .widthIs([self widthLabelWithModel:self.firstLabel.text withFont:17])
            .heightIs(20);
            self.fisrtImageView.sd_layout
            .topSpaceToView(self.detailTitleLabel, 80)
            .rightSpaceToView(self.firstLabel, 10)
            .widthIs(20)
            .heightIs(20);
        }
        
    }else{
        self.firstLabel.sd_layout
        .topSpaceToView(self.detailTitleLabel, 30)
        .rightSpaceToView(self.view, (KScreenWidth-[self widthLabelWithModel:self.firstLabel.text withFont:17]-20-10)/2)
        .widthIs([self widthLabelWithModel:self.firstLabel.text withFont:17])
        .heightIs(20);
        self.fisrtImageView.sd_layout
        .topSpaceToView(self.detailTitleLabel, 30)
        .rightSpaceToView(self.firstLabel, 10)
        .widthIs(20)
        .heightIs(20);
    }
    self.secondImageView = [[UIImageView alloc] init];
    self.secondImageView.image = [UIImage imageNamed:@"未完成"];
    [self.view addSubview:self.secondImageView];
    self.secondImageView.sd_layout
    .topSpaceToView(self.fisrtImageView, 10)
    .leftEqualToView(self.fisrtImageView)
    .widthIs(20)
    .heightIs(20);
    
    self.secondLabel = [[UILabel alloc] init];
    self.secondLabel.textColor = [UIColor colorWithHexString:@"cdcdcd"];
    self.secondLabel.font = [UIFont systemFontOfSize:17];
    self.secondLabel.text = @"Find device";
    [self.view addSubview:self.secondLabel];
    self.secondLabel.sd_layout
    .topSpaceToView(self.firstLabel, 10)
    .leftSpaceToView(self.secondImageView, 10)
    .widthIs([self widthLabelWithModel:self.secondLabel.text withFont:17])
    .heightIs(20);
    self.secondLabel.adjustsFontSizeToFitWidth = YES;
    
    self.thirdImageView = [[UIImageView alloc] init];
    self.thirdImageView.image = [UIImage imageNamed:@"未完成"];
    [self.view addSubview:self.thirdImageView];
    self.thirdImageView.sd_layout
    .topSpaceToView(self.secondImageView, 10)
    .leftEqualToView(self.fisrtImageView)
    .widthIs(20)
    .heightIs(20);
    self.thirdLabel = [[UILabel alloc] init];
    self.thirdLabel.textColor = [UIColor colorWithHexString:@"cdcdcd"];
    self.thirdLabel.font = [UIFont systemFontOfSize:17];
    self.thirdLabel.text = @"Register device to the cloud";
    [self.view addSubview:self.thirdLabel];
    self.thirdLabel.sd_layout
    .topSpaceToView(self.secondLabel, 10)
    .leftSpaceToView(self.thirdImageView, 10)
    .widthIs([self widthLabelWithModel:self.thirdLabel.text withFont:17])
    .heightIs(20);
    self.thirdLabel.adjustsFontSizeToFitWidth = YES;
    
    self.forthImageView = [[UIImageView alloc] init];
    self.forthImageView.image = [UIImage imageNamed:@"未完成"];
    [self.view addSubview:self.forthImageView];
    self.forthImageView.sd_layout
    .topSpaceToView(self.thirdImageView, 10)
    .leftEqualToView(self.fisrtImageView)
    .widthIs(20)
    .heightIs(20);
    self.forthLabel = [[UILabel alloc] init];
    self.forthLabel.textColor = [UIColor colorWithHexString:@"cdcdcd"];
    self.forthLabel.font = [UIFont systemFontOfSize:17];
    self.forthLabel.text = @"Initialize device";
    [self.view addSubview:self.forthLabel];
    self.forthLabel.sd_layout
    .topSpaceToView(self.thirdLabel, 10)
    .leftSpaceToView(self.forthImageView, 10)
    .widthIs([self widthLabelWithModel:self.forthLabel.text withFont:17])
    .heightIs(20);
    self.forthLabel.adjustsFontSizeToFitWidth = YES;
}

#pragma mark-字体宽度自适应
- (CGFloat)widthLabelWithModel:(NSString *)titleString withFont:(NSInteger)font
{
    CGSize size = CGSizeMake(self.view.bounds.size.width, MAXFLOAT);
    CGRect rect = [titleString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width;
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
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[SetUpViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
        }
    }
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
