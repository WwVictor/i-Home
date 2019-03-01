//
//  SmartViewController.m
//  i-Home
//
//  Created by Divella on 2019/2/19.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "SmartViewController.h"
#import "UIView+SDAutoLayout.h"
#import "SmartTableVCell.h"
@interface SmartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *addNavBtn;//添加智能(导航栏)
@property (nonatomic,strong) UIButton *addbtn;//添加智能（主页无智能时按钮）
@property (nonatomic,strong) UIImageView *imageV;//无设备时背景图
@property (nonatomic,strong) UIButton *editBtn;//有智能模式时的编辑按钮
@property (nonatomic,strong) NSMutableArray *sceneArraylist;//场景数据源
@property (nonatomic,strong) UITableView *sceneTabview;//场景列表

@end

@implementation SmartViewController

- (NSMutableArray *)sceneArraylist{
    
    if (_sceneArraylist == nil) {
        _sceneArraylist = [[NSMutableArray alloc] init];
    }
    return _sceneArraylist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"智能模式";
    [self createUI];
    [self createTabview];
    [self loadData];
    
}

- (void)createUI{
    
    
    if (_sceneArraylist == nil) {
        //添加按钮
        self.addNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [self.addNavBtn addTarget:self action:@selector(addDeviceBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addNavBtn];
        self.addNavBtn.imageEdgeInsets = UIEdgeInsetsMake(8,8, 8, 8);
        [self.addNavBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
        [self.addNavBtn setBackgroundColor:[UIColor colorWithWhite:.4 alpha:.8]];
        self.addNavBtn.layer.cornerRadius = 18;
        self.addNavBtn.layer.masksToBounds = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addNavBtn];
        
        
        self.imageV = [[UIImageView alloc] init];
        [self.view addSubview:self.imageV];
        
        self.imageV.sd_layout
        .topSpaceToView(self.view, 49)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
        
        
        self.addbtn = [[UIButton alloc] init];
        self.addbtn.layer.shadowColor = [UIColor blackColor].CGColor;
        self.addbtn.layer.shadowOffset = CGSizeMake(5, 5);
        self.addbtn.layer.shadowRadius = 5;
        self.addbtn.layer.shadowOpacity = 0.5;
        self.addbtn.layer.cornerRadius = 6.0;
        self.addbtn.showsTouchWhenHighlighted = YES;
        [self.addbtn setTitle:@"添加智能" forState:UIControlStateNormal];
//        [self.addbtn setTitleColor:[UIColor colorWithRed:25.0/255.0 green:159.0/255.0 blue:225.0/255.0 alpha:0] forState:UIControlStateNormal];
        [self.addbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.addbtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.imageV addSubview:self.addbtn];
        self.addbtn.sd_layout
        .centerXEqualToView(self.imageV)
        .centerYEqualToView(self.imageV)
        .widthIs(150)
        .heightIs(45);
        
    }else{
        
        //添加按钮
        self.addNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [self.addNavBtn addTarget:self action:@selector(addDeviceBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.addNavBtn];
        self.addNavBtn.imageEdgeInsets = UIEdgeInsetsMake(8,8, 8, 8);
        [self.addNavBtn setImage:[UIImage imageNamed:@"加"] forState:UIControlStateNormal];
        [self.addNavBtn setBackgroundColor:[UIColor colorWithWhite:.4 alpha:.8]];
        self.addNavBtn.layer.cornerRadius = 18;
        self.addNavBtn.layer.masksToBounds = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.addNavBtn];
        //编辑按钮
        self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        [self.editBtn setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        [self.editBtn addTarget:self action:@selector(editBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.editBtn];
        self.editBtn.imageEdgeInsets = UIEdgeInsetsMake(8,8, 8, 8);
        [self.editBtn setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        [self.editBtn setBackgroundColor:[UIColor colorWithWhite:.4 alpha:.8]];
        self.editBtn.layer.cornerRadius = 18;
        self.editBtn.layer.masksToBounds = YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
        
    }
  
    
}
#pragma mark tableView 懒加载
- (UITableView *)createTabview{
    
    if (_sceneTabview == nil) {
        _sceneTabview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _sceneTabview.delegate = self;
        _sceneTabview.dataSource = self;
        _sceneTabview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sceneTabview.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:self.sceneTabview];
        self.sceneTabview.sd_layout
        .topEqualToView(self.view)
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomEqualToView(self.view);
    }
    return _sceneTabview;
}

- (void)addDeviceBtnAction{
    
    
}


- (void)editBtnAction{
    
    
}

- (void)loadData{
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithObjects:@[@"",@"起床",@1],@[@"",@"睡觉",@1],@[@"",@"喝茶",@1],@[@"",@"会议",@1] ,nil];
    NSMutableArray *arr2 = [NSMutableArray arrayWithObjects:@[@"",@"添加场景"], nil];
    self.sceneArraylist = [NSMutableArray arrayWithObjects:arr1,arr2, nil];
    [self.sceneTabview reloadData];
    
}

#pragma mark UITableViewDelegate and UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.sceneArraylist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.sceneArraylist[section];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"sceneCellId";
    SmartTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SmartTableVCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
      
        
        NSString *str =self.sceneArraylist[indexPath.section][indexPath.row][0];
        cell.imageView.image =[UIImage imageNamed:str];
        
        cell.titleLab.text = self.sceneArraylist[indexPath.section][indexPath.row][1];
        [cell.SwitchBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }else {
        NSString *str =self.sceneArraylist[indexPath.section][indexPath.row][0];
        cell.imageView.image =[UIImage imageNamed:str];
        cell.titleLab.text = self.sceneArraylist[indexPath.section][indexPath.row][1];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
    }else{
        
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
