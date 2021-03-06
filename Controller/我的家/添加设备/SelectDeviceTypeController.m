//
//  SelectDeviceTypeController.m
//  i-Home
//
//  Created by Frank on 2019/2/28.
//  Copyright © 2019 Victor. All rights reserved.
//

#import "SelectDeviceTypeController.h"
#import "Masonry.h"
#import "MyFileHeader.h"
#import "SelectDeviceTypeCell.h"
#import "GetDeviceController.h"
@interface SelectDeviceTypeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *deviceListTableView;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong) NSMutableArray *deviceIconArray;
@end

@implementation SelectDeviceTypeController
- (NSMutableArray *)deviceIconArray
{
    if (_deviceIconArray == nil) {
        _deviceIconArray = [NSMutableArray array];
        
    }
    return _deviceIconArray;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加设备";
    [self.deviceListArray addObjectsFromArray:@[@"照明",@"插座",@"开关",@"窗帘",@"空调"]];
    [self.deviceIconArray addObjectsFromArray:@[@"device_light_bulb",@"device_socket",@"device_power",@"device_curtains",@"device_aircon"]];
    [self setUI];
}
- (void)setUI{
    [self createTableView];
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
//        _deviceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_deviceListTableView];
        [_deviceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.right.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
    }
    return _deviceListTableView;
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
    static NSString *cellId = @"SelectDeviceTypeCellID";
    SelectDeviceTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SelectDeviceTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.deviceNameLabel.text = self.deviceListArray[indexPath.row];
    NSString *str = self.deviceIconArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:str];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"所有设备";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetDeviceController *getCtrl = [[GetDeviceController alloc] init];
    [self.navigationController pushViewController:getCtrl animated:YES];
}
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
