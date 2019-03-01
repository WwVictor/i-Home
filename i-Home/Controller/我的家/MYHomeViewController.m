//
//  MYHomeViewController.m
//  i-Home
//
//  Created by Divella on 2019/2/19.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "MYHomeViewController.h"
#import "RoomManagementController.h"
#import "YBPopupMenu.h"
#import "RoomControl.h"
#import "Masonry.h"
#import "MyFileHeader.h"
#import "SGPagingView.h"
#import "DeviceListViewController.h"
#define ADDSCENEBTTON_TAG 20180920
#define TITLES @[@"我的家",@"Longtooth", @"家居管理"]
#define ICONS  @[@"room_list",@"room_list",@"room_edit"]
@interface MYHomeViewController ()<YBPopupMenuDelegate,SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;
@property (nonatomic, strong)YBPopupMenu *popupMenu;
@property (nonatomic, strong)RoomControl *addHomeButton;
@property (nonatomic, strong)UIButton *addDeviceBtn;
@property (nonatomic, strong) NSMutableArray *homeListArr;
@property (nonatomic, strong) NSMutableArray *homeIconArr;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong)UIScrollView *bgScrollView;
@property (nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic,strong)NSMutableArray*titleArr;
@end

@implementation MYHomeViewController
{
    NSInteger _selectType;
}
#pragma mark-懒加载
- (NSMutableArray *)titleArr
{
    if (_titleArr == nil) {
        _titleArr = [NSMutableArray array];
        
    }
    return _titleArr;
}
- (NSMutableArray *)homeListArr
{
    if (_homeListArr == nil) {
        _homeListArr = [NSMutableArray array];
        
    }
    return _homeListArr;
}
- (NSMutableArray *)homeIconArr
{
    if (_homeIconArr == nil) {
        _homeIconArr = [NSMutableArray array];
        
    }
    return _homeIconArr;
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
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setUI];
}

- (void)setUI{
    [self createNav];
    [self createBgScrollView];
    [self createBottomView];
}
- (void)createBottomView
{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
//    [self.bgScrollView addSubview:headerView];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorHeight = 3;
    configure.indicatorCornerRadius = 1.5;
    configure.indicatorAdditionalWidth = 1; // 说明：指示器额外增加的宽度，不设置，指示器宽度为标题文字宽度；若设置无限大，则指示器宽度为按钮宽度
    configure.showBottomSeparator = NO;
    if (@available(iOS 8.2, *)) {
        configure.titleSelectedFont = [UIFont systemFontOfSize:21.0 weight:UIFontWeightMedium];
        configure.titleFont = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    } else {
        // Fallback on earlier versions
        configure.titleSelectedFont = [UIFont systemFontOfSize:21.0];
        configure.titleFont = [UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium];
    }
    configure.titleColor = [UIColor lightGrayColor];
    configure.titleSelectedColor = [UIColor blackColor];
    configure.indicatorColor = [UIColor colorWithHexString:@"28a7ff"];
        
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-30-15, 240+20+7, 30, 30)];
    rightBtn.backgroundColor = [UIColor whiteColor];
    [rightBtn setImage:[UIImage imageNamed:@"gengduo"] forState:UIControlStateNormal];
    rightBtn.layer.cornerRadius = 3;
    rightBtn.layer.masksToBounds = YES;
    [self.bgScrollView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.titleArr = [NSMutableArray arrayWithObjects:@"所有设备",@"客厅",@"主卧",@"书房",@"厨房",@"餐厅",@"洗漱间", nil];
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(15, 240+20, KScreenWidth-30-15-15-10, 44) delegate:self titleNames:self.titleArr configure:configure];
    [self.bgScrollView addSubview:_pageTitleView];
    
    NSMutableArray *childArr = [NSMutableArray array];
    for (int i=0; i<self.titleArr.count; i++) {
        //            homePageHeaderModel *model = self.dataArr[i];
        DeviceListViewController *vc = [[DeviceListViewController alloc]init];
        //            vc.pageModel = self.dataArr[i];
        //            vc.arr = model.releaseActivities;
        [childArr addObject:vc];
    }
    
    CGFloat ContentCollectionViewHeight = KScreenHeight - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), KScreenWidth, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.bgScrollView addSubview:_pageContentScrollView];
}
- (void)rightBtnClick
{
    RoomManagementController *selctCtrl = [[RoomManagementController alloc] init];
    [self.navigationController pushViewController:selctCtrl animated:YES];
}
- (void)createBgScrollView
{
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    self.bgScrollView = [[UIScrollView alloc] init];
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight-SafeAreaTopHeight);
    self.bgScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .widthIs(KScreenWidth)
    .heightIs(KScreenHeight-SafeAreaTopHeight-SafeAreaBottomHeight-45);
   
    if (@available(iOS 11.0, *)) {
        self.bgScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
    [self.bgScrollView addSubview:headerView];
    //        headerView.backgroundColor = [UIColor lightGrayColor];
    //添加头视图的内容
    NSArray *titleIcons = @[@"在线",@"离线",@"升级"];
    for (int i = 0; i < 3; i++) {
        //添加场景按钮
        AddMoodButton *btn = [[AddMoodButton alloc] initWithFrame:CGRectMake(15+(60+15)*i, 20, 60, 60+25)];
        btn.tag = ADDSCENEBTTON_TAG +i;
        btn.iconBtn.backgroundColor = [UIColor colorWithHexString:@"28a7ff"];
        //            UIImage *iconImage = [UIImage imageNamed:sceneInfo.icon_path];
        //            [btn.iconBtn setImage:[LYTools imageWithColor:[UIColor colorWithHexString:@"008DD4"] withImage:iconImage] forState:UIControlStateNormal];
        
        //            [btn.iconBtn setImage: forState:UIControlStateNormal];
        //                [btn.iconBtn setImage:[UIImage imageNamed:sceneInfo.icon_path] forState:UIControlStateNormal] ;
        btn.tintColor = [UIColor redColor];
        [btn.iconBtn setImageEdgeInsets:UIEdgeInsetsMake(60/3, 60/3, 60/3, 60/3)];
        //                btn.titleImageView.image = [UIImage imageNamed:iconsArr[i]];
        btn.titleLabel.text = titleIcons[i];
        [btn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:btn];
    }
    CGFloat icons_width = (KScreenWidth-20*2-10)/2.0;
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(6*icons_width+5*10+20*2, 70);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:self.scrollView];
    self.scrollView.sd_layout
    .leftSpaceToView(headerView, 0)
    .bottomSpaceToView(headerView, 40)
    .widthIs(KScreenWidth)
    .heightIs(70);
    for (int i = 0; i < 6; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor colorWithHexString:@"28a7ff"];
        [btn setTitle:@"睡觉" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.frame = CGRectMake(20+(icons_width +10)*i, 10, icons_width, 50);
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.tag = 1000+i;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(moodBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (@available(iOS 11.0, *)) {
        
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    UIView  *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, 239.5, KScreenWidth-40, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"999999"];
    [headerView addSubview:lineView];
}
- (void)BtnAction:(AddMoodButton *)btn
{
    
}
- (void)moodBtnAction:(UIButton *)btn
{
    
}

- (void)createNav{
    
    self.addHomeButton = [[RoomControl alloc] initWithFrame:CGRectMake(0, 0, [self widthLabelWithModel:@"添加家居"]+15, 30)];
    self.addHomeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.addHomeButton.titleLabel.text = @"添加家居";
    self.addHomeButton.titleImageView.image = [UIImage imageNamed:@"指示图标"];
    [self.addHomeButton addTarget:self action:@selector(addHomeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addHomeButton];
    
    self.addDeviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [self.addDeviceBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
    [self.addDeviceBtn addTarget:self action:@selector(addDeviceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addDeviceBtn];
    
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevice)];
//    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)addDeviceBtnClick
{
    _selectType = 1;
    NSArray *titles = @[@"添加设备",@"扫一扫"];
    NSArray *icons = @[@"room_list",@"room_edit"];
    [YBPopupMenu showRelyOnView:self.addDeviceBtn titles:titles icons:icons menuWidth:200 delegate:self];
}
- (void)addHomeButtonClick
{
    _selectType = 0;
//     [YBPopupMenu showRelyOnView:self.addHomeButton titles:self.homeListArr icons:self.homeIconArr menuWidth:200 delegate:self];
    [YBPopupMenu showRelyOnView:self.addHomeButton titles:TITLES icons:ICONS menuWidth:200 delegate:self];
}


- (void)changeSelectedIndex:(NSNotification *)noti {
    _pageTitleView.resetSelectedIndex = [noti.object integerValue];
}



- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView index:(NSInteger)index {
    if (index == 1 || index == 5) {
        [_pageTitleView removeBadgeForIndex:index];
    }
}




- (UIImage  *)xy_noDataViewImage
{
    return [UIImage imageNamed:@"缺省-暂无"];
}
- (NSString *)xy_noDataViewMessage
{
    return @"暂无数据";
}

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
    if (_selectType == 1) {
        if (index == 0) {
            SelectDeviceTypeController *selctCtrl = [[SelectDeviceTypeController alloc] init];
            [self.navigationController pushViewController:selctCtrl animated:YES];
        }
    }
}

- (void)ybPopupMenuBeganDismiss
{
    if (self.view.isFirstResponder) {
        [self.view resignFirstResponder];
    }
}

- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index
{
    if (ybPopupMenu.tag != 100) {
        return nil;
    }
//    static NSString * identifier = @"customCell";
//    CustomTestCell * cell = [ybPopupMenu.tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomTestCell" owner:self options:nil] firstObject];
//    }
//    RoomInformationModel *roomModel = self.roomListArr[index];
//    cell.titleLabel.text = roomModel.name;
//    cell.iconImageView.image = [UIImage imageNamed:self.roomIconArr[index]];
    
    return nil;
}

#pragma mark-字体宽度自适应
- (CGFloat)widthLabelWithModel:(NSString *)titleString
{
    CGSize size = CGSizeMake(self.view.bounds.size.width, MAXFLOAT);
    CGRect rect = [titleString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil];
    return rect.size.width+5;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
