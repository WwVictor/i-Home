//
//  MouthElectricityController.m
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import "MouthElectricityController.h"
#import "MouthElectricityRecordCell.h"
#import "Masonry.h"
#import "InstantaneousPowerCell.h"
#import "EveryDayCell.h"
@interface MouthElectricityController ()<UITableViewDelegate, UITableViewDataSource,HandleEventDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray *dataListArr;
@property (nonatomic, strong) NSMutableArray *timeListArr;
@property (nonatomic, strong) NSMutableArray *allTimeListArr;
@property (nonatomic, strong) LongToothHandler *longtoothHandler;
@property (nonatomic, strong) MouthElectricityRecordCell* mouthCell;
@end

@implementation MouthElectricityController
{
    UIImageView *_navBarHairlineImageView;
    NSInteger _selectNum;
    CGFloat _mouthNumber;
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
-(NSMutableArray *)allTimeListArr
{
    if (_allTimeListArr == nil) {
        _allTimeListArr = [NSMutableArray array];
    }
    return _allTimeListArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.longtoothHandler = [LongToothHandler sharedInstance];
    [[LongToothHandler sharedInstance] configHandleEventDelegate:self];
    self.view.backgroundColor = [UIColor whiteColor];
    _selectNum = 0;
    CGFloat m = (KScreenWidth-54)/54;
    _mouthNumber = round(m);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self tableView];
}
#pragma mark - handleEvent代理
- (void)handleEventNotification:(id)objc andServiceName:(NSString *)serviceName
{
    if ([serviceName isEqualToString:POWER_LAST_2MONTH]) {
        NSDictionary *dict = (NSDictionary *)objc;
        if ([dict[@"event"] integerValue]  == EVENT_LONGTOOTH_TIMEOUT) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD doAnyRemindWithHUDMessage:Localized(@"tx_user_notice_mouth_electri") withDuration:1.5];
                [self.tableView reloadData];
            });
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.longtoothHandler sendRequestWithRemoteLtid:self.deviceInfo.longtooth_id ServiceName:POWER_LAST_2MONTH insData:nil block:^(NSDictionary *receiveStr,NSString *serviceName) {
        if ([serviceName isEqualToString:POWER_LAST_2MONTH]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataListArr removeAllObjects];
                [self.timeListArr removeAllObjects];
                [self.allTimeListArr removeAllObjects];
                if ([receiveStr[@"result"] intValue] == 1) {
                    
                    

                    NSDate *date = [self dateFromString:[self getCurrentTime]];
                    NSArray *dataArr = receiveStr[@"2month_powers"];
                    NSMutableArray *newDataArr = [NSMutableArray array];
                    NSInteger dataNum = [self getTheCountOfTwoDaysWithBeginDate];
                    for (NSInteger i = 61; i >= 62-dataNum; i--) {
                        [newDataArr insertObject:dataArr[i] atIndex:0];
                    }
                    
                    for (NSInteger i = newDataArr.count-1; i >= 0; i--) {
                        [self.allTimeListArr addObject:[self GetTomorrowDay:[self dateAllFromString:[self getAllCurrentTime]] andNum:i]];
                        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                        NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
                        [components setDay:([components day]-i)];
                        NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
                        NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
                        [dateday setDateFormat:@"MM-dd"];
                        NSLog(@"i == %ld ------%@",i,[dateday stringFromDate:beginningOfWeek]);
                        [self.timeListArr addObject:[dateday stringFromDate:beginningOfWeek]];
                    }
                    [self.dataListArr addObjectsFromArray:newDataArr];
                    [self.tableView reloadData];
                }else{
                    [self.tableView reloadData];
                }
            });
        }
    }];
}

/**任意两天相差天数*/

- (NSInteger)getTheCountOfTwoDaysWithBeginDate{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString*endDate = [dateFormatter stringFromDate:currentDate];
    
    NSDate *monthagoData = [self getPriousorLaterDateFromDate:currentDate withMonth:-2];
    NSString *beginDate = [dateFormatter stringFromDate:monthagoData];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startD =[inputFormatter dateFromString:beginDate];
    NSDate *endD = [inputFormatter dateFromString:endDate];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitDay;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:startD toDate:endD options:0];
    return dateCom.day;
}


-(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}
//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//获取当地时间
- (NSString *)getAllCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//将字符串转成NSDate类型
- (NSDate *)dateAllFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"dd-MM-yyyy"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

//传入今天的时间，返回明天的时间
- (NSString *)GetTomorrowDay:(NSDate *)aDate andNum:(NSInteger)num {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]-num)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"dd-MM-yyyy"];
    return [dateday stringFromDate:beginningOfWeek];
}
- (NSString *)getTimes
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateTime];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:destDate];
    [components setDay:([components day]-0)];
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    
    return [dateday stringFromDate:beginningOfWeek];
}
- (void)createLeftBtn
{
 
    self.navigationItem.title = @"每月功率统计";
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
        [_tableView registerClass:[MouthElectricityRecordCell class]
           forCellReuseIdentifier:kMouthElectricityRecordCell];
        [_tableView registerClass:[InstantaneousPowerCell class]
           forCellReuseIdentifier:kInstantaneousPowerCell];
        [_tableView registerClass:[EveryDayCell class]
           forCellReuseIdentifier:kEveryDayCell];
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
    return 2;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (self.dataListArr.count != 0) {
        if (section == 0) {
            return 2;
        }else{
            return self.dataListArr.count;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.mouthCell =
            [tableView dequeueReusableCellWithIdentifier:kMouthElectricityRecordCell
                                            forIndexPath:indexPath];
            [self.mouthCell configWithData:self.dataListArr andWithTime:self.timeListArr];
            if (_selectNum != 0) {
                self.mouthCell.barChart.barChartView.contentOffset = CGPointMake((40+40*0.35)*_selectNum, self.mouthCell.barChart.barChartView.frame.origin.y-10);
            }else{
              self.mouthCell.barChart.barChartView.contentOffset = CGPointMake((40+40*0.35)*(self.allTimeListArr.count- _mouthNumber), self.mouthCell.barChart.barChartView.frame.origin.y-10);
            }
            
            return self.mouthCell;
        }else{
            InstantaneousPowerCell* cell =
            [tableView dequeueReusableCellWithIdentifier:kInstantaneousPowerCell
                                            forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configWithTitleName:Localized(@"tx_electricity_instantaneous_power") withDetailName:[NSString stringWithFormat:@"%dW",self.deviceStatus.engery]];
            return cell;
        }
    }else{
        EveryDayCell* cell =
        [tableView dequeueReusableCellWithIdentifier:kEveryDayCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int oldNum = [self.dataListArr[indexPath.row] intValue];
        NSNumber *dataNum = [NSNumber numberWithDouble:oldNum/3600.0];
        double wData = [dataNum doubleValue];
        [cell configWithTitleName:self.allTimeListArr[indexPath.row] withDetailName:[NSString stringWithFormat:@"%.2lf(W.h)",wData]];
        return cell;
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row < 3) {
            _selectNum = 0;
            
        }else if (indexPath.row > self.allTimeListArr.count-1-3){
            _selectNum = self.allTimeListArr.count- _mouthNumber;
            
        }else{
          _selectNum = indexPath.row -2;
            
        }
        
        self.mouthCell.barChart.barChartView.contentOffset = CGPointMake((40+40*0.35)*_selectNum, self.mouthCell.barChart.barChartView.frame.origin.y-10);
    }
    
    
}
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView
heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            return 330;
        }else{
            return 60;
        }
    }else{
        return 45;
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
