//
//  MainViewController.m
//  i-Home
//
//  Created by Divella on 2019/2/19.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "MainViewController.h"
#import "MYHomeViewController.h"
#import "SmartViewController.h"
#import "SettingViewController.h"
#import "LTNavigationController.h"
#import "LoadingView.h"
#import "CommonTools.h"
#import "SetGesturePwdController.h"
#import "CheckGesturePwdController.h"


@interface MainViewController ()<LoadingViewDelegate>

@property (nonatomic,strong)MYHomeViewController *myHomeViewController;
@property (nonatomic,strong)SmartViewController *smartViewController;
@property (nonatomic,strong)SettingViewController *settingViewController;
@property (nonatomic,strong)LoadingView *loadingView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 出现loading页面
    self.loadingView = [[LoadingView alloc] init];
    self.loadingView.delegate = self;
    [self.view addSubview:self.loadingView];
    [[UITabBar appearance] setTranslucent:NO];
    
    [self addChildViewControllers];
    
}
- (void)loadCompleted {
    
    [self checkPassword];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.loadingView removeFromSuperview];
        self.loadingView = nil;
    });
    
}
- (void)addChildViewControllers{
    
    self.myHomeViewController = [[MYHomeViewController alloc] init];
    self.smartViewController = [[SmartViewController alloc] init];
    self.settingViewController = [[SettingViewController alloc] init];
    [self addChildViewController:self.myHomeViewController title:@"家" imageName:@""];
    [self addChildViewController:self.smartViewController title:@"智能场景" imageName:@""];
    [self addChildViewController:self.settingViewController title:@"设置" imageName:@""];
    
}
//添加子控制器
- (void)addChildViewController:(UIViewController *)childController title:(NSString *)title imageName:(NSString *)imageName {
    // 设置标题
    childController.title = title;
    
    // 通过 AttributeText 设置字体属性
    // 设置字体颜色
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    
    // 设置字体大小
    // [childController.tabBarItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} forState:UIControlStateNormal];
    
    // 设置图像
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSString *selectedImageName = [NSString stringWithFormat:@"%@_selected", imageName];
    
    childController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 添加子控制器
    LTNavigationController *navigationController = [[LTNavigationController alloc] initWithRootViewController:childController];
    
    [self addChildViewController:navigationController];
    
}

- (void)checkPassword{
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:PASSWORDCODE]) {
        CheckGesturePwdController *checkPwdVC = [[CheckGesturePwdController alloc] init];
        [self presentViewController:checkPwdVC animated:YES completion:nil];
        
    } else {
       
        SetGesturePwdController *setPwdVC = [[SetGesturePwdController alloc] init];
        [self presentViewController:setPwdVC animated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
