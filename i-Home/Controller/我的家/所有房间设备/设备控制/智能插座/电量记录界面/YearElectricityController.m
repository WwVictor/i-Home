//
//  YearElectricityController.m
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "YearElectricityController.h"

#import "YearElectricityCell.h"
#import "Masonry.h"
#import "InstantaneousPowerCell.h"
#import "MyFileHeader.h"
@interface YearElectricityController ()<UITableViewDelegate, UITableViewDataSource,HandleEventDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataListArr;
@property (nonatomic, strong) LongToothHandler *longtoothHandler;
@property (nonatomic, strong) NSMutableArray *timeListArr;
@end

@implementation YearElectricityController
{
    UIImageView *_navBarHairlineImageView;
    CGFloat _yearNumber;
}
#pragma mark - 懒加载
-(NSMutableArray *)dataListArr
{
    if (_dataListArr == nil) {
        _dataListArr = [NSMutableArray array];
    }
    return _dataListArr;
}
-(NSMutableArray *)timeListArr
{
    if (_timeListArr == nil) {
        _timeListArr = [NSMutableArray array];
    }
    return _timeListArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.longtoothHandler = [LongToothHandler sharedInstance];
    [[LongToothHandler sharedInstance] configHandleEventDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat m = (KScreenWidth-54)/54;
    _yearNumber = round(m);
//    [self createLeftBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self tableView];
}
#pragma mark - handleEvent代理
- (void)handleEventNotification:(id)objc andServiceName:(NSString *)serviceName
{
    if ([serviceName isEqualToString:POWER_LAST_YEAR]) {
        NSDictionary *dict = (NSDictionary *)objc;
        if ([dict[@"event"] integerValue]  == EVENT_LONGTOOTH_TIMEOUT) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"tx_user_notice_year_electri") withDuration:1.5];
                [self.tableView reloadData];
            });
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.longtoothHandler sendRequestWithRemoteLtid:self.deviceInfo.longtooth_id ServiceName:POWER_LAST_YEAR insData:nil block:^(NSDictionary *receiveStr,NSString *serviceName) {
        if ([serviceName isEqualToString:POWER_LAST_YEAR]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataListArr removeAllObjects];
                if ([receiveStr[@"result"] intValue] == 1) {
                    NSDate *date = [self dateFromString:[self getCurrentTime]];
                    NSArray *dataArr = receiveStr[@"year_powers"];
                    for (NSInteger i = dataArr.count-1; i >= 0; i--) {
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
                        [components setMonth:([components month]-i)];
                        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
                        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
                        [dateday setDateFormat:@"yyyy-MM"];
                        NSLog(@"i == %ld ------%@",i,[dateday stringFromDate:beginningOfWeek]);
                        [self.timeListArr addObject:[dateday stringFromDate:beginningOfWeek]];
                    }
                    [self.dataListArr addObjectsFromArray:receiveStr[@"year_powers"]];
                    [self.tableView reloadData];
                }else{
                    [self.tableView reloadData];
                }
            });
        }
    }];
}
//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}


- (void)createLeftBtn
{
    //    UINavigationBar *bar = [UINavigationBar appearance];
    //
    //    [bar setBarTintColor:[UIColor colorWithHexString:@"004DA1"]];
    //    self.navigationController.navigationBar.translucent = NO;
    //    [self.navigationController.navigationBar setTintColor:[UIColor colorWithHexString:@"004DA1"]];
    self.navigationItem.title = @"每年功率统计";
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = itemleft;
}


- (void)updateViewConstraints {
    [_tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view.mas_top).offset(SafeAreaTopHeight);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [super updateViewConstraints];
}

#pragma mark Lazy Loading
- (UITableView*)tableView {
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithRed:235/255.0
                                                     green:235/255.0 blue:235/255.0 alpha:1];
#pragma mark Register Cell
        [_tableView registerClass:[YearElectricityCell class]
           forCellReuseIdentifier:kYearElectricityCell];
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
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0) {
        YearElectricityCell* cell =
        [tableView dequeueReusableCellWithIdentifier:kYearElectricityCell
                                        forIndexPath:indexPath];
        [cell configWithData:self.dataListArr andWithTime:self.timeListArr];
        cell.barChart.barChartView.contentOffset = CGPointMake((40+40*0.35)*(self.dataListArr.count- _yearNumber), cell.barChart.barChartView.frame.origin.y-10);
        return cell;
    }else{
        InstantaneousPowerCell* cell =
        [tableView dequeueReusableCellWithIdentifier:kInstantaneousPowerCell
                                        forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configWithTitleName:Localized(@"tx_electricity_instantaneous_power") withDetailName:[NSString stringWithFormat:@"%dW",self.deviceStatus.engery]];
        
        return cell;
    }
    
}



#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row==0) {
//        return 330;
        return 300;
    }else{
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
//    return 0;
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
