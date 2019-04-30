//
//  AddHomeViewController.m
//  i-Home
//
//  Created by Frank on 2019/3/4.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "AddHomeViewController.h"
#import "MyFileHeader.h"
#import "EditRoomNameCell.h"
#import "HomeRoomListCell.h"
#import "RoomManageCell.h"
#import "AddRoomViewController.h"
@interface AddHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) EditRoomNameCell *editCell;
//@property (nonatomic, strong) NSMutableArray *existListArray;
//@property (nonatomic, strong) NSMutableArray *inexistenceListArray;

@end

@implementation AddHomeViewController

#pragma mark - 懒加载
- (NSMutableArray *)listArray
{
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
        
    }
    return _listArray;
}
//- (NSMutableArray *)existListArray
//{
//    if (_existListArray == nil) {
//        _existListArray = [NSMutableArray array];
//
//    }
//    return _existListArray;
//}
//- (NSMutableArray *)inexistenceListArray
//{
//    if (_inexistenceListArray == nil) {
//        _inexistenceListArray = [NSMutableArray array];
//
//    }
//    return _inexistenceListArray;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"添加家庭";
//    UserMessageModel *usermodel = KGetUser;
//    self.listArray = [[DBManager shareManager] selectFromHomeTableWithUserId:usermodel.userID];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"selectroomessage.data"];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    NSArray *arr = @[@"客厅",@"主卧",@"书房",@"厨房",@"餐厅",@"洗漱间"];
    for (int i = 0; i < arr.count; i++) {
        SelectRoomModel *model = [[SelectRoomModel alloc] init];
        model.room_name = arr[i];
        model.isSelectRoom = 1;
        [self.listArray addObject:model];
    }
//    [self.listArray addObject:@[@[@"客厅",@1],@[@"主卧",@1],@[@"书房",@1],@[@"厨房",@1],@[@"餐厅",@1],@[@"洗漱间",@1]]];
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
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_listTableView setTableFooterView:view];
//        [_listTableView setTableHeaderView:view];
//        _listTableView.editing = YES;
//                _listTableView.tableFooterView = [UIView new];
//        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_listTableView];
        [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.right.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
                        if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
                            [self.listTableView setSeparatorInset:UIEdgeInsetsZero];
                        }
                        if ([self.listTableView respondsToSelector:@selector(setLayoutMargins:)]) {
                            [self.listTableView setLayoutMargins:UIEdgeInsetsZero];
                        }
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
    [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.listTableView)
//    {
//        CGFloat sectionHeaderHeight = 50;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    SelectRoomModel *roommodel = KGetSelectRoom;
    if ([roommodel.room_name length] != 0) {
        [self.listArray addObject:roommodel];
        [self.listTableView reloadData];
    }
}
- (void)cancelBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveBtnClick
{
    if ([self.editCell.roomNameTextField.text length] == 0) {
        [SVProgressHUD doAnyRemindWithHUDMessage:@"请先输入家庭名称" withDuration:1.5];
    }else{
        
        UserMessageModel *usermodel = KGetUserMessage;
        HomeInformationModel *model = [[HomeInformationModel alloc] init];
        if ([[[DBManager shareManager] selectFromHomeTable] count] == 0) {
            
            
            model.userID = usermodel.userID;
            model.homeID = [[DeviceTypeManager shareManager] get10Homeid];
            model.name = self.editCell.roomNameTextField.text;
            model.is_defaultHome = @"1";
            model.user_right = @"1";
            [[DBManager shareManager] insertHomeTableWithFile:model];
            KSaveHome(model);
            [self addRoomData:model];
        }else{
            NSMutableArray *arr = [[DBManager shareManager] selectFromHomeTable];
            BOOL isSameName = NO;
            for (HomeInformationModel *homeInfo in arr) {
                if ([self.editCell.roomNameTextField.text isEqualToString:homeInfo.name]) {
                    isSameName = YES;
                }
            }
            if (isSameName == YES) {
                [SVProgressHUD doAnyRemindWithHUDMessage:@"请输入唯一的家庭名称" withDuration:1.5];
            }else{
                model.userID = usermodel.userID;
                model.homeID = [[DeviceTypeManager shareManager] get10Homeid];
                model.name = self.editCell.roomNameTextField.text;
                model.is_defaultHome = @"2";
                model.user_right = @"1";
                [[DBManager shareManager] insertHomeTableWithFile:model];
                [self addRoomData:model];
            }
            
            
            
        }
        
        
    }
}
- (void)addRoomData:(HomeInformationModel *)model
{
    UserMessageModel *usermodel = KGetUserMessage;
//    RoomInformationModel *roominfo = [[RoomInformationModel alloc] init];
//    roominfo.user_id = usermodel.userID;
//    roominfo.home_id = model.homeID;
//    roominfo.name = @"所有设备";
//    roominfo.room_id = @"1000000000000";
//    roominfo.is_defaultRoom = @"1";
//    roominfo.icon_order = @"0";
//    [[DBManager shareManager] insertRoomTableWithFile:roominfo];
    
    for (int i = 0; i < self.listArray.count; i++) {
        SelectRoomModel *selectmodel = self.listArray[i];
        if (selectmodel.isSelectRoom == 1) {
            RoomInformationModel *roominfo = [[RoomInformationModel alloc] init];
            roominfo.user_id = usermodel.userID;
            roominfo.home_id = model.homeID;
            roominfo.name = selectmodel.room_name;
            roominfo.room_id = [[DeviceTypeManager shareManager] get14Roomid];
            roominfo.is_defaultRoom = @"2";
            roominfo.icon_order = [NSString stringWithFormat:@"%d",i+1];
            roominfo.dev_num = 0;
            [[DBManager shareManager] insertRoomTableWithFile:roominfo];
        }
    }
    
    
    [self cancelBtnClick];
}
#pragma mark - tableview代理方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, KScreenWidth)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, KScreenWidth)];
        }
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }else{
        if (indexPath.row == [self.listArray count]-1) {
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
            }
            if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
        }else{
            if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
                [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, KScreenWidth)];
            }
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, KScreenWidth)];
            }
            if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
        }
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1+1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [self.listArray count]+1;
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
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.editCell.roomNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.editCell.contentView);
            make.left.mas_equalTo(self.editCell.contentView).offset(15);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(50);
        }];
        [self.editCell.roomNameTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.editCell.contentView);
            make.left.mas_equalTo(self.editCell.roomNameLabel.mas_right).offset(30);
            make.right.mas_equalTo(self.editCell.contentView.mas_right).offset(-20);
            make.height.mas_equalTo(50);
        }];
        self.editCell.roomNameLabel.text = @"家庭名称";
        self.editCell.roomNameTextField.placeholder = @"填写家庭名称";
        return self.editCell;
    }else {
        if (indexPath.row == [self.listArray count]) {
            static NSString *cellId = @"RoomManageCell1ID";
            RoomManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[RoomManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.roomNameLabel.text = @"添加房间";
            cell.roomNameLabel.textColor = [UIColor colorWithHexString:@"28a7ff"];
            cell.deviceNumLabel.text = @"";
            return cell;
        }else{
            static NSString *cellId = @"HomeRoomListCellID";
            HomeRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[HomeRoomListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            SelectRoomModel *model = self.listArray[indexPath.row];
            cell.roomNameLabel.text = model.room_name;
            if (model.isSelectRoom == 1) {
                [cell.selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
            }else{
                [cell.selectButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
            }
            typeof(cell) weakcell = cell;
            [weakcell setSelectBlock:^(NSString * _Nonnull str) {
                SelectRoomModel *models = self.listArray[indexPath.row];
                if ([str intValue] == 1) {
                    models.isSelectRoom = 1;
                    [self.listArray replaceObjectAtIndex:indexPath.row withObject:models];
                   [cell.selectButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
                }else{
                    models.isSelectRoom = 0;
                    [self.listArray replaceObjectAtIndex:indexPath.row withObject:models];
                    [cell.selectButton setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
                }
                
            }];
            return cell;
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
    if (section == 0) {
        return 20;
    }else{
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0)];
    headView.backgroundColor = [UIColor clearColor];
    
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 50;
    }else{
        return 0.0001;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section == 0) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        footerView.backgroundColor = [UIColor clearColor];
        UILabel *remindLabel = [UILabel new];
        remindLabel.text = @"在哪些房间有智能设备:";
        remindLabel.frame = CGRectMake(15, 10, KScreenWidth-30, 30);
        remindLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [remindLabel setFont:[UIFont systemFontOfSize:17.0]];
        [footerView addSubview:remindLabel];
        return footerView;
    }else{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 0.0001)];
        footerView.backgroundColor = [UIColor clearColor];
        return footerView;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == [self.listArray count]) {
            AddRoomViewController *addRoomCtrl = [[AddRoomViewController alloc] init];
            [self.navigationController pushViewController:addRoomCtrl animated:YES];
        }
    }
}

//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.listArray.count != 0) {
//        if (indexPath.section == 1 && indexPath.row < [self.listArray count]) {
//            UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定删除设备吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//
//                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//
//
//                    [self.listTableView reloadData];
//                }]];
//                [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//                }]];
//                [self presentViewController:alertCtrl animated:YES completion:nil];
//            }];
//            return @[deleteAction];
//        }else{
//             return nil;
//        }
//
//    }else{
//        return nil;
//    }
//    //    DeviceInformationModel *devModel = self.listDataArr[indexPath.row];
//
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath{
//    if (indexPath.section == 0) {
//        return NO;
//    }else{
//            if (indexPath.row < [self.listArray[0] count]) {
//                return YES;
//            }else{
//                return NO;
//            }
//
//
//    }
//
//}

#pragma mark 设置编辑的样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
#pragma mark 设置处理编辑情况
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle ==UITableViewCellEditingStyleDelete) {
//        // 1.更新数据
//
//        // 2.更新UI
//
//        //        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
