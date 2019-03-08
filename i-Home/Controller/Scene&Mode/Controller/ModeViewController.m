//
//  ModeViewController.m
//  i-Home
//
//  Created by Divella on 2019/3/6.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "ModeViewController.h"
#import "UIView+SDAutoLayout.h"

@interface ModeViewController ()

@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UILabel *tipLab;

@end

@implementation ModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.alpha = 0.8;
    [self createUI];
    
}

- (void)createUI{
    
    
    self.tipLab = [[UILabel alloc] init];
    [self.view addSubview:self.tipLab];
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.backgroundColor = [UIColor greenColor];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    self.cancelBtn.sd_layout
    .bottomSpaceToView(self.view, 15)
    .centerXEqualToView(self.view)
    .widthIs(45)
    .heightIs(45);

}

- (void)cancelBtnClick{
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end
