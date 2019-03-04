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
@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *deviceListTableView;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@end

@implementation DeviceListViewController
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
    [self setUI];
    DeviceInformationModel *devInfo = [[DeviceInformationModel alloc] init];
    devInfo.name = @"智能彩灯—123";
    DeviceInformationModel *devInfo1 = [[DeviceInformationModel alloc] init];
    devInfo1.name = @"智能彩灯—235";
    DeviceStatusModel *devStatus = [[DeviceStatusModel alloc] init];
    devStatus.offline = 0;
    devStatus.onoff = 0;
    DeviceStatusModel *devStatus1 = [[DeviceStatusModel alloc] init];
    devStatus1.offline = 1;
    devStatus1.onoff = 0;
    self.deviceListArray = [NSMutableArray arrayWithObjects:@[devInfo,devStatus],@[devInfo1,devStatus1], nil];
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
        if (scrollView.contentOffset.y<=-60) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"changeOffset" object:@{@"changeOffset":@1}];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = self.deviceListArray[indexPath.row];
    [cell configWithInfo:arr[0] andStatusModel:arr[1]];
        return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 120;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
