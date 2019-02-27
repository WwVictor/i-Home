//
//  MYHomeViewController.m
//  i-Home
//
//  Created by Divella on 2019/2/19.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "MYHomeViewController.h"
#import "YBPopupMenu.h"
#import "RoomControl.h"
#import "Masonry.h"
#import "MyFileHeader.h"
#define ADDSCENEBTTON_TAG 20180920
#define TITLES @[@"我的家",@"Longtooth", @"家居管理"]
#define ICONS  @[@"room_list",@"room_list",@"room_edit"]
@interface MYHomeViewController ()<YBPopupMenuDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)YBPopupMenu *popupMenu;
@property (nonatomic, strong)RoomControl *addHomeButton;
@property (nonatomic, strong)UIButton *addDeviceBtn;
@property (nonatomic, strong) NSMutableArray *homeListArr;
@property (nonatomic, strong) NSMutableArray *homeIconArr;
@property (nonatomic, strong) UITableView *bgTableView;
@property (nonatomic, strong) UITableView *deviceListTableView;
@property (nonatomic, strong) NSMutableArray *deviceListArray;
@property (nonatomic, strong)UIScrollView *scrollView;
@end

@implementation MYHomeViewController
#pragma mark-懒加载
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
    [self setUI];
}

- (void)setUI{
    [self createNav];
    [self createBgTableView];
}
#pragma mark - 创建tableview
-(UITableView *)bgTableView
{
    if (_bgTableView == nil) {
        _bgTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _bgTableView.backgroundColor = [UIColor clearColor];
        _bgTableView.delegate = self;
        _bgTableView.dataSource = self;
        _bgTableView.tableFooterView = [UIView new];
        _bgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        _listTableView.sectionFooterHeight = 20;
//        [_listTableView registerNib:[UINib nibWithNibName:NSStringFromClass([CurrentParkCell class]) bundle:nil] forCellReuseIdentifier:cellID];
        [self.view addSubview:_bgTableView];
        [_bgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view);
            make.right.left.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view);
        }];
        
    }
    return _bgTableView;
}
- (void)createBgTableView
{
    [self bgTableView];
}



- (void)createNav{
    
    self.addHomeButton = [[RoomControl alloc] initWithFrame:CGRectMake(0, 0, [self widthLabelWithModel:@"添加家居"]+15, 30)];
    self.addHomeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.addHomeButton.titleLabel.text = @"添加家居";
    self.addHomeButton.titleImageView.image = [UIImage imageNamed:@"指示图标"];
    [self.addHomeButton addTarget:self action:@selector(addHomeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addHomeButton];
    
}
- (void)addHomeButtonClick
{
//     [YBPopupMenu showRelyOnView:self.addHomeButton titles:self.homeListArr icons:self.homeIconArr menuWidth:200 delegate:self];
    [YBPopupMenu showRelyOnView:self.addHomeButton titles:TITLES icons:ICONS menuWidth:200 delegate:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.bgTableView) {
        return 1;
    }else{
        return 1;
    }
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.bgTableView) {
        return 1;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.bgTableView) {
        static NSString *cellId = @"bgTableViewCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        return cell;
    }else{
        static NSString *cellId = @"bgTableViewCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.bgTableView) {
        return 185;
    }else{
        return 185;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 15)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.bgTableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
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
        return headerView;
    }else{
     return nil;
    }
    
}
- (void)BtnAction:(AddMoodButton *)btn
{
    
}
- (void)moodBtnAction:(UIButton *)btn
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.bgTableView) {
        return 240;
    }else{
        return 0;
    }
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

#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    
    //推荐回调
    NSLog(@"点击了 %@ 选项",ybPopupMenu.titles[index]);
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
