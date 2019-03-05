//
//  AppDelegate.m
//  i-Home
//
//  Created by Divella on 2019/2/18.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MYHomeViewController.h"
#import "SmartViewController.h"
#import "SettingViewController.h"
#import "LTNavigationController.h"
#import "SetGesturePwdController.h"
#import "CheckGesturePwdController.h"
#import "MyFileHeader.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize deviceVersionArray,updateNumber,updateDeviceArray,concurrentHashMap,isLogin,repeatWeek;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //启动注册长牙
    [self registerLongTooth];
//    [self checkPassword];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[MainViewController alloc] init];
    [self.window makeKeyAndVisible];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        }else if ([language hasPrefix:@"zh-Hant"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:@"appLanguage"];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
        }
    }
    return YES;
    
}

//- (void)checkPassword{
//
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:PASSWORDCODE]) {
//        CheckGesturePwdController *checkPwdVC = [[CheckGesturePwdController alloc] init];
//        [self presentViewController:checkPwdVC animated:YES completion:nil];
//
//    } else {
//
//        SetGesturePwdController *setPwdVC = [[SetGesturePwdController alloc] init];
//        [self presentViewController:setPwdVC animated:YES completion:nil];
//
//    }
//}

//启动注册长牙
- (void)registerLongTooth{
    
    [[LongToothHandler sharedInstance] registeredLongToothHost:LONGTOOTH_HOST port:LONGTOOTH_PORT devid:LONGTOOTH_DEVELOPER_ID appid:LONGTOOTH_APP_ID appkey:LONGTOOTH_APP_KEY block:^(NSInteger event) {
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
