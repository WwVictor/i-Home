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
#import "LongToothHandler.h"
#import "FMDatabaseModel.h"
#import "DBManager.h"
#import "UIView+Extension.h"
#import "NSString+Extension.h"
#import "MJExtension.h"
#import "NSObject+MJCoding.h"
#import "NSDate+Extension.h"
#import "JohnAlertManager.h"
#import "SVProgressHUD+DoAnythingAfter.h"
#import "MJRefresh.h"
#import "GetDeviceNetworkIP.h"
#import "DeviceTypeManager.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import "CommonTools.h"
//设备类型
typedef NS_ENUM(NSUInteger, iThingDeviceType) {
    ACCESSORY_CATEGORY_UNKNOWN = 0,
    ACCESSORY_CATEGORY_OTHER = 1,
    ACCESSORY_CATEGORY_BRIDGE = 2,
    ACCESSORY_CATEGORY_FAN = 3,
    ACCESSORY_CATEGORY_GARAGE = 4,
    ACCESSORY_CATEGORY_LIGHTBULB = 5,
    ACCESSORY_CATEGORY_DOORLOCK = 6,
    ACCESSORY_CATEGORY_OUTLET = 7,
    ACCESSORY_CATEGORY_SWITCH = 8,
    ACCESSORY_CATEGORY_THERMOSTAT = 9,
    ACCESSORY_CATEGORY_SENSOR = 10,
    ACCESSORY_CATEGORY_SECURITY_SYSTEM = 11,
    ACCESSORY_CATEGORY_DOOR = 12,
    ACCESSORY_CATEGORY_WINDOW = 13,
    ACCESSORY_CATEGORY_WINDOW_COVER = 14,
    ACCESSORY_CATEGORY_PROGRAMMABLE_SWITCH = 15,
    ACCESSORY_CATEGORY_RANGE_EXTENDER = 16,
    ACCESSORY_CATEGORY_IP_CAMERA = 17,
    ACCESSORY_CATEGORY_VIDEO = 18,
    ACCESSORY_CATEGORY_AIR_PURIFIER = 19,
    ACCESSORY_CATEGORY_AIR_HEATER = 20,
    ACCESSORY_CATEGORY_AIR_CONDITIONER = 21,
    ACCESSORY_CATEGORY_AIR_HUMIDIFIER = 22,
    ACCESSORY_CATEGORY_AIR_DEHUMIDIFIER = 23,
    ACCESSORY_CATEGORY_RESERVED = 24,
    
};
#define DimmerTabel @"ltdimmers"
#define BrightTempTabel @"ltbrighttemps"
#define BrightRBGTabel @"ltbrightrgbs"
#define RGBTabel @"ltrgbs"
#define SocketTabel @"ltsockets"
#define SwitchTabel @"ltswitchs"
#define CurtainTabel @"ltcurtains"
#define AirCondiTabel @"ltairconditioners"


#define SceneDimmerTabel @"scenedimmers"
#define SceneBrightTempTabel @"scenebrighttemps"
#define SceneBrightRBGTabel @"scenebrightrgbs"
#define SceneRGBTabel @"scenergbs"
#define SceneSocketTabel @"scenesockets"
#define SceneSwitchTabel @"sceneswitchs"
#define SceneCurtainTabel @"scenecurtains"
#define SceneAirCondiTabel @"sceneairconditioners"

//#import "DeviceManager.h"
/** 代码切换语言 **/
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Language"]
#define kRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//#define kNavBar_color kRGB(19, 153, 231)
#define kNavBar_color kRGB(67, 130, 228)
#define kNavBar_tintColor kRGB(255, 255, 255)
#define kBottomViewBgColor kRGB(255, 255, 255)
#define kDoneButton_textColor kRGB(255, 255, 255)
#define kBottomBtnsNormalTitleColor kRGB(80, 180, 234)
#define kBottomBtnsDisableTitleColor kRGB(200, 200, 200)
#define zl_weakify(var) __weak typeof(var) weakSelf = var
#define zl_strongify(var) __strong typeof(var) strongSelf = var
#define HEXCOLOR(hex, alp) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:alp]
#define ZL_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define ZL_IS_IPHONE_X (ZL_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0f)
#define ZL_SafeAreaBottom (ZL_IS_IPHONE_X ? 34 : 0)
#define kZLPhotoBrowserBundle [NSBundle bundleForClass:[self class]]
// 图片路径
#define kZLPhotoBrowserSrcName(file) [@"ZLPhotoBrowser.bundle" stringByAppendingPathComponent:file]
#define kZLPhotoBrowserFrameworkSrcName(file) [@"Frameworks/ZLPhotoBrowser.framework/ZLPhotoBrowser.bundle" stringByAppendingPathComponent:file]
#define kViewWidth [[UIScreen mainScreen] bounds].size.width
#define kViewHeight [[UIScreen mainScreen] bounds].size.height
//app名字
#define kAPPName [[NSBundle mainBundle].infoDictionary valueForKey:@"CFBundleDisplayName"]
//自定义图片名称存于plist中的key
#define ZLCustomImageNames @"ZLCustomImageNames"
//设置框架语言的key
#define ZLLanguageTypeKey @"ZLLanguageTypeKey"
// 常量值
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define BIWeakObj(o)   @autoreleasepool {} __weak typeof(o) o ## Weak = o;
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
static inline CGFloat GetMatchValue(NSString *text, CGFloat fontSize, BOOL isHeightFixed, CGFloat fixedValue) {
    CGSize size;
    if (isHeightFixed) {
        size = CGSizeMake(MAXFLOAT, fixedValue);
    } else {
        size = CGSizeMake(fixedValue, MAXFLOAT);
    }
    CGSize resultSize;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0) {
        //返回计算出的size
        resultSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    }
    if (isHeightFixed) {
        return resultSize.width;
    } else {
        return resultSize.height;
    }
}
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT     [UIScreen mainScreen].bounds.size.height
#define PASSWORDCODE @"PASSWORDCODE"
//#define KGetRoom [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"room.data"]]
static inline CGFloat TQFontSizeFit(CGFloat value) {
    if ([UIScreen mainScreen].bounds.size.width < 375.0f) return value * 0.9;
    if ([UIScreen mainScreen].bounds.size.width > 375.0f) return value * 1.1;
    return value;
}

static inline CGFloat TQSizeFitW(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.width / 375.0f);
}

static inline CGFloat TQSizeFitH(CGFloat value) {
    return value * ([UIScreen mainScreen].bounds.size.height / 667.0f);
}
#define KGetUserMessage [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"usermessagemodel.data"]]
#define KSaveUserMessage(usermodel) [NSKeyedArchiver archiveRootObject:usermodel toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"usermessagemodel.data"]]

#define KGetHome [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"home.data"]]
#define KSaveHome(home) [NSKeyedArchiver archiveRootObject:home toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"home.data"]]

#define KGetRoom [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"room.data"]]
#define KSaveRoom(room) [NSKeyedArchiver archiveRootObject:room toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"room.data"]]

#define KGetRoomMessage [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"roommessage.data"]]
#define KSaveRoomMessage(roommessage) [NSKeyedArchiver archiveRootObject:roommessage toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"roommessage.data"]]

#define KGetSelectRoom [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"selectroomessage.data"]]

#define KSaveSelectRoom(selectroommodel) [NSKeyedArchiver archiveRootObject:selectroommodel toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"selectroomessage.data"]]


#define GET_DEVICE_INFO @"search/service/device_info"
#define FW_UPDATE @"fw_update"
#define FW_REPORT @"fw_report"
#define DEV_LTID @"dev_ltid"
#define DEV_STATUS @"dev_status"
#define DEV_CONTROL @"dev_control"
#define DEV_CHANGEWIFI @"changewifi"
#define GET_DEVICEINFO @"get_deviceinfo"
#define DEV_INFO @"dev_info"

#define SCH_SET @"sch_set"
#define SCH_GET @"sch_get"
#define SCH_DELETE @"sch_delete"
#define TIMEZONE_SET @"timezone_set"
#define TIMEZONE_GET @"timezone_get"

#define POWER_TODAY @"power_today"
#define POWER_LAST_2MONTH @"power_last_2month"
#define POWER_LAST_YEAR @"power_last_year"

#define SEARCH_DEVICE_INFO @"search/networked/device_info"
#define SEARCH_DEVICE @"search_device"
#define SEARCH_WIFILIST @"bs_scan"

#define LEAVE_HOME_SET @"leave_home_set"
#define LEAVE_HOME_GET @"leave_home_get"
#define LEAVE_HOME_DELETE @"leave_home_delete"

#define COUNTDOWN_SET @"countdown_set"
#define COUNTDOWN_CLEAR @"countdown_clear"




// 状态栏高度
#define k_status_height   [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define k_nav_height      self.navigationController.navigationBar.height
// 顶部整体高度
#define k_top_height        (k_status_height + k_nav_height)

#define SafeAreaTopHeight (KScreenHeight >= 812.0 ? 88 : 64)
#define TopHeight (KScreenHeight >= 812.0 ? 44 : 20)
#define SafeAreaBottomHeight (KScreenHeight >= 812.0 ? 34 : 0)
/******* 长牙注册启动参数 *******/
#define LONGTOOTH_DEVELOPER_ID      2
#define LONGTOOTH_APP_ID            1
#define LONGTOOTH_PORT              53199
#define LONGTOOTH_HOST              @"118.178.233.149"

#define LONGTOOTH_APP_KEY @"00989D0FA08D68A68205B8A8D7D14DE9213D91BE8C6BEC9C53F01728C7590DDED6EA2B565BD2F0539072468EC5B1AC2B5D0AA128F2A03C4A3B25646BDE62ED3F64787CF80FEFD4E48F0DA18FD3F5B2C5EA5EE617CE9F22C258CA5C077B990E9DA192C2AC340405144A6D6D97785505D8992298D3799F9B47D3D90EE1AEF5F15241010001"
//#define LONGTOOTH_DEVELOPER_ID      10620
//#define LONGTOOTH_APP_ID            2
//#define LONGTOOTH_PORT              53199
//#define LONGTOOTH_HOST              @"lt5us.longtooth.io"
//
//#define LONGTOOTH_APP_KEY @"00AA72988711C6BAC0557AE79F2F522D9471E17B2D327B8EC1E4BB17154CE44B29A9F2F2DB5C079F8A96241F5D4290615AF713BDEE9AA7DAE1AD4F8FCDD68FD13A231CA56A025BF291B98630E082A9081F8F1B381E81BE2F8F1ABAB32363D551B1D8C001C43F9EA9B54587A970C4D16B4CD688AA92A42481775E5397B441F7926F010001"

#define LONGTOOTH_Start_Success     1

#endif /* MyFileHeader_h */
