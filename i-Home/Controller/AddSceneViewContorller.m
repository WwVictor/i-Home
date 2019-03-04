//
//  AddSceneViewContorller.m
//  i-Home
//
//  Created by Divella on 2019/3/1.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "AddSceneViewContorller.h"

@interface AddSceneViewContorller ()
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UITextField *editSceneName;
@property (nonatomic,strong) UIImageView *imageV;

@end

@implementation AddSceneViewContorller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)createUI{
    
    self.backBtn = [[UIButton alloc] init];
    [self.backBtn addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
}

- (void)BackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
