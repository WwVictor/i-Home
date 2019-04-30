//
//  LTNavigationController.m
//  i-Home
//
//  Created by Divella on 2019/2/19.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "LTNavigationController.h"
#import "UIColor+YTExtension.h"
#import "UIBarButtonItem+YTExtension.h"
#import "UIBarButtonItem+extension.h"
#import "UITabBar+Badge.h"
@interface LTNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation LTNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [UINavigationBar appearance].tintColor = [UIColor whiteColor];
        [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
        [UINavigationBar appearance].barTintColor = [UIColor colorWithHexString:@"28a7ff"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) {
//        NSString *controllerTitle = [self.childViewControllers objectAtIndex:self.childViewControllers.count-1].title;
//        NSString *title = [NSString stringWithFormat:@" %@", controllerTitle];
        // 左按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"arrow_title_goback" highImageName:@"arrow_title_goback" target:self action:@selector(goBack)];
        // 隐藏底部的 TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UIGestureRecognizerDelegate
/// 手势识别将要开始
///
/// @param gestureRecognizer 手势识别
///
/// @return 返回 NO，放弃当前识别到的手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 如果是根视图控制器，则不支持手势返回
    return self.childViewControllers.count > 1 ? YES : NO;
}

#pragma mark - 监听方法
/// 返回上级视图控制器
- (void)goBack {
    [self popViewControllerAnimated:YES];
}

#pragma mark - StatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBadgeTag:(BOOL)show {
    NSInteger index = [self.tabBarController.tabBar.items indexOfObject:self.tabBarItem];
    [self.tabBarController.tabBar setBadgeStyle:show?BadgeStyleRedDot:BadgeStyleNone value:0 atIndex:index];
}





@end
