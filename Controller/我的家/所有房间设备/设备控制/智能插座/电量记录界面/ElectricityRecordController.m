//
//  ElectricityRecordController.m
//  iThing
//
//  Created by Frank on 2018/8/2.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import "ElectricityRecordController.h"

#import "BarChartCell.h"
#import "Masonry.h"
#import "EveryDayCell.h"
#import "InstantaneousPowerCell.h"
@interface ElectricityRecordController ()<UITableViewDelegate, UITableViewDataSource,HandleEventDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataListArr;
@property (nonatomic, strong) LongToothHandler *longtoothHandler;
@end

@implementation ElectricityRecordController
{
    UIImageView *_navBarHairlineImageView;
}
#pragma mark - 懒加载
-(NSMutableArray *)dataListArr
{
    if (_dataListArr == nil) {
        _dataListArr = [NSMutableArray array];
    }
    return _dataListArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.longtoothHandler = [LongToothHandler sharedInstance];
    [[LongToothHandler sharedInstance] configHandleEventDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
//    _navBarHairlineImageView = backgroundView.subviews.firstObject;
//    _navBarHairlineImageView.hidden = YES;
//    self.dataListArr = [NSMutableArray arrayWithObjects:@[@"7-31-2018",@"44.99(W.h)"],@[@"7-30-2018",@"50.04(W.h)"],@[@"7-29-2018",@"74.93(W.h)"],@[@"7-28-2018",@"92.91(W.h)"],@[@"7-27-2018",@"70.48(W.h)"],@[@"7-26-2018",@"14.99(W.h)"],@[@"7-25-2018",@"17.04(W.h)"],@[@"7-24-2018",@"10.93(W.h)"],@[@"7-23-2018",@"52.91(W.h)"],@[@"7-22-2018",@"28.48(W.h)"],@[@"7-21-2018",@"44.99(W.h)"],@[@"7-20-2018",@"50.04(W.h)"],@[@"7-19-2018",@"74.93(W.h)"],@[@"7-18-2018",@"92.91(W.h)"],@[@"7-17-2018",@"70.48(W.h)"],@[@"7-16-2018",@"80.99(W.h)"],@[@"7-15-2018",@"90.04(W.h)"],@[@"7-14-2018",@"50.93(W.h)"],@[@"7-13-2018",@"50.93(W.h)"],@[@"7-12-2018",@"50.93(W.h)"],@[@"7-11-2018",@"50.93(W.h)"],@[@"7-10-2018",@"50.93(W.h)"],@[@"7-9-2018",@"50.93(W.h)"],@[@"7-8-2018",@"50.93(W.h)"],@[@"7-7-2018",@"50.93(W.h)"],@[@"7-6-2018",@"50.93(W.h)"],@[@"7-5-2018",@"50.93(W.h)"],@[@"7-4-2018",@"50.93(W.h)"],@[@"7-3-2018",@"50.93(W.h)"],@[@"7-2-2018",@"50.93(W.h)"],@[@"7-1-2018",@"50.93(W.h)"], nil];
//    [self createLeftBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self tableView];
}
#pragma mark - handleEvent代理
- (void)handleEventNotification:(id)objc andServiceName:(NSString *)serviceName
{
    if ([serviceName isEqualToString:POWER_TODAY]) {
        NSDictionary *dict = (NSDictionary *)objc;
        if ([dict[@"event"] integerValue]  == EVENT_LONGTOOTH_TIMEOUT) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"tx_user_notice_day_electri") withDuration:1.5];
                [self.tableView reloadData];
            });
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.longtoothHandler sendRequestWithRemoteLtid:self.deviceInfo.longtooth_id ServiceName:POWER_TODAY insData:nil block:^(NSDictionary *receiveStr,NSString *serviceName) {
        if ([serviceName isEqualToString:POWER_TODAY]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataListArr removeAllObjects];
                if ([receiveStr[@"result"] intValue] == 1) {
                    
                    [self.dataListArr addObjectsFromArray:receiveStr[@"day_powers"]];
                    [self.tableView reloadData];
                }else{
                    [self.tableView reloadData];
                }
            });
        }
    }];
}

- (void)createLeftBtn
{
//    UINavigationBar *bar = [UINavigationBar appearance];
//
//    [bar setBarTintColor:[UIColor colorWithHexString:@"004DA1"]];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"004DA1"]];
    self.navigationItem.title = @"每日功率统计";
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = itemleft;
}


- (void)updateViewConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [super updateViewConstraints];
}

#pragma mark Lazy Loading
- (UITableView*)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRed:235/255.0
                green:235/255.0 blue:235/255.0 alpha:1];
#pragma mark Register Cell
        
        [_tableView registerClass:[BarChartCell class]
           forCellReuseIdentifier:kBarChartCell];
//        [_tableView registerClass:[EveryDayCell class]
//           forCellReuseIdentifier:kEveryDayCell];
        
        [_tableView registerClass:[InstantaneousPowerCell class]
           forCellReuseIdentifier:kInstantaneousPowerCell];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.top.equalTo(self.view.mas_top).offset(0);
            make.left.equalTo(self.view.mas_left).offset(0);
            make.right.equalTo(self.view.mas_right).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
- (void)leftAction
{
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (self.dataListArr.count != 0) {
        return 2;
    }else{
        return 0;
    }
//    if (section == 0) {
//    }else{
//     return self.dataListArr.count;
//    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0) {
        BarChartCell* cell =
        [tableView dequeueReusableCellWithIdentifier:kBarChartCell
                                        forIndexPath:indexPath];
    [cell configWithData:self.dataListArr];
        return cell;
    }else{
        InstantaneousPowerCell* cell =
        [tableView dequeueReusableCellWithIdentifier:kInstantaneousPowerCell
                                        forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configWithTitleName:Localized(@"tx_electricity_instantaneous_power") withDetailName:[NSString stringWithFormat:@"%dW",self.deviceStatus.engery]];
        
        return cell;
    }
//        else{
//        EveryDayCell* cell =
//        [tableView dequeueReusableCellWithIdentifier:kEveryDayCell
//                                        forIndexPath:indexPath];
//         cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        NSArray *arr = self.dataListArr[indexPath.row];
//        [cell configWithTitleName:arr[0] withDetailName:arr[1]];
//        return cell;
//    }
    
}

- (NSString*)tableView:(UITableView*)tableView
titleForHeaderInSection:(NSInteger)section {

        return @"";

}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row==0) {
      return 300;
    }
    else{
        return 60;
    }
    
}
- (NSString *)xy_noDataViewMessage
{
    return Localized(@"tx_user_notice_temporarily_no_data");
}
- (UIColor  *)xy_noDataViewMessageColor
{
    return [UIColor colorWithHexString:@"333333"];
}
//- (CGFloat)tableView:(UITableView*)tableView
//heightForHeaderInSection:(NSInteger)section {
//    return 0;
//}
//- (CGFloat)tableView:(UITableView*)tableView
//heightForFooterInSection:(NSInteger)section {
//    return 15;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
//    view.backgroundColor = [UIColor whiteColor];
//    return view;
//}
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
