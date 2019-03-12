//
//  SearchDevicesController.m
//  iThing
//
//  Created by Frank on 2018/12/24.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "SearchDevicesController.h"
#import "LongToothHandler.h"
#import "MyFileHeader.h"
#import "DeviceSceneCell.h"
#import "DeclareAbnormalAlertView.h"
@interface SearchDevicesController ()<UITableViewDelegate,UITableViewDataSource,DeclareAbnormalAlertViewDelegate>
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *deviceImageView;
@property (nonatomic, strong)UIButton *reSearchButton;
@property (nonatomic, strong)UIButton *finishButton;
@property (nonatomic, strong)LongToothHandler *longtoothHandler;
@property (nonatomic, strong)UITableView *deviceListTbView;
@property (nonatomic, strong)NSMutableArray *deviceListArray;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong)DeviceMessageModel *deviceMessModel;
@property (nonatomic, strong)DeviceMessageModel *oldDeviceModel;
//@property (strong, nonatomic) UIScrollView *myScroll;
//@property (strong, nonatomic) UIPageControl *pageControl;
@end

@implementation SearchDevicesController
{
    NSInteger _researchLtidNum;
    NSTimer * _researchTimer;
    NSMutableDictionary *_deviceDict;
    NSMutableArray *_devicesNameArr;
    NSInteger _selectNextNum;
    
    NSInteger _epsGet_dev_info;
    NSInteger _get_dev_info;
    NSInteger _dev_changeWifi;
}
#pragma mark - 懒加载
-(NSMutableArray *)deviceListArray
{
    if (_deviceListArray == nil) {
        _deviceListArray = [NSMutableArray array];
    }
    return _deviceListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.longtoothHandler = [LongToothHandler sharedInstance];
    [[LongToothHandler sharedInstance] configHandleSendDelegate:self];
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _researchLtidNum = 0;
    _researchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(researchBtnTimerAction) userInfo:nil repeats:YES];
    NSString *ltidString = [LongTooth getId];
    NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"srv_name\":\"%@\"}",ltidString,SEARCH_DEVICE_INFO];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.longtoothHandler sendInsWithRemoteLtid:ltidString BroadcastKey:@"search_dev" ServiceName:SEARCH_DEVICE insData:data block:^(NSDictionary *returnStr,NSString *serviceName) {
        if([serviceName isEqualToString:SEARCH_DEVICE_INFO]){
            NSLog(@"%@",returnStr);
//            self.oldDeviceModel = [DeviceMessageModel mj_objectWithKeyValues:returnStr];
//            self.oldDeviceModel.device_mac = [self.deviceMessModel.device_mac substringToIndex:12];
//            [self deviceSetWifiHandel];
        }
    }];
}
- (void)researchBtnTimerAction
{
    self->_researchLtidNum++;
    if (self->_researchLtidNum == 120) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_researchLtidNum = 0;
            [self.activityIndicator stopAnimating];
            [self->_researchTimer invalidate];
            self->_researchTimer = nil;
            if (self.deviceListArray.count == 0) {
                [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"dev_broadcast_no_search") withDuration:1.0];
            }
           
        });
    }
}
#pragma mark - handleEvent代理
-(void)handleSendNotification:(id)objc andServiceName:(NSString *)serviceName
{
//    if ([serviceName isEqualToString:SEARCH_DEVICE_INFO]) {
    if ([serviceName isEqualToString:SEARCH_DEVICE_INFO]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dict = (NSDictionary *)objc;
            if (self.deviceListArray.count == 0) {
                DeviceMessageModel *model = [DeviceMessageModel mj_objectWithKeyValues:dict];
//                if ((model.home_id.length == 0 || [model.home_id isEqualToString:@"0"]) && model.user_account.length == 0) {
                    model.longtooth_id = dict[@"ltid"];
                    model.dev_mac = [dict[@"dev_mac"] substringToIndex:12];
                    model.device_type_name = [[DeviceTypeManager shareManager] setDeviceName:[model.type intValue] andSerialType:[model.serial_type intValue]];
                    [self.deviceListArray addObject:model];
//                }
                
            }else{
                DeviceMessageModel *newModel = [DeviceMessageModel mj_objectWithKeyValues:dict];
//                if ((newModel.home_id.length == 0 || [newModel.home_id isEqualToString:@"0"]) && newModel.user_account.length == 0) {
                    newModel.device_type_name = [[DeviceTypeManager shareManager] setDeviceName:[newModel.type intValue] andSerialType:[newModel.serial_type intValue]];
                    newModel.dev_mac = [dict[@"dev_mac"] substringToIndex:12];
                    newModel.longtooth_id = dict[@"ltid"];
                    BOOL isHave = NO;
                    for (DeviceMessageModel *model in self.deviceListArray) {
                        if ([model.longtooth_id isEqualToString:newModel.longtooth_id] && [model.dev_mac isEqualToString:newModel.dev_mac]) {
                            isHave = YES;
                        }
                    }
                    if (!isHave) {
                        [self.deviceListArray addObject:newModel];
                    }
//                }
                
                
            }
            [self.deviceListTbView reloadData];
        });
    }
}
#pragma mark - 创建tableview
-(UITableView *)deviceListTbView
{
    if (_deviceListTbView == nil) {
        
        _deviceListTbView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceListTbView.backgroundColor = [UIColor clearColor];
        _deviceListTbView.tableFooterView = [UIView new];
        _deviceListTbView.delegate = self;
        _deviceListTbView.dataSource = self;
        [self.view addSubview:_deviceListTbView];
        _deviceListTbView.sd_layout
        .topSpaceToView(self.topView, 0)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, 50+SafeAreaBottomHeight);
        
        if ([_deviceListTbView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_deviceListTbView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_deviceListTbView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_deviceListTbView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _deviceListTbView;
}

- (void)createUI
{
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor colorWithHexString:@"686868"];
    [self.view addSubview:self.topView];
    self.topView.sd_layout
    .topEqualToView(self.view)
    .leftEqualToView(self.view)
    .widthIs(KScreenWidth)
    .heightIs(180+SafeAreaTopHeight);
    
    self.deviceImageView = [[UIImageView alloc] init];
    UIImage *bgImage = [UIImage imageNamed:@"device_search"];
    self.deviceImageView.image = bgImage;
    [self.topView addSubview:self.deviceImageView];
    self.deviceImageView.sd_layout
    .topSpaceToView(self.topView, 20+SafeAreaTopHeight)
    .leftSpaceToView(self.topView, 20)
    .widthIs(50)
    .heightIs(50);
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
    [self.topView addSubview:self.activityIndicator];
    //设置小菊花的frame
    self.activityIndicator.frame= CGRectMake(25, 25+SafeAreaTopHeight, 30, 30);
    //设置小菊花颜色
    self.activityIndicator.color = [UIColor whiteColor];
    //设置背景颜色
    self.activityIndicator.backgroundColor = [UIColor clearColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    self.activityIndicator.hidesWhenStopped = NO;
    [self.activityIndicator startAnimating];
//    [self.activityIndicator stopAnimating];
    
    
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:20];
    self.titleLabel.text = Localized(@"dev_broadcast_list_notice");
    [self.topView addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .topSpaceToView(self.topView, 20+SafeAreaTopHeight)
    .leftSpaceToView(self.deviceImageView, 10)
    .rightSpaceToView(self.topView, 20)
    .heightIs(40);
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    
   
    
    self.reSearchButton = [[UIButton alloc] init];
    [self.topView addSubview:self.reSearchButton];
    self.reSearchButton.backgroundColor = [UIColor colorWithHexString:@"4382E4"];
    [self.reSearchButton setTitle:Localized(@"dev_broadcast_retry_search") forState:UIControlStateNormal];
    [self.reSearchButton setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [self.reSearchButton addTarget:self action:@selector(reSearchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.reSearchButton.sd_layout
    .topSpaceToView(self.titleLabel, 50)
    .leftSpaceToView(self.topView, 20)
    .rightSpaceToView(self.topView, 20)
    .heightIs(50);
//    self.reSearchButton.layer.borderWidth = 1.5;
//    self.reSearchButton.layer.borderColor = [UIColor colorWithHexString:@"A3A3A3"].CGColor;
    self.reSearchButton.layer.cornerRadius = 20;
    self.reSearchButton.layer.masksToBounds = YES;
    
    
    
    
    self.finishButton = [[UIButton alloc] init];
    [self.view addSubview:self.finishButton];
    self.finishButton.backgroundColor = [UIColor colorWithHexString:@"4382E4"];
    self.finishButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.finishButton setTitle:Localized(@"Finish") forState:UIControlStateNormal];
    [self.finishButton setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.finishButton.sd_layout
    .bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(50+SafeAreaBottomHeight);
    [self deviceListTbView];
    dispatch_async(dispatch_get_main_queue(), ^{
       [self.deviceListTbView reloadData];
    });
}

- (void)reSearchButtonAction
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator startAnimating];
    [self->_researchTimer invalidate];
    self->_researchTimer = nil;
    _researchLtidNum = 0;
    _researchTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(researchBtnTimerAction) userInfo:nil repeats:YES];
    NSString *ltidString = [LongTooth getId];
    NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"srv_name\":\"%@\"}",ltidString,SEARCH_DEVICE_INFO];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [self.longtoothHandler sendInsWithRemoteLtid:ltidString BroadcastKey:@"search_dev" ServiceName:SEARCH_DEVICE insData:data block:^(NSDictionary *returnStr,NSString *serviceName) {
        if([serviceName isEqualToString:SEARCH_DEVICE_INFO]){
            NSLog(@"%@",returnStr);
            //            self.oldDeviceModel = [DeviceMessageModel mj_objectWithKeyValues:returnStr];
            //            self.oldDeviceModel.device_mac = [self.deviceMessModel.device_mac substringToIndex:12];
            //            [self deviceSetWifiHandel];
        }
    }];
}
- (void)finishButtonAction
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:Localized(@"dev_broadcast_pop_notice_quit") message: nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:Localized(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertCtrl  addAction:[UIAlertAction actionWithTitle:Localized(@"dev_broadcast_pop_quit") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->_researchLtidNum = 0;
            [self.activityIndicator stopAnimating];
            [self->_researchTimer invalidate];
            self->_researchTimer = nil;
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    });
}

#pragma mark - tableview代理
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"searchdeviceCellId";
    DeviceSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        cell = [[DeviceSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    DeviceMessageModel *devModel = self.deviceListArray[indexPath.row];
    NSString *icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[devModel.type intValue] andSerialType:[devModel.serial_type intValue]];
    cell.iconImageView.image = [UIImage imageNamed:icon_path];
    cell.sceneName.textColor = [UIColor colorWithHexString:@"4382E4"];
    cell.sceneName.text = devModel.device_type_name;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UserMessageModel *userModel = KGetUserMessage;
//    HomeInformationModel *homeInfo = KGetHome;
    self.oldDeviceModel = self.deviceListArray[indexPath.row];
//    NSString *str = [NSString stringWithFormat:@"{\"user_account\":\"%@\",\"home_id\":%d}",userModel.userName,[homeInfo.homeID intValue]];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [self.longtoothHandler sendRequestWithRemoteLtid:self.oldDeviceModel.longtooth_id ServiceName:@"dev_info" insData:data block:^(NSDictionary *receiveStr, NSString *serviceName) {
//        if([serviceName isEqualToString:@"dev_info"]){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"dev_info数据 === %@", receiveStr);
                self.deviceMessModel = self.deviceListArray[indexPath.row];
//                self.deviceMessModel.dev_mac = [receiveStr[@"device_mac"] substringToIndex:12];
//                self->_deviceDict = [[NSMutableDictionary alloc] initWithDictionary:receiveStr];
//                [self->_deviceDict setValue:[self->_deviceDict[@"device_mac"] substringToIndex:12] forKey:@"device_mac"];
                if ([self.deviceMessModel.longtooth_id isEqualToString:self.oldDeviceModel.longtooth_id]
                    && [self.deviceMessModel.dev_mac isEqualToString:self.oldDeviceModel.dev_mac]) {
                    self->_selectNextNum = 0;
                    self->_devicesNameArr = [NSMutableArray array];
                    [self remindHandel];
                }
//            });
//
//        }
//    }];
}
- (void)remindHandel
{
    if ([self.deviceMessModel.no_of_ep intValue] == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            DeclareAbnormalAlertView *alertView = [[DeclareAbnormalAlertView alloc]initWithImageIcon:[[DeviceTypeManager shareManager] getDeviceIcon:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]] deviceName:self.oldDeviceModel.device_type_name delegate:self buttonTitle:Localized(@"Next")];
            [alertView show];
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            DeclareAbnormalAlertView *alertView = [[DeclareAbnormalAlertView alloc]initWithImageIcon:[[DeviceTypeManager shareManager] getDeviceIcon:[self.deviceMessModel.type intValue] andSerialType:[self.deviceMessModel.serial_type intValue]] deviceName:self.oldDeviceModel.device_type_name delegate:self buttonTitle:Localized(@"Next")];
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

- (void)registerDeviceHandel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",self.deviceMessModel);
        HomeInformationModel *homeInfo = KGetHome;
        UserMessageModel *userModel = KGetUserMessage;
        RoomInformationModel *roomInfo = KGetRoom;
        if ([roomInfo.room_id intValue] == 0) {
            roomInfo.room_id = @"1000000000000";
        }
        
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
            [SVProgressHUD doAnythingSuccessWithHUDMessage:@"设备注册成功"];
            [self.deviceListArray removeObject:self.oldDeviceModel];
            [self.deviceListTbView reloadData];
           
            
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
            [SVProgressHUD doAnythingSuccessWithHUDMessage:@"设备注册成功"];
            [self.deviceListArray removeObject:self.oldDeviceModel];
            [self.deviceListTbView reloadData];
            
        }
    });
}

- (NSString *)xy_noDataViewMessage
{
    return Localized(@"tx_user_notice_search_networked_device");
}
- (UIColor  *)xy_noDataViewMessageColor
{
    return [UIColor colorWithHexString:@"6E6D72"];
}
- (NSNumber *)xy_noDataViewCenterYOffset
{
    return [[NSNumber alloc] initWithInt:-40];
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
