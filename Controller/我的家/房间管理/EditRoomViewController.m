//
//  EditRoomViewController.m
//  i-Home
//
//  Created by Frank on 2019/3/1.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "EditRoomViewController.h"
#import "MyFileHeader.h"
#import "EditRoomNameCell.h"
#import "RoomExistDeviceCell.h"
#import "RoomInexistenceDeviceCell.h"
@interface EditRoomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *existListArray;
@property (nonatomic, strong) NSMutableArray *inexistenceListArray;
@property (nonatomic, strong) EditRoomNameCell *editCell;
@end

@implementation EditRoomViewController
#pragma mark - 懒加载
- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
        
    }
    return _listArray;
}
- (NSMutableArray *)existListArray
{
    if (_existListArray == nil) {
        _existListArray = [NSMutableArray array];
        
    }
    return _existListArray;
}
- (NSMutableArray *)inexistenceListArray
{
    if (_inexistenceListArray == nil) {
        _inexistenceListArray = [NSMutableArray array];
        
    }
    return _inexistenceListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"房间管理";
    HomeInformationModel *homeInfo = KGetHome;
    UserMessageModel *userModel = KGetUserMessage;
    self.existListArray = [[DBManager shareManager] selectFromRoomDeviceTableWithRoomId:self.roominfo.room_id andHomeId:homeInfo.homeID andUserId:userModel.userID];
//    [self.existListArray addObjectsFromArray:@[@"智能彩灯-1",@"智能彩灯-2"]];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *allDevArr = [[DBManager shareManager] selectFromRoomDeviceWithHomeId:homeInfo.homeID andUserId:userModel.userID];
    if (allDevArr.count != 0) {
        for (DeviceInformationModel *info in allDevArr) {
            if (self.existListArray.count == 0) {
                [arr addObject:info];
            }else{
                for (int i = 0; i < self.existListArray.count; i++) {
                    DeviceInformationModel *infos = self.existListArray[i];
                    if (![info.dev_id isEqualToString:infos.dev_id] && ![info.home_id isEqualToString:infos.home_id] && ![info.user_id isEqualToString:infos.user_id] && ![info.name isEqualToString:infos.name]) {
                        [arr addObject:info];
                    }
                }
            }
        }
        self.inexistenceListArray = arr ;
        [self.listArray addObject:[[DBManager shareManager] selectFromRoomDeviceTableWithRoomId:self.roominfo.room_id andHomeId:homeInfo.homeID andUserId:userModel.userID]];
        [self.listArray addObject:arr];
    }
    [self setUI];
}
-(void)setUI
{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self creatNav];
    [self createTableView];
    
}
#pragma mark-创建tableview
- (void)createTableView
{
    [self listTableView];
}
#pragma mark - 创建tableview
-(UITableView *)listTableView
{
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _listTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.editing = YES;
//        _listTableView.tableFooterView = [UIView new];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_listTableView];
        [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.right.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
//                if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
//                    [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
//                }
//                if ([self.listTableView respondsToSelector:@selector(setLayoutMargins:)]) {
//                    [self.listTableView setLayoutMargins:UIEdgeInsetsZero];
//                }
    }
    return _listTableView;
}
- (void)creatNav
{
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
}

    

- (void)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveBtnClick
{
    HomeInformationModel *homeInfo = KGetHome;
    UserMessageModel *userModel = KGetUserMessage;
    if ([self.editCell.roomNameTextField.text length] == 0) {
        [SVProgressHUD doAnyRemindWithHUDMessage:@"请先输入房间名称" withDuration:1.5];
    }else{
        [[DBManager shareManager] updateRoomTableWithRoomName:self.editCell.roomNameTextField.text byRoomid:self.roominfo.room_id byHomeId:homeInfo.homeID byUserId:userModel.userID];
        
        for (DeviceInformationModel *devInfo in self.existListArray) {
            if (![devInfo.room_id isEqualToString:self.roominfo.room_id]) {
                [[DBManager shareManager] updateRoomDeviceTableWithRoomid:self.roominfo.room_id byDeviceId:devInfo.dev_id byHomeId:devInfo.home_id byUserId:devInfo.user_id];
            }
        }
        
        for (DeviceInformationModel *devInfo in self.inexistenceListArray) {
            if ([devInfo.room_id isEqualToString:self.roominfo.room_id]) {
                [[DBManager shareManager] updateRoomDeviceTableWithRoomid:@"1000000000000" byDeviceId:devInfo.dev_id byHomeId:devInfo.home_id byUserId:devInfo.user_id];
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - tableview代理方法
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, KScreenWidth)];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, KScreenWidth)];
//    }
//    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1+[self.listArray count];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [self.listArray[section-1] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"EditRoomNameCellID";
        self.editCell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (self.editCell == nil) {
            self.editCell = [[EditRoomNameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        self.editCell.roomNameTextField.text = self.roominfo.name;
        return self.editCell;
    }else {
        if (self.existListArray.count != 0 && self.inexistenceListArray.count == 0) {
            static NSString *cellId = @"RoomExistDeviceCellID";
            RoomExistDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[RoomExistDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            DeviceInformationModel *devInfo = self.existListArray[indexPath.row];
            if (devInfo.icon_path.length == 0) {
                devInfo.icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[devInfo.type intValue] andSerialType:[devInfo.serial_type intValue]];
            }
            cell.deviceNameLabel.text = devInfo.name;
            cell.iconImageView.image = [UIImage imageNamed:devInfo.icon_path];
            return cell;
        }else if (self.existListArray.count == 0 && self.inexistenceListArray.count != 0){
            static NSString *cellId = @"RoomInexistenceDeviceCellID";
            RoomInexistenceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[RoomInexistenceDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            DeviceInformationModel *devInfo = self.inexistenceListArray[indexPath.row];
            if (devInfo.icon_path.length == 0) {
                devInfo.icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[devInfo.type intValue] andSerialType:[devInfo.serial_type intValue]];
            }
            cell.deviceNameLabel.text = devInfo.name;
            cell.iconImageView.image = [UIImage imageNamed:devInfo.icon_path];
            RoomInformationModel *roomModel = [[DBManager shareManager] selectFromRoomTableWithRoomId:devInfo.room_id andHomeId:devInfo.home_id andUserId:devInfo.user_id];
            cell.roomNameLabel.text = roomModel.name;
            [cell setAddDeviceBlock:^(NSString * _Nonnull string) {
                [self.inexistenceListArray removeObject:devInfo];
                [self.existListArray addObject:devInfo];
                [self.listArray removeAllObjects];
                
                [self.listArray addObject:self.existListArray];
                if (self.inexistenceListArray.count != 0) {
                  [self.listArray addObject:self.inexistenceListArray];
                }
                
                [self.listTableView reloadData];
            }];
            return cell;
        }else if (self.existListArray.count != 0 && self.inexistenceListArray.count != 0){
            if (indexPath.section == 1) {
                static NSString *cellId = @"RoomExistDeviceCellID";
                RoomExistDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[RoomExistDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                DeviceInformationModel *devInfo = self.existListArray[indexPath.row];
                if (devInfo.icon_path.length == 0) {
                    devInfo.icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[devInfo.type intValue] andSerialType:[devInfo.serial_type intValue]];
                }
                cell.deviceNameLabel.text = devInfo.name;
                cell.iconImageView.image = [UIImage imageNamed:devInfo.icon_path];
                return cell;
            }else{
                static NSString *cellId = @"RoomInexistenceDeviceCellID";
                RoomInexistenceDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[RoomInexistenceDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                DeviceInformationModel *devInfo = self.inexistenceListArray[indexPath.row];
                if (devInfo.icon_path.length == 0) {
                    devInfo.icon_path = [[DeviceTypeManager shareManager] getDeviceIcon:[devInfo.type intValue] andSerialType:[devInfo.serial_type intValue]];
                }
                cell.deviceNameLabel.text = devInfo.name;
                cell.iconImageView.image = [UIImage imageNamed:devInfo.icon_path];
                RoomInformationModel *roomModel = [[DBManager shareManager] selectFromRoomTableWithRoomId:devInfo.room_id andHomeId:devInfo.home_id andUserId:devInfo.user_id];
                cell.roomNameLabel.text = roomModel.name;
                [cell setAddDeviceBlock:^(NSString * _Nonnull string) {
                    [self.inexistenceListArray removeObject:devInfo];
                    [self.existListArray addObject:devInfo];
                    [self.listArray removeAllObjects];
                    [self.listArray addObject:self.existListArray];
                    if (self.inexistenceListArray.count != 0) {
                        [self.listArray addObject:self.inexistenceListArray];
                    }
                    [self.listTableView reloadData];
                }];
                return cell;
            }
        }else{
            return nil;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return 60;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 50;
    }else{
        return 20;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    headView.backgroundColor = [UIColor clearColor];
    if (section == 2) {
        UILabel *remindLabel = [UILabel new];
        remindLabel.text = @"不在此房间的设备";
        remindLabel.frame = CGRectMake(15, 10, KScreenWidth-30, 30);
        remindLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [remindLabel setFont:[UIFont systemFontOfSize:17.0]];
        [headView addSubview:remindLabel];
        
    }else{
        
    }
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.001)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.existListArray.count != 0) {
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定删除设备吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                DeviceInformationModel *infos = self.existListArray[indexPath.row];
//                [[DBManager shareManager] updateRoomDeviceTableWithRoomid:infos.room_id byDeviceId:infos.dev_id byHomeId:infos.home_id byUserId:infos.user_id];
                [self.inexistenceListArray addObject:infos];
                [self.existListArray removeObjectAtIndex:indexPath.row];
                [self.listArray removeAllObjects];
                if (self.existListArray.count != 0) {
                    [self.listArray addObject:self.existListArray];
                }
                if (self.inexistenceListArray.count != 0) {
                    [self.listArray addObject:self.inexistenceListArray];
                }
                [self.listTableView reloadData];
            }]];
            [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertCtrl animated:YES completion:nil];
        }];
        return @[deleteAction];
    }else{
        return nil;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }else{
        if (self.existListArray.count != 0) {
            if (indexPath.section == 1) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
}

#pragma mark 设置编辑的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 设置处理编辑情况
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        // 1.更新数据
        // 2.更新UI
        //        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark 设置可以移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return NO;
    }else{
        if (self.existListArray.count != 0) {
            if (indexPath.section == 1) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }
}
#pragma mark 处理移动的情况
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}
-(NSIndexPath*)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.section == 0 || proposedDestinationIndexPath.section == 2) {
        return sourceIndexPath;
    }else{
        return proposedDestinationIndexPath;
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
