//
//  AppDelegate.h
//  i-Home
//
//  Created by Divella on 2019/2/18.
//  Copyright © 2019年 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSMutableArray *deviceVersionArray;
    NSMutableArray *updateDeviceArray;
    NSInteger updateNumber;
    NSMutableDictionary *concurrentHashMap;/*缓存注册的本地服务地址*/
    BOOL isLogin;
    NSString *repeatWeek;
}
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *deviceVersionArray;
@property (strong, nonatomic) NSMutableArray *updateDeviceArray;
@property (assign, nonatomic) NSInteger updateNumber;
@property (nonatomic, retain) NSMutableDictionary *concurrentHashMap;
@property (nonatomic,assign)BOOL isLogin;
@property (strong, nonatomic) NSString *repeatWeek;
@end

