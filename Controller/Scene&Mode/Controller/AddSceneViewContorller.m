//
//  AddSceneViewContorller.m
//  i-Home
//
//  Created by Divella on 2019/3/1.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "AddSceneViewContorller.h"
#import "UIView+SDAutoLayout.h"
#import "SceneCollectionCell.h"
#import "ActionViewCell.h"
#import "MyFileHeader.h"
#import "ChooseActionController.h"

@interface AddSceneViewContorller ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UITextField *editSceneName;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UICollectionView *collectView;
@property (nonatomic,strong) UITableView *actionView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSMutableArray *arrDataSource;
@property (nonatomic,strong) UIButton *actionBtn;
@property (nonatomic,strong) UILabel *tipLab;

@end

@implementation AddSceneViewContorller

#pragma mark - 懒加载

- (NSMutableArray *)arrDataSource{
    if (_arrDataSource == nil) {
        _arrDataSource = [[NSMutableArray alloc] init];
    }
    return _arrDataSource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"新增场景";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
    [self createCollectionView];
    [self actionView];
    
}

- (void)createUI{
    
    self.backBtn = [[UIButton alloc] init];
    [self.backBtn addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    [self.backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    self.saveBtn = [[UIButton alloc] init];
    [self.saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    
    self.editSceneName = [[UITextField alloc] init];
    self.editSceneName.layer.cornerRadius = 10.0;
    self.editSceneName.placeholder = @"场景名称";
    self.editSceneName.layer.borderWidth=1.0f;
    self.editSceneName.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 60)];
    self.editSceneName.leftViewMode = UITextFieldViewModeAlways;
    self.editSceneName.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    [self.view addSubview:self.editSceneName];
    self.editSceneName.sd_layout
    .topSpaceToView(self.view, 70)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(40);
    
    
}

- (UICollectionView *)createCollectionView{
    
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(80, 40);
        layout.minimumLineSpacing = 15;//最小行间距
        layout.minimumInteritemSpacing = 0;//最小列间距
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);//上左下右
        self.collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectView.backgroundColor = [UIColor lightGrayColor];
        self.collectView.delegate =self;
        self.collectView.dataSource = self;
        self.collectView.layer.cornerRadius = 15.0;
        [self.collectView registerClass:[SceneCollectionCell class] forCellWithReuseIdentifier:@"ReuseCell"];
        [self.view addSubview:self.collectView];
        self.collectView.sd_layout
        .topSpaceToView(self.editSceneName, 15)
        .leftSpaceToView(self.view, 15)
        .rightSpaceToView(self.view, 15)
        .heightIs (180);
    }
    
    return _collectView;
    
}

- (UITableView *)actionView{
    if (_actionView == nil) {
        
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        self.headView.layer.cornerRadius = 15.0;
        self.headView.backgroundColor = [UIColor grayColor];
        self.actionBtn = [[UIButton alloc] init];
        self.actionBtn.backgroundColor = [UIColor redColor];
        [self.actionBtn addTarget:self action:@selector(actionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:self.actionBtn];
        self.actionBtn.sd_layout
        .rightSpaceToView(self.headView, 15)
        .centerYEqualToView(self.headView)
        .widthIs(25)
        .heightIs(25);
        
        self.tipLab = [[UILabel alloc] init];
        self.tipLab.text = @"执行以下动作";
        [self.headView addSubview:self.tipLab];
        self.tipLab.sd_layout
        .leftSpaceToView(self.headView, 15)
        .centerYEqualToView(self.headView)
        .widthIs(150)
        .heightIs(20);
        
        self.actionView = [[UITableView alloc] init];
        self.actionView.delegate = self;
        self.actionView.dataSource = self;
        self.actionView.layer.cornerRadius = 15.0;
        self.actionView.backgroundColor = [UIColor lightGrayColor];
        self.actionView.tableHeaderView = self.headView;
        self.actionView.separatorStyle = UITableViewCellEditingStyleNone;
        [self.view addSubview:self.actionView];
        
        self.actionView.sd_layout
        .topSpaceToView(self.collectView, 15)
        .leftSpaceToView(self.view, 15)
        .rightSpaceToView(self.view, 15)
        .bottomSpaceToView(self.view, 30);
    
    }
    
    return _actionView;
}

- (void)BackBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)saveBtnClick{
    
    
}

- (void)actionBtnClick{
    
    ChooseActionController *actView = [[ChooseActionController alloc] init];
    [self.navigationController pushViewController:actView animated:YES];
}

#pragma Mark CollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SceneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReuseCell" forIndexPath:indexPath];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITabbleViewDelegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"ActionCell";
    ActionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ActionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

@end
