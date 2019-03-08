//
//  HomeManagerViewController.m
//  i-Home
//
//  Created by Frank on 2019/3/4.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "HomeManagerViewController.h"
#import "MyFileHeader.h"
#import "RoomManageCell.h"
#import "AddHomeViewController.h"
@interface HomeManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *deviceListTableView;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong)UIButton *editBtn;

@end

@implementation HomeManagerViewController
#pragma mark - 懒加载
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"家庭管理";
    
//    self.deviceListArray = [NSMutableArray arrayWithObjects:@"我的家",@"LongTooth", nil];
    //    [self.deviceListArray addObjectsFromArray:@[@"客厅",@"主卧",@"书房",@"厨房",@"餐厅",@"洗漱间"]];
    [self setUI];
}
- (void)setUI{
//    [self createNav];
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.deviceListArray = [[DBManager shareManager] selectFromHomeTable];
    [self.deviceListTableView reloadData];
}
- (void)createNav{
    self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editBtn.selected = NO;
    [self.editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
}
#pragma mark-编辑按钮事件
- (void)editBtnClick
{
    if (!self.editBtn.selected) {
        [self.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.editBtn.selected = YES;
        self.deviceListTableView.editing = YES;
    }else{
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.editBtn.selected = NO;
        self.deviceListTableView.editing = NO;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deviceListTableView reloadData];
    });
}
#pragma mark-创建tableview
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
        //        _deviceListTableView.tableFooterView = [UIView new];
        _deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_deviceListTableView];
        [_deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.right.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
        //        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        //            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        //        }
        //        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        //            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        //        }
    }
    return _deviceListTableView;
}
//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
//    }
//
//    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
//        [cell setPreservesSuperviewLayoutMargins:NO];
//    }
//}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.deviceListArray.count;
    }else{
        return 1;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"UITableViewCellsID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        HomeInformationModel *infomodel = self.deviceListArray[indexPath.row];
        cell.textLabel.text = infomodel.name;
        cell.textLabel.font = [UIFont systemFontOfSize:21];
//        cell.deviceNumLabel.text = @"";
        return cell;
    }else{
        static NSString *cellId = @"RoomManageCell1ID";
        RoomManageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[RoomManageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.roomNameLabel.text = @"添加家庭";
        cell.roomNameLabel.textColor = [UIColor colorWithHexString:@"28a7ff"];
        cell.deviceNumLabel.text = @"";
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 15)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        AddHomeViewController *addCtrl = [[AddHomeViewController alloc] init];
        [self.navigationController pushViewController:addCtrl animated:YES];
    }else{
//        NSArray *arr = self.deviceListArray[indexPath.row];
//        NSString *roomName = arr[0];
//        EditRoomViewController *editCtrl = [[EditRoomViewController alloc] init];
//        editCtrl.roomName = roomName;
//        [self.navigationController pushViewController:editCtrl animated:YES];
    }
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    DeviceInformationModel *devModel = self.listDataArr[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"确定删除房间？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertCtrl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }];
    return @[deleteAction];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return YES;
    }else{
        return NO;
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
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath*)indexPath
//{
//
//    if (indexPath.section == 0) {
//        return YES;
//    }else{
//        return NO;
//    }
//}
//#pragma mark 处理移动的情况
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//
//}




- (UIImage  *)xy_noDataViewImage
{
    return [UIImage imageNamed:@"缺省-暂无"];
}
- (NSString *)xy_noDataViewMessage
{
    return @"暂无数据";
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
