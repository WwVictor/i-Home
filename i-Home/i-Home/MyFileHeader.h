//
//  MyFileHeader.h
//  i-Home
//
//  Created by Frank on 2019/2/27.
//  Copyright © 2019 Victor. All rights reserved.
//

#ifndef MyFileHeader_h
#define MyFileHeader_h
#import "AddMoodButton.h"
#import "FMDatabaseModel.h"
#import "UIColor+YTExtension.h"
#import "Masonry.h"
#import "UIView+SDAutoLayout.h"
#import "SelectDeviceTypeController.h"
#import "TuYeTextField.h"
#import "SVProgressHUD.h"
#import "SVProgressHUD+DoAnythingAfter.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
// 状态栏高度
#define k_status_height   [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define k_nav_height      self.navigationController.navigationBar.height
// 顶部整体高度
#define k_top_height        (k_status_height + k_nav_height)

#define SafeAreaTopHeight (KScreenHeight >= 812.0 ? 88 : 64)
#define TopHeight (KScreenHeight >= 812.0 ? 44 : 20)
#define SafeAreaBottomHeight (KScreenHeight >= 812.0 ? 34 : 0)

#endif /* MyFileHeader_h */
