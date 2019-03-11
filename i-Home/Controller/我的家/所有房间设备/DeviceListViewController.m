//
//  DeviceListViewController.m
//  i-Home
//
//  Created by Frank on 2019/2/28.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "DeviceListViewController.h"
#import "Masonry.h"
#import "DeviceListCell.h"
@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource,HandleEventDelegate,HandleSendDelegate>
@property (nonatomic, strong) UITableView *deviceListTableView;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong) LongToothHandler *longtoothHandler;
@property (nonatomic, strong) NSMutableArray *totalLastTime;
@property (nonatomic, strong) NSTimer *timer;


@property (nonatomic, strong)SwitchView *switchView;//开关
@property (nonatomic, strong)SetBrightnessAndColorView *brightColorview;//灯泡
@property (nonatomic, strong)SetRGBDeviceView *rgbDeviceView;//rgb灯泡
@property (nonatomic, strong)SocketView *sView;//插座
@property (nonatomic, strong)CurtainView *curtainView;//窗帘
@property (nonatomic, strong)AirConditioningView *airView;//空调
@property (nonatomic, strong)DimmerView *dimmerView;//空调
@end

@implementation DeviceListViewController
- (NSMutableArray *)totalLastTime
{
    if (_totalLastTime == nil) {
        _totalLastTime = [NSMutableArray array];
    }
    return _totalLastTime;
}
- (NSMutableArray *)deviceListArray
{
    if (_deviceListArray == nil) {
        _deviceListArray = [NSMutableArray array];
        
    }
    return _deviceListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.longtoothHandler = [LongToothHandler sharedInstance];
    [[LongToothHandler sharedInstance] configHandleEventDelegate:self];
    [[LongToothHandler sharedInstance] configHandleSendDelegate:self];
    [self setUI];
    [self startTimer];
    NSLog(@"name === %@",self.roomInfo.name);

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.timer == nil) {
        [self startTimer];
    }
    NSLog(@"roomInfo === %@",self.roomInfo.name);
    HomeInformationModel *homeInfo = KGetHome;
    UserMessageModel *userModel = KGetUserMessage;
    self.deviceListArray = [[DBManager shareManager] selectFromRoomDeviceTableWithRoomId:self.roomInfo.room_id andHomeId:homeInfo.homeID andUserId:userModel.userID];
    [self.deviceListTableView reloadData];
    for (DeviceInformationModel *info in self.deviceListArray) {
        [self getDeviceStatus:info andandWithDeviceNum:1 andSelectNum:1];
    }
}
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
    //如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}
- (void)refreshLessTime
{
    [self.totalLastTime enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSUInteger time;
        
        time = [[[self.totalLastTime objectAtIndex:idx] objectForKey:@"lastTime"]integerValue];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[[self.totalLastTime objectAtIndex:idx] objectForKey:@"indexPath"] integerValue] inSection:0];
        DeviceListCell *cell = (DeviceListCell *)[self.deviceListTableView cellForRowAtIndexPath:indexPath];
        --time;
        NSDictionary *dic = @{@"indexPath": [NSString stringWithFormat:@"%ld",indexPath.row],@"lastTime": [NSString stringWithFormat:@"%ld",time]};
        [self.totalLastTime replaceObjectAtIndex:idx withObject:dic];
        if(time <= 0)
        {
            if (cell == nil) {
                [self.totalLastTime removeObjectAtIndex:idx];
            }else{
                [[DBManager shareManager] updateDeviceTableWithOffline:1 byLongtooId:cell.deviceInfo.longtooth_id byEp:[cell.deviceInfo.ep intValue] byHomeId:cell.deviceInfo.home_id byUserId:cell.deviceInfo.user_id withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                [UIView performWithoutAnimation:^{
                    [self.deviceListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[[[self.totalLastTime objectAtIndex:idx] objectForKey:@"indexPath"] integerValue] inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                    
                }];
                [self.totalLastTime removeObjectAtIndex:idx];
                *stop = YES;
            }
        }
    }];
}


- (void)getDeviceStatus:(DeviceInformationModel *)devModel andandWithDeviceNum:(NSInteger)devNum andSelectNum:(NSInteger)selectNum
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = [NSString stringWithFormat:@"{\"device_id\":%d,\"longtoo_id\":\"%@\",\"ep\":%d,\"keepalive\":%d}",[devModel.dev_id intValue],devModel.longtooth_id,[devModel.ep intValue],600];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        for (int i = 0; i < self.deviceListArray.count; i++) {
            DeviceInformationModel *devInfo = self.deviceListArray[i];
            if ([devInfo.longtooth_id isEqualToString:devModel.longtooth_id] && [devInfo.ep isEqualToString:devModel.ep]) {
                NSDictionary *dic = @{@"indexPath":[NSString stringWithFormat:@"%d",i],@"lastTime": @"3"};
                [self.totalLastTime addObject:dic];
            }
        }
        [self.longtoothHandler sendRequestWithRemoteLtid:devModel.longtooth_id ServiceName:DEV_STATUS insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
            if ([serviceName isEqualToString:DEV_STATUS]) {
                if ([receiveStr[@"result"] longValue] == 0) {
                    DeviceStatusModel *devStatusModel = [DeviceStatusModel mj_objectWithKeyValues:receiveStr];
                    NSInteger indexPath_row = 0;
                    for (int i = 0; i < self.deviceListArray.count; i++) {
                        DeviceInformationModel *info = self.deviceListArray[i];
                        if ([info.longtooth_id isEqualToString:devStatusModel.ltid] && [info.ep intValue]==devStatusModel.ep) {
                            indexPath_row = i;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.totalLastTime enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                    NSInteger index = [[[self.totalLastTime objectAtIndex:idx] objectForKey:@"indexPath"] integerValue];
                                    if (index == indexPath_row) {
                                        [self.totalLastTime removeObjectAtIndex:idx];
                                        *stop = YES;
                                    }
                                }];
                                [UIView performWithoutAnimation:^{
                                    [self.deviceListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath_row inSection:0], nil] withRowAnimation:UITableViewRowAnimationNone];
                                    //                                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath_row inSection:0], nil]];
                                }];
                                
                                //                            NSArray *newArr = [devStatusModel.sw_ver componentsSeparatedByString:@"."];
                                //                            NSString *newVString = [newArr componentsJoinedByString:@""];
                                //                            NSArray *localArr = [info.sw_ver componentsSeparatedByString:@"."];
                                //                            NSString *localVString = [localArr componentsJoinedByString:@""];
                                //                            if ([newVString integerValue] > [localVString integerValue]) {
                                //                                info.latest_version = devStatusModel.sw_version;
                                //                                [self sendHttpUpdateVersion:info];
                                //                            }
                            });
                        }
                    }
                }
                
            }
        }];
    });
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //取消定时器
    [self.timer invalidate];
    self.timer = nil;
}
- (void)setUI{
    [self createTableView];
    [self.deviceListTableView reloadData];
}
- (void)createTableView
{
    [self deviceListTableView];
}
#pragma mark - 创建tableview
-(UITableView *)deviceListTableView
{
    if (_deviceListTableView == nil) {
        _deviceListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _deviceListTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _deviceListTableView.delegate = self;
        _deviceListTableView.dataSource = self;
        _deviceListTableView.tableFooterView = [UIView new];
        _deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _listTableView.sectionFooterHeight = 20;
        //        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CurrentParkCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        [self.view addSubview:_deviceListTableView];
        [_deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.right.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
        
    }
    return _deviceListTableView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.deviceListTableView) {
//        NSLog(@"%lf",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y>=60) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeOffset" object:@{@"changeOffset":@"1"}];
            return;
        }else if (scrollView.contentOffset.y<=-60){
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeOffset" object:@{@"changeOffset":@"-1"}];
            return;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceListArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"DeviceListCellID";
    DeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[DeviceListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    DeviceInformationModel *devInfo = self.deviceListArray[indexPath.row];
    if (devInfo.icon_path.length == 0) {
        devInfo.icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[devInfo.type intValue] andSerialType:[devInfo.serial_type intValue]];
    }
    cell.iconImageView.image = [UIImage imageNamed:devInfo.icon_path];
    cell.deviceNameLabel.text = devInfo.name;
    DeviceStatusModel *devStatus = [[DBManager shareManager] selectFromDeviceTableWithLongtooId:devInfo.longtooth_id andEp:[devInfo.ep intValue] andHomeId:devInfo.home_id andUserId:devInfo.user_id withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
    if (devStatus.ltid.length == 0) {
        devStatus.ltid = devInfo.longtooth_id;
        devStatus.dev_id = devInfo.dev_id;
        devStatus.room_id = devInfo.room_id;
        devStatus.home_id = devInfo.home_id;
        devStatus.user_id = devInfo.user_id;
        devStatus.type = [devInfo.type intValue];
        devStatus.serial_type = [devInfo.serial_type intValue];
        devStatus.offline = 1;
    }
    cell.devStatus = devStatus;
    cell.deviceInfo = devInfo;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configWithInfo:devInfo andStatusModel:devStatus];
    typeof(cell) weakCell = cell;
    [weakCell setDeviceBlock:^(DeviceInformationModel * _Nonnull devInfo, DeviceStatusModel * _Nonnull devSta) {
        int onoff = 0;
        if (devSta.onoff == 1) {
            onoff = 0;
        }else{
            onoff = 1;
        }
        if ([devInfo.type intValue] == DEV_TYPE_SWITCH) {
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d}",devSta.ltid,[devSta.dev_id intValue],devSta.ep,onoff];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:devInfo.longtooth_id ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.devStatus.onoff = [receiveStr[@"onoff"] intValue];
                            cell.devStatus.offline = 0;
                            [[DBManager shareManager] insertDeviceTableWithFile:cell.devStatus withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                        });
                    }
                }
            }];
        }else if ([devInfo.type intValue] == DEV_TYPE_LIGHTBULB){
            if (onoff == 1) {
                if (devSta.bri == 0) {
                    cell.devStatus.bri = 36;
                }
            }
            if ([cell.deviceInfo.serial_type intValue] == 4) {
                NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d,\"bri\":%d,\"sat\":%d,\"hue\":%d}",cell.devStatus.ltid,[cell.devStatus.dev_id intValue],cell.devStatus.ep,onoff,cell.devStatus.bri,cell.devStatus.sat,cell.devStatus.hue];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                [self.longtoothHandler sendRequestWithRemoteLtid:cell.devStatus.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                    if ([serviceName isEqualToString:DEV_CONTROL]) {
                        if ([receiveStr[@"result"] intValue] == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                cell.devStatus.offline = 0;
                                cell.devStatus.onoff = [receiveStr[@"onoff"] intValue];
                                [[DBManager shareManager] insertDeviceTableWithFile:cell.devStatus withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                                [UIView performWithoutAnimation:^{
                                    [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                }];
                            });
                        }
                    }
                }];
            }else if ([cell.deviceInfo.serial_type intValue] == 1){
                NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d,\"bri\":%d}",cell.devStatus.ltid,[cell.devStatus.dev_id intValue],cell.devStatus.ep,onoff,cell.devStatus.bri];
                //                                NSLog(@"str======== %@",str);
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                [self.longtoothHandler sendRequestWithRemoteLtid:cell.devStatus.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                    if ([serviceName isEqualToString:DEV_CONTROL]) {
                        if ([receiveStr[@"result"] intValue] == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                cell.devStatus.offline = 0;
                                cell.devStatus.onoff = [receiveStr[@"onoff"] intValue];
                                [[DBManager shareManager] insertDeviceTableWithFile:cell.devStatus withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                                [UIView performWithoutAnimation:^{
                                    [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                }];
                            });
                        }
                    }
                }];
            }else{
                NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d,\"bri\":%d,\"sat\":%d,\"hue\":%d}",cell.devStatus.ltid,[cell.devStatus.dev_id intValue],cell.devStatus.ep,onoff,cell.devStatus.bri,cell.devStatus.sat,cell.devStatus.hue];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                [self.longtoothHandler sendRequestWithRemoteLtid:cell.devStatus.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                    if ([serviceName isEqualToString:DEV_CONTROL]) {
                        if ([receiveStr[@"result"] intValue] == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                cell.devStatus.offline = 0;
                                cell.devStatus.onoff = [receiveStr[@"onoff"] intValue];
                                [[DBManager shareManager] insertDeviceTableWithFile:cell.devStatus withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                                [UIView performWithoutAnimation:^{
                                    [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                }];
                            });
                        }
                    }
                }];
            }
        }else if ([devInfo.type intValue] == DEV_TYPE_SOCKET) {
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d}",devSta.ltid,[devSta.dev_id intValue],devSta.ep,onoff];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:devInfo.longtooth_id ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.devStatus.offline = 0;
                            cell.devStatus.onoff = [receiveStr[@"onoff"] intValue];
                            [[DBManager shareManager] insertDeviceTableWithFile:cell.devStatus withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                        });
                    }
                }
            }];
        }else if ([cell.deviceInfo.type intValue] == DEV_TYPE_AIR_COND){
            int mode = 0;
            if (devStatus.mode == 0) {
                mode = 1;
            }else{
                mode = 0;
            }
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"set_temp\":%d,\"speed\":%d,\"mode\":%d,\"currentTemp\":%d}",cell.devStatus.ltid,[cell.devStatus.dev_id intValue],cell.devStatus.ep,cell.devStatus.set_temp,cell.devStatus.speed,mode,cell.devStatus.currentTemp];
            NSLog(@"str======== %@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:cell.devStatus.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.devStatus.offline = 0;
                            cell.devStatus.onoff = [receiveStr[@"onoff"] intValue];
                            [[DBManager shareManager] insertDeviceTableWithFile:cell.devStatus withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                        });
                    }
                }
            }];
            
        }else if ([cell.deviceInfo.type intValue] == DEV_TYPE_CURTAIN){
            int status_onoff = 0;
            if (cell.devStatus.onoff == 0 || cell.devStatus.onoff == 1) {
                status_onoff = 2;
            }else{
                status_onoff = 1;
            }
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d}",cell.devStatus.ltid,[cell.devStatus.dev_id intValue],cell.devStatus.ep,status_onoff];
            NSLog(@"str======== %@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:cell.devStatus.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            cell.devStatus.onoff = [receiveStr[@"onoff"] intValue];
                            cell.devStatus.offline = 0;
                            [[DBManager shareManager] insertDeviceTableWithFile:cell.devStatus withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.deviceInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                        });
                    }
                    
                }
            }];
            
        }
        
//        else{
//            if ([cell.devInfoModel.type intValue] == ACCESSORY_CATEGORY_AIR_CONDITIONER){
//                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
//                //空调
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                self.airView = [[AirConditioningView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                self.airView.backgroundColor = [UIColor clearColor];
//                self.airView.devStatus = cell.devStatusModel;
//                [self.airView createUI];
//                typeof(self) weakSelf = self;
//                [weakSelf.airView setActionBlock:^(NSInteger actionNum) {
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
//                    NSArray *result=[self.airView subviews];
//                    for (UIView *view in result) {
//                        [view removeFromSuperview];
//                    }
//                    //动画效果淡出
//                    [UIView animateWithDuration:0.3 animations:^{
//                        self.airView.frame = CGRectMake(self.addMoodBtn.frame.origin.x, self.addMoodBtn.frame.origin.y, 0, 0);
//                    } completion:^(BOOL finished) {
//                        if (finished) {
//                            [self.airView removeFromSuperview];
//                            self.airView = nil;
//                            if (actionNum == 1) {
//                                LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                                addCtrl.deviceInfo = cell.devInfoModel;
//                                addCtrl.deviceStatus = cell.devStatusModel;
//                                [self.navigationController pushViewController:addCtrl animated:YES];
//                            }else if (actionNum == 2){
//                                ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                                addCtrl.deviceInfo = cell.devInfoModel;
//                                addCtrl.deviceStatus = cell.devStatusModel;
//                                [self.navigationController pushViewController:addCtrl animated:YES];
//                            }else{
//                                CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                                addCtrl.deviceInfo = cell.devInfoModel;
//                                addCtrl.deviceStatus = cell.devStatusModel;
//                                [self.navigationController pushViewController:addCtrl animated:YES];
//                            }
//                        }
//                    }];
//                }];
//                [weakSelf.airView setCancelBlock:^(NSInteger num) {
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
//                    NSArray *result=[self.airView subviews];
//                    for (UIView *view in result) {
//                        [view removeFromSuperview];
//                    }
//                    //动画效果淡出
//                    [UIView animateWithDuration:0.3 animations:^{
//                        self.airView.frame = CGRectMake(self.addMoodBtn.frame.origin.x, self.addMoodBtn.frame.origin.y, 0, 0);
//                    } completion:^(BOOL finished) {
//                        if (finished) {
//                            [self.airView removeFromSuperview];
//                            self.airView = nil;
//                        }
//                    }];
//                }];
//                [weakSelf.airView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
//                    NSString *str = [NSString stringWithFormat:@"{\"longtoo_id\":\"%@\",\"device_id\":%d,\"ep\":%d,\"setTemp\":%d,\"fanSpeed\":%d,\"mode\":%d,\"currentTemp\":%d,\"keepalive\":%d}",devStatusModel.longtoo_id,[devStatusModel.device_id intValue],devStatusModel.ep,devStatusModel.setTemp,devStatusModel.fanSpeed,devStatusModel.mode,devStatusModel.currentTemp,600];
//                    //                                    NSLog(@"str======== %@",str);
//                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//                    [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.longtoo_id ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
//                        if ([serviceName isEqualToString:DEV_CONTROL]) {
//                            if ([receiveStr[@"result"] intValue] == 0) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    devStatusModel.offline = 0;
//                                    [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.devInfoModel]];
//                                    [UIView performWithoutAnimation:^{
//                                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                                    }];
//                                });
//                            }
//                        }
//                    }];
//                }];
//                [window addSubview:self.airView];
//            }else if ([cell.devInfoModel.type intValue] == ACCESSORY_CATEGORY_WINDOW_COVER ||[cell.devInfoModel.type intValue] == ACCESSORY_CATEGORY_WINDOW){
//                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
//                //窗帘
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                self.curtainView = [[CurtainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//                self.curtainView.backgroundColor = [UIColor clearColor];
//                self.curtainView.devStatus = cell.devStatusModel;
//                self.curtainView.selectStatus = cell.devStatusModel.onoff;
//                [self.curtainView createUI];
//                typeof(self) weakSelf = self;
//                [weakSelf.curtainView setActionBlock:^(NSInteger actionNum) {
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
//                    NSArray *result=[self.curtainView subviews];
//                    for (UIView *view in result) {
//                        [view removeFromSuperview];
//                    }
//                    //动画效果淡出
//                    [UIView animateWithDuration:0.3 animations:^{
//                        self.curtainView.frame = CGRectMake(self.addMoodBtn.frame.origin.x, self.addMoodBtn.frame.origin.y, 0, 0);
//                    } completion:^(BOOL finished) {
//                        if (finished) {
//                            [self.curtainView removeFromSuperview];
//                            self.curtainView = nil;
//                            if (actionNum == 1) {
//                                LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                                addCtrl.deviceInfo = cell.devInfoModel;
//                                addCtrl.deviceStatus = cell.devStatusModel;
//                                [self.navigationController pushViewController:addCtrl animated:YES];
//                            }else if (actionNum == 2){
//                                ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                                addCtrl.deviceInfo = cell.devInfoModel;
//                                addCtrl.deviceStatus = cell.devStatusModel;
//                                [self.navigationController pushViewController:addCtrl animated:YES];
//                            }else{
//                                CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                                addCtrl.deviceInfo = cell.devInfoModel;
//                                addCtrl.deviceStatus = cell.devStatusModel;
//                                [self.navigationController pushViewController:addCtrl animated:YES];
//                            }
//                        }
//                    }];
//                }];
//                [weakSelf.curtainView setCancelBlock:^(NSInteger num) {
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
//                    NSArray *result=[self.curtainView subviews];
//                    for (UIView *view in result) {
//                        [view removeFromSuperview];
//                    }
//                    //动画效果淡出
//                    [UIView animateWithDuration:0.3 animations:^{
//                        self.curtainView.frame = CGRectMake(self.addMoodBtn.frame.origin.x, self.addMoodBtn.frame.origin.y, 0, 0);
//                    } completion:^(BOOL finished) {
//                        if (finished) {
//                            [self.curtainView removeFromSuperview];
//                            self.curtainView = nil;
//                        }
//                    }];
//                }];
//                [weakSelf.curtainView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
//                    NSString *str = [NSString stringWithFormat:@"{\"longtoo_id\":\"%@\",\"device_id\":%d,\"ep\":%d,\"onoff\":%d,\"keepalive\":%d}",devStatusModel.longtoo_id,[devStatusModel.device_id intValue],devStatusModel.ep,devStatusModel.onoff,600];
//                    //                                    NSLog(@"str======== %@",str);
//                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//                    [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.longtoo_id ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
//                        if ([serviceName isEqualToString:DEV_CONTROL]) {
//                            if ([receiveStr[@"result"] intValue] == 0) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    devStatusModel.offline = 0;
//                                    [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:cell.devInfoModel]];
//                                    [UIView performWithoutAnimation:^{
//                                        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//                                    }];
//                                });
//                            }
//                        }
//                    }];
//                }];
//                [window addSubview:self.curtainView];
//            }else{
//            }
//        }
        
    }];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeviceListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    DeviceInformationModel *devInfo = cell.deviceInfo;
    DeviceStatusModel *devStatus = cell.devStatus;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    if ([devInfo.type intValue] == DEV_TYPE_SWITCH) {
        //开关
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.switchView = [[SwitchView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.switchView.devStatus = devStatus;
        [self.switchView createUI];
        self.switchView.backgroundColor = [UIColor clearColor];
        typeof(self) weakSelf = self;
        [weakSelf.switchView setActionBlock:^(NSInteger actionNum) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            NSArray *result=[self.switchView subviews];
            for (UIView *view in result) {
                [view removeFromSuperview];
            }
            //动画效果淡出
            [UIView animateWithDuration:0.3 animations:^{
                self.switchView.frame = CGRectMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    
                    [self.switchView removeFromSuperview];
                    self.switchView = nil;
                    if (actionNum == 1) {
//                        LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                        //                            AutomationController *addCtrl = [[AutomationController alloc] init];
                        //                            addCtrl.deviceInfo = devInfo;
                        //                            addCtrl.deviceStatus = devStatus;
                        //                            [self.navigationController pushViewController:addCtrl animated:YES];
                    }else if (actionNum == 2){
//                        ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }else{
//                        CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }
                    
                }
            }];
        }];
        [weakSelf.switchView setCancelBlock:^(NSInteger num) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            if (num == 0) {
                NSArray *result=[self.switchView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                //动画效果淡出
                [UIView animateWithDuration:0.3 animations:^{
                    self.switchView.frame = CGRectMake(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.switchView removeFromSuperview];
                        self.switchView = nil;
                    }
                }];
            }else if (num == 1) {
                NSArray *result=[self.switchView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                //动画效果淡出
                [UIView animateWithDuration:0.3 animations:^{
                    self.switchView.frame = CGRectMake(0, 0, 0, 0);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.switchView removeFromSuperview];
                        self.switchView = nil;
//                        SuperElectricityController *jointrl = [[SuperElectricityController alloc] init];
//                        jointrl.title = Localized(@"tx_electricity_statistics");
//                        jointrl.deviceInfo = devInfo;
//                        jointrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:jointrl animated:YES];
                    }
                }];
                
            }
        }];
        [weakSelf.switchView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d}",devStatusModel.ltid,[devStatusModel.dev_id intValue],devStatusModel.ep,devStatusModel.onoff];
            //                NSLog(@"str======== %@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            devStatusModel.offline = 0;
                            [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                            
                        });
                    }
                }
            }];
        }];
        [window addSubview:self.switchView];
        
        
    }
    else if ([devInfo.type intValue] == DEV_TYPE_LIGHTBULB){
        if ([devInfo.serial_type intValue] == 4) {
            //灯泡
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            self.brightColorview = [[SetBrightnessAndColorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.brightColorview.backgroundColor = [UIColor clearColor];
            self.brightColorview.devStatus = devStatus;
            [self.brightColorview createUI];
            typeof(self) weakSelf = self;

            [weakSelf.brightColorview setActionBlock:^(NSInteger actionNum) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
                NSArray *result=[self.brightColorview subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                [self.brightColorview removeFromSuperview];
                self.brightColorview = nil;
                if (actionNum == 1) {
//                    LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                    //                            AutomationController *addCtrl = [[AutomationController alloc] init];
                    //                            addCtrl.deviceInfo = devInfo;
                    //                            addCtrl.deviceStatus = devStatus;
                    //                            [self.navigationController pushViewController:addCtrl animated:YES];
                }else if (actionNum == 2){
//                    ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                }else{
//                    CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                }
            }];

            [weakSelf.brightColorview setCancelBlock:^(NSInteger num) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
                NSArray *result=[self.brightColorview subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                [self.brightColorview removeFromSuperview];
                self.brightColorview = nil;
            }];
            [weakSelf.brightColorview setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
                NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d,\"bri\":%d,\"sat\":%d,\"hue\":%d}",devStatusModel.ltid,[devStatusModel.dev_id intValue],devStatusModel.ep,devStatusModel.onoff,devStatusModel.bri,devStatusModel.sat,devStatusModel.hue];
                //                    NSLog(@"str======== %@",str);
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                    if ([serviceName isEqualToString:DEV_CONTROL]) {
                        if ([receiveStr[@"result"] intValue] == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                devStatusModel.offline = 0;
                                [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
                                [UIView performWithoutAnimation:^{
                                    [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                }];
                            });
                        }
                    }
                }];
            }];
            [window addSubview:self.brightColorview];
        }else if ([devInfo.serial_type intValue] == 1){

            //灯泡
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            self.dimmerView = [[DimmerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.dimmerView.backgroundColor = [UIColor clearColor];
            self.dimmerView.devStatus = devStatus;
            [self.dimmerView createUI];
            typeof(self) weakSelf = self;

            [weakSelf.dimmerView setActionBlock:^(NSInteger actionNum) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
                NSArray *result=[self.dimmerView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                [self.dimmerView removeFromSuperview];
                self.dimmerView = nil;
                if (actionNum == 1) {
//                    LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                    //                            AutomationController *addCtrl = [[AutomationController alloc] init];
                    //                            addCtrl.deviceInfo = devInfo;
                    //                            addCtrl.deviceStatus = devStatus;
                    //                            [self.navigationController pushViewController:addCtrl animated:YES];
                }else if (actionNum == 2){
//                    ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                }else{
//                    CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                }
            }];


            [weakSelf.dimmerView setCancelBlock:^(NSInteger num) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
                NSArray *result=[self.dimmerView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                [self.dimmerView removeFromSuperview];
                self.dimmerView = nil;
            }];
            [weakSelf.dimmerView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
                NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d,\"bri\":%d}",devStatusModel.ltid,[devStatusModel.dev_id intValue],devStatusModel.ep,devStatusModel.onoff,devStatusModel.bri];
                //                    NSLog(@"str======== %@",str);
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                    if ([serviceName isEqualToString:DEV_CONTROL]) {
                        if ([receiveStr[@"result"] intValue] == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                devStatusModel.offline = 0;
                                [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
                                [UIView performWithoutAnimation:^{
                                    [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                }];
                            });
                        }
                    }
                }];
            }];
            [window addSubview:self.dimmerView];
        }else{
            //rgb灯泡
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            self.rgbDeviceView = [[SetRGBDeviceView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.rgbDeviceView.devStatus = devStatus;
            [self.rgbDeviceView createUI];
            self.rgbDeviceView.backgroundColor = [UIColor clearColor];
            typeof(self) weakSelf = self;

            [weakSelf.rgbDeviceView setActionBlock:^(NSInteger actionNum) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
                NSArray *result=[self.rgbDeviceView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                [self.rgbDeviceView removeFromSuperview];
                self.rgbDeviceView = nil;
                if (actionNum == 1) {
//                    LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                    //                            AutomationController *addCtrl = [[AutomationController alloc] init];
                    //                            addCtrl.deviceInfo = devInfo;
                    //                            addCtrl.deviceStatus = devStatus;
                    //                            [self.navigationController pushViewController:addCtrl animated:YES];
                }else if (actionNum == 2){
//                    ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                }else{
//                    CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                    addCtrl.deviceInfo = devInfo;
//                    addCtrl.deviceStatus = devStatus;
//                    [self.navigationController pushViewController:addCtrl animated:YES];
                }
            }];

            [weakSelf.rgbDeviceView setCancelBlock:^(NSInteger num) {
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
                NSArray *result=[self.rgbDeviceView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                [self.rgbDeviceView removeFromSuperview];
                self.rgbDeviceView = nil;
            }];

            [weakSelf.rgbDeviceView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
                NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d,\"bri\":%d,\"sat\":%d,\"hue\":%d}",devStatusModel.ltid,[devStatusModel.dev_id intValue],devStatusModel.ep,devStatusModel.onoff,devStatusModel.bri,devStatusModel.sat,devStatusModel.hue];
                //                    NSLog(@"str======== %@",str);
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                    if ([serviceName isEqualToString:DEV_CONTROL]) {
                        if ([receiveStr[@"result"] intValue] == 0) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                devStatusModel.offline = 0;
                                [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
                                [UIView performWithoutAnimation:^{
                                    [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                }];
                            });
                        }

                    }
                }];
            }];


            [window addSubview:self.rgbDeviceView];
        }


    }
    else if ([devInfo.type intValue] == DEV_TYPE_AIR_COND){
        //空调
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.airView = [[AirConditioningView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.airView.backgroundColor = [UIColor clearColor];
        self.airView.devStatus = devStatus;
        [self.airView createUI];
        typeof(self) weakSelf = self;
        
        [weakSelf.airView setActionBlock:^(NSInteger actionNum) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            NSArray *result=[self.airView subviews];
            for (UIView *view in result) {
                [view removeFromSuperview];
            }
            //动画效果淡出
            [UIView animateWithDuration:0.3 animations:^{
                self.airView.frame = CGRectMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.airView removeFromSuperview];
                    self.airView = nil;
                    if (actionNum == 1) {
//                        LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                        //                            AutomationController *addCtrl = [[AutomationController alloc] init];
                        //                            addCtrl.deviceInfo = devInfo;
                        //                            addCtrl.deviceStatus = devStatus;
                        //                            [self.navigationController pushViewController:addCtrl animated:YES];
                    }else if (actionNum == 2){
//                        ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }else{
//                        CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }
                }
            }];
            
        }];
        
        
        [weakSelf.airView setCancelBlock:^(NSInteger num) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            NSArray *result=[self.airView subviews];
            for (UIView *view in result) {
                [view removeFromSuperview];
            }
            //动画效果淡出
            [UIView animateWithDuration:0.3 animations:^{
                self.airView.frame = CGRectMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.airView removeFromSuperview];
                    self.airView = nil;
                }
            }];
        }];
        [weakSelf.airView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"set_temp\":%d,\"speed\":%d,\"mode\":%d,\"currentTemp\":%d}",devStatusModel.ltid,[devStatusModel.dev_id intValue],devStatusModel.ep,devStatusModel.set_temp,devStatusModel.speed,devStatusModel.mode,devStatusModel.currentTemp];
            //                NSLog(@"str======== %@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            devStatusModel.offline = 0;
                            [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                        });
                    }
                    
                }
            }];
        }];
        [window addSubview:self.airView];
    }else if ([devInfo.type intValue] ==  DEV_TYPE_CURTAIN){
        //窗帘
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.curtainView = [[CurtainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.curtainView.backgroundColor = [UIColor clearColor];
        self.curtainView.devStatus = devStatus;
        self.curtainView.selectStatus = devStatus.onoff;
        [self.curtainView createUI];
        typeof(self) weakSelf = self;
        [weakSelf.curtainView setActionBlock:^(NSInteger actionNum) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            NSArray *result=[self.curtainView subviews];
            for (UIView *view in result) {
                [view removeFromSuperview];
            }
            //动画效果淡出
            [UIView animateWithDuration:0.3 animations:^{
                self.curtainView.frame = CGRectMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.curtainView removeFromSuperview];
                    self.curtainView = nil;
                    if (actionNum == 1) {
//                        LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                        //                            AutomationController *addCtrl = [[AutomationController alloc] init];
                        //                            addCtrl.deviceInfo = devInfo;
                        //                            addCtrl.deviceStatus = devStatus;
                        //                            [self.navigationController pushViewController:addCtrl animated:YES];
                    }else if (actionNum == 2){
//                        ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }else{
//                        CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }
                }
            }];
            
        }];
        [weakSelf.curtainView setCancelBlock:^(NSInteger num) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            NSArray *result=[self.curtainView subviews];
            for (UIView *view in result) {
                [view removeFromSuperview];
            }
            //动画效果淡出
            [UIView animateWithDuration:0.3 animations:^{
                self.curtainView.frame = CGRectMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.curtainView removeFromSuperview];
                    self.curtainView = nil;
                }
            }];
        }];
        [weakSelf.curtainView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d}",devStatusModel.ltid,[devStatusModel.dev_id intValue],devStatusModel.ep,devStatusModel.onoff];
            //                NSLog(@"str======== %@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            devStatusModel.offline = 0;
                            [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                        });
                    }
                    
                }
            }];
        }];
        [window addSubview:self.curtainView];
    }else if ([devInfo.type intValue] == DEV_TYPE_SOCKET) {
        //    插座控制界面
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.sView = [[SocketView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.sView.backgroundColor = [UIColor clearColor];
        self.sView.devStatus = devStatus;
        [self.sView createUI];
        typeof(self) weakSelf = self;
        //            [UIView animateWithDuration:.3 animations:^{
        //
        //            } completion:^(BOOL finished) {
        //                self.sView.statusLabel.alpha = 1;
        //                self.sView.selectButton.alpha = 1;
        //                self.sView.electricityLabel.alpha = 1;
        //                self.sView.electricityRecordBtn.alpha = 1;
        //                self.sView.cancelButton.alpha = 1;
        //            }];
        
        
        [weakSelf.sView setActionBlock:^(NSInteger actionNum) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            NSArray *result=[self.sView subviews];
            for (UIView *view in result) {
                [view removeFromSuperview];
            }
            //动画效果淡出
            [UIView animateWithDuration:0.3 animations:^{
                self.sView.frame = CGRectMake(KScreenWidth, KScreenHeight, KScreenWidth, KScreenHeight);
            } completion:^(BOOL finished) {
                if (finished) {
                    [self.sView removeFromSuperview];
                    self.sView = nil;
                    //开关
                    //                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    //                        self.moreFunctionView = [[DeviceMoreFunctionView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    //                        self.moreFunctionView.backgroundColor = [UIColor whiteColor];
                    //                        [window addSubview:self.moreFunctionView];
                    if (actionNum == 1) {
//                        LeavingHomeController *addCtrl = [[LeavingHomeController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                        //                            AutomationController *addCtrl = [[AutomationController alloc] init];
                        //                            addCtrl.deviceInfo = devInfo;
                        //                            addCtrl.deviceStatus = devStatus;
                        //                            [self.navigationController pushViewController:addCtrl animated:YES];
                    }else if (actionNum == 2){
//                        ScheduleViewController *addCtrl = [[ScheduleViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }else{
//                        CountDownViewController *addCtrl = [[CountDownViewController alloc] init];
//                        addCtrl.deviceInfo = devInfo;
//                        addCtrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:addCtrl animated:YES];
                    }
                }
            }];
        }];
        
        [weakSelf.sView setCancelBlock:^(NSInteger num) {
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
            if (num == 0) {
                NSArray *result=[self.sView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                //动画效果淡出
                [UIView animateWithDuration:0.3 animations:^{
                    self.sView.frame = CGRectMake(KScreenWidth, KScreenHeight, KScreenWidth, KScreenHeight);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.sView removeFromSuperview];
                        self.sView = nil;
                    }
                }];
            }else if (num == 1) {
                NSArray *result=[self.sView subviews];
                for (UIView *view in result) {
                    [view removeFromSuperview];
                }
                //动画效果淡出
                [UIView animateWithDuration:0.3 animations:^{
                    self.sView.frame = CGRectMake(KScreenWidth, KScreenHeight, KScreenWidth, KScreenHeight);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self.sView removeFromSuperview];
                        self.sView = nil;
//                        SuperElectricityController *jointrl = [[SuperElectricityController alloc] init];
//                        jointrl.title = Localized(@"tx_electricity_statistics");
//                        jointrl.deviceInfo = devInfo;
//                        jointrl.deviceStatus = devStatus;
//                        [self.navigationController pushViewController:jointrl animated:YES];
                    }
                }];
                
            }
            
        }];
        
        
        
        [weakSelf.sView setDeviceControlBlock:^(DeviceStatusModel *devStatusModel) {
            NSString *str = [NSString stringWithFormat:@"{\"ltid\":\"%@\",\"dev_id\":%d,\"ep\":%d,\"onoff\":%d}",devStatusModel.ltid,[devStatusModel.dev_id intValue],devStatusModel.ep,devStatusModel.onoff];
            //                NSLog(@"str======== %@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [self.longtoothHandler sendRequestWithRemoteLtid:devStatusModel.ltid ServiceName:DEV_CONTROL insData:data block:^(NSDictionary *receiveStr,NSString *serviceName) {
                if ([serviceName isEqualToString:DEV_CONTROL]) {
                    if ([receiveStr[@"result"] intValue] == 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            devStatusModel.offline = 0;
                            [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:devInfo]];
                            [UIView performWithoutAnimation:^{
                                [self.deviceListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            }];
                        });
                    }
                    
                }
            }];
        }];
        [window addSubview:self.sView];
    }
}
//- (UIImage  *)xy_noDataViewImage
//{
//    return [UIImage imageNamed:@"缺省-暂无"];
//}
//- (NSString *)xy_noDataViewMessage
//{
//    return @"暂无数据";
//}
//- (NSNumber *)xy_noDataViewCenterYOffset
//{
//    return [NSNumber numberWithFloat:-20];
//}
- (UIView   *)xy_noDataView
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.sd_layout
    .centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .widthIs(KScreenWidth-80)
    .heightIs(self.view.bounds.size.height);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"暂无设备, 请添加";
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [bgView addSubview:titleLabel];
    titleLabel.sd_layout
    .topSpaceToView(bgView, (bgView.bounds.size.height-20-20-40)/2)
    .centerXEqualToView(bgView)
    .widthIs(KScreenWidth-80)
    .heightIs(20);
    
    UIButton *addButton = [[UIButton alloc] init];
    [addButton setTitle:@"添加设备" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [bgView addSubview:addButton];
    addButton.sd_layout
    .topSpaceToView(titleLabel, 20)
    .centerXEqualToView(bgView)
    .widthIs(140)
    .heightIs(40);
    addButton.layer.borderWidth = 0.5;
    addButton.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
    addButton.layer.cornerRadius = 5;
    addButton.layer.masksToBounds = YES;
    [addButton addTarget:self action:@selector(addDeviceAction) forControlEvents:UIControlEventTouchUpInside];
    
    return bgView;
}
- (void)addDeviceAction
{
    SelectDeviceTypeController *selctCtrl = [[SelectDeviceTypeController alloc] init];
    [self.navigationController pushViewController:selctCtrl animated:YES];
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
