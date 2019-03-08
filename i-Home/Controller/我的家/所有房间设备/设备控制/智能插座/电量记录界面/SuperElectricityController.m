//
//  SuperElectricityController.m
//  iThing
//
//  Created by Frank on 2019/1/4.
//  Copyright © 2019 Frank. All rights reserved.
//

#import "SuperElectricityController.h"
#import "ElectricityRecordController.h"
#import "YearElectricityController.h"
#import "MouthElectricityController.h"
@interface SuperElectricityController ()

@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) ElectricityRecordController *dayCtrl;
@property (nonatomic, strong) MouthElectricityController *mouthCtrl;
@property (nonatomic, strong) YearElectricityController *yearCtrl;
@end

@implementation SuperElectricityController
{
    UIScrollView *scrollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createLeftBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createSegmenteCtrl];
}
- (void)createLeftBtn
{
    self.navigationItem.title = Localized(@"tx_electricity_statistics");
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = itemleft;
}
- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createSegmenteCtrl
{
    NSArray * segmentArray = @[Localized(@"tx_electricity_daily_statistics"),Localized(@"tx_electricity_monthly_statistics"),Localized(@"tx_electricity_annual_statistics")];
    self.segment = [[UISegmentedControl alloc]initWithItems:segmentArray];
//    self.segment.backgroundColor = [UIColor colorWithHexString:@"848587"];
    [self.view addSubview:self.segment];
    self.segment.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(self.view, SafeAreaTopHeight+5)
    .heightIs(30);
    self.segment.selectedSegmentIndex = 0;
//    self.segment.tintColor = [UIColor whiteColor];
//    UIColor *segmentColor = [UIColor blackColor];
//    NSDictionary *colorAttr = [NSDictionary dictionaryWithObjectsAndKeys:segmentColor, NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
//    [self.segment setTitleTextAttributes:colorAttr forState:UIControlStateNormal];
//    self.segment.layer.cornerRadius = 10;
//    self.segment.layer.masksToBounds = YES;
//    self.segment.layer.borderColor = [UIColor blueColor].CGColor;
//    self.segment.layer.borderWidth = 1;
    [self.segment addTarget:self action:@selector(segmentSelect:) forControlEvents:UIControlEventValueChanged];
    //scroView
//    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,SafeAreaTopHeight+40,KScreenWidth,KScreenHeight-SafeAreaTopHeight-35)];
//    scrollView.pagingEnabled = YES;
//    scrollView.scrollEnabled = NO;
//    scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight-SafeAreaTopHeight-40);
//    [self.view addSubview:scrollView];
    //把页面添加到scroView的三个页面
    self.dayCtrl = [[ElectricityRecordController alloc]init];
    self.dayCtrl.deviceInfo = self.deviceInfo;
    self.dayCtrl.deviceStatus = self.deviceStatus;
    self.dayCtrl.view.frame = CGRectMake(0, SafeAreaTopHeight+40, KScreenWidth, KScreenHeight-SafeAreaTopHeight-40);
    [self addChildViewController:self.dayCtrl];
    [self.view addSubview:self.dayCtrl.view];
    
//    MouthElectricityController *two = [[MouthElectricityController alloc]init];
//    two.view.frame = CGRectMake(KScreenWidth * 1, 0, KScreenWidth, KScreenHeight-SafeAreaTopHeight-40);
//    two.deviceInfo = self.deviceInfo;
//    two.deviceStatus = self.deviceStatus;
//    [self addChildViewController:two];
//    [scrollView addSubview:two.view];
//    YearElectricityController *three = [[YearElectricityController alloc]init];
//    three.view.frame = CGRectMake(KScreenWidth * 2, 0, KScreenWidth, KScreenHeight-SafeAreaTopHeight-40);
//    three.deviceInfo = self.deviceInfo;
//    three.deviceStatus = self.deviceStatus;
//    [self addChildViewController:three];
//
//    [scrollView addSubview:three.view];
}
#pragma mark - segment选择按钮事件
-(void)segmentSelect:(UISegmentedControl*)seg{
    if (self.dayCtrl != NULL) {
        [self.dayCtrl.view removeFromSuperview];
        [self.dayCtrl removeFromParentViewController];
    }
    if (self.mouthCtrl != NULL) {
        [self.mouthCtrl.view removeFromSuperview];
        [self.mouthCtrl removeFromParentViewController];
    }
    if (self.yearCtrl != NULL) {
        [self.yearCtrl.view removeFromSuperview];
        [self.yearCtrl removeFromParentViewController];
    }
    switch (seg.selectedSegmentIndex) {
        case 0:
            self.dayCtrl = [[ElectricityRecordController alloc]init];
            self.dayCtrl.deviceInfo = self.deviceInfo;
            self.dayCtrl.deviceStatus = self.deviceStatus;
            self.dayCtrl.view.frame = CGRectMake(0, SafeAreaTopHeight+40, KScreenWidth, KScreenHeight-SafeAreaTopHeight-40);
            [self addChildViewController:self.dayCtrl];
            [self.view addSubview:self.dayCtrl.view];
            break;
        case 1:
            self.mouthCtrl = [[MouthElectricityController alloc]init];
            self.mouthCtrl.deviceInfo = self.deviceInfo;
            self.mouthCtrl.deviceStatus = self.deviceStatus;
            self.mouthCtrl.view.frame = CGRectMake(0, SafeAreaTopHeight+40, KScreenWidth, KScreenHeight-SafeAreaTopHeight-40);
            [self addChildViewController:self.mouthCtrl];
            [self.view addSubview:self.mouthCtrl.view];
            break;
        case 2:
            self.yearCtrl = [[YearElectricityController alloc]init];
            self.yearCtrl.deviceInfo = self.deviceInfo;
            self.yearCtrl.deviceStatus = self.deviceStatus;
            self.yearCtrl.view.frame = CGRectMake(0, SafeAreaTopHeight+40, KScreenWidth, KScreenHeight-SafeAreaTopHeight-40);
            [self addChildViewController:self.yearCtrl];
            [self.view addSubview:self.yearCtrl.view];
            break;
        default:
            break;
    }
    
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
