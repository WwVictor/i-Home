//
//  FMDatabaseModel.h
//  iThing
//
//  Created by Frank on 2018/8/9.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeInformationModel;
@class DeviceInformationModel;
@class RoomInformationModel;
@class SceneInformationModel;
@class DeviceStatusModel;
@class SelectRoomModel;
@interface FMDatabaseModel : NSObject
@end

/**
 用户数据模型
 */
@interface UserMessageModel : NSObject
//@property (nonatomic, strong) NSString *result;
//@property (nonatomic, strong) NSString *message;
//@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *ltid;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userName;
//@property (nonatomic, strong) NSString *defalutLogin;
//@property (nonatomic, strong) NSMutableArray *homeList;
@end

/**
 home数据模型
 */
@interface HomeInformationModel : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *homeID;
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *last_update_bs_setting;
//@property (nonatomic, strong) NSString *app_zone_setting_last_update;
//@property (nonatomic, strong) NSString *app_scene_setting_last_update;
//@property (nonatomic, strong) NSString *app_ipcam_setting_last_update;
//@property (nonatomic, strong) NSString *app_automatic_setting_last_update;
@property (nonatomic, strong) NSString *user_right;
@property (nonatomic, strong) NSString *is_defaultHome;
@end

/**
 room数据模型
 */
@interface RoomInformationModel : NSObject
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSArray *devList;
@property (nonatomic, strong) NSString *icon_order;
@property (nonatomic, strong) NSString *icon_path;
//@property (nonatomic, strong) NSString *is_icon_image;
//@property (nonatomic, strong) NSString *last_update;
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *rgb_color;
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *is_defaultRoom;
@end
/**
 scene数据模型
 */
@interface SceneInformationModel : NSObject
@property (nonatomic, strong) NSString *icon_order;
@property (nonatomic, strong) NSString *icon_path;
//@property (nonatomic, strong) NSString *is_icon_image;
//@property (nonatomic, strong) NSString *last_update;
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *rgb_color;
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *scene_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSArray *sceneDevList;
//+ (instancetype) sceneInformationWithDict:(NSDictionary *)dict;
@end

/**
 设备数据模型
 */
@interface DeviceInformationModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ep;
@property (nonatomic, strong) NSString *hw_ver;
@property (nonatomic, strong) NSString *icon_order;
@property (nonatomic, strong) NSString *icon_path;
//@property (nonatomic, strong) NSString *is_icon_image;
//@property (nonatomic, strong) NSString *last_update;
@property (nonatomic, strong) NSString *longtooth_id;
@property (nonatomic, strong) NSString *dev_mac;
@property (nonatomic, strong) NSString *ip_addr;
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *name;
//@property (nonatomic, strong) NSString *rgb_color;
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *serial_type;
@property (nonatomic, strong) NSString *sw_ver;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *epNumber;
@property (nonatomic, strong) NSString *scene_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) BOOL isSelectDevice;
@property (nonatomic, strong) DeviceStatusModel *statusModel;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *dev_description;
@property (nonatomic, strong) NSString *latest_version;
@end

@interface RoomMessageModel : NSObject
@property (nonatomic, copy) NSString *home_id;
@property (nonatomic, copy) NSString *cmd;
@property (nonatomic, copy)NSMutableArray *data;
@end

@interface DeviceStatusModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ltid;
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;

@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;

@property (nonatomic, assign) int ep;
@property (nonatomic, assign) int onoff;
@property (nonatomic, assign) int bri;

@property (nonatomic, assign) int sat;
@property (nonatomic, assign) int hue;

@property (nonatomic, assign) int plugged;
@property (nonatomic, assign) int engery;

@property (nonatomic, assign) int set_temp;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) int mode;
@property (nonatomic, assign) int currentTemp;

@property (nonatomic, assign) int offline;
@property (nonatomic, strong) NSString *sw_ver;
@end

@interface DimmerStatusModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int onoff;//1-on , 0-off (int)
@property (nonatomic, assign) int bri;//0-100 光的亮度百分比 (int)
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;
@end

@interface LedStatusModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int onoff;//1-on , 0-off (int)
@property (nonatomic, assign) int bri;//0-100 光的亮度百分比 (int)
@property (nonatomic, assign) int satu;// 0-100 灯光饱和度 (int)
@property (nonatomic, assign) int hue;// 0 灯光色调 (界面上没有该选项，但是这个参数保留，值为0) (int)
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;
@end

@interface StaturationStatusModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int onoff;//1-on , 0-off (int)
@property (nonatomic, assign) int bri;//0-100 光的亮度百分比 (int)
@property (nonatomic, assign) int sat;// 0-100 灯光饱和度 (int)
@property (nonatomic, assign) int hue;// 0 灯光色调 (界面上没有该选项，但是这个参数保留，值为0) (int)
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;
@end


@interface RgbStatusModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int onoff;//1-on , 0-off (int)
@property (nonatomic, assign) int bri;//0-100 光的亮度百分比 (int)
@property (nonatomic, assign) int sat;// 0-100 灯光饱和度 (int)
@property (nonatomic, assign) int hue;// 0-360 根据 hue 圆环选定颜色的角度即为对应的颜色值
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;
@end

@interface SocketStatusModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int onoff;//1-on , 0-off (int)
@property (nonatomic, assign) int plugged;// 1 - plug , 0 - unplug 拔出/插入状态 (int)
@property (nonatomic, assign) int engery;// 0-65535 电量(int)
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;
@end

@interface SwitchStatusModel : NSObject
@property (nonatomic, strong) NSString *devid;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int onoff;//1-on , 0-off (int)
@property (nonatomic, assign) int engery;// 0-65535 电量(int)
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;
@end

@interface CurtainStatusModel : NSObject
@property (nonatomic, strong) NSString *devid;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int onoff;//1-on , 0-off (int)
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int serial_type;
@end

@interface AirConditionerStatusModel : NSObject
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *ltid;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *room_id;
@property (nonatomic, strong) NSString *home_id;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, assign) int ep;// 终端对应的数值，默认 1 (int)
@property (nonatomic, assign) int set_temp;//16-32 for cool mode , 10 – 30 for heat mode (the set temperature range information returned by device ) 冷热对应的温度值 (int)
@property (nonatomic, assign) int speed;//0 – low , 1- mid , 2 – high 风速 (int)
@property (nonatomic, assign) int mode;// 0–off,1–cool,2–heat,3–fan, 4–dry 模式 (int)
@property (nonatomic, assign) int currentTemp;//当前温度 (int)
@property (nonatomic, assign) int type;// (int)
@property (nonatomic, assign) int serial_type;
@end





















@interface DeviceMessageModel : NSObject
@property (nonatomic, strong) NSString *dev_mac;
@property (nonatomic, strong) NSString *hw_ver;
@property (nonatomic, strong) NSString *ip_addr;
@property (nonatomic, strong) NSString *longtooth_id;//设备的长牙 ID (char)
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *no_of_ep;
@property (nonatomic, strong) NSString *serial_num;
@property (nonatomic, strong) NSString *serial_type;
@property (nonatomic, strong) NSString *sw_ver;
@property (nonatomic, strong) NSString *type;
@end

@interface SceneDeviceStatusModel : NSObject
@property (nonatomic, strong) NSString *delay_time;
@property (nonatomic, strong) NSString *dev_id;
@property (nonatomic, strong) NSString *scene_id;
@property (nonatomic, assign) int gp_status1;
@property (nonatomic, assign) int gp_status2;
@property (nonatomic, assign) int gp_status3;
@property (nonatomic, assign) int gp_status4;
@property (nonatomic, assign) int id;
@end

@interface ShareUserInformationModel : NSObject
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSDictionary *app_setting;
@property (nonatomic, strong) NSString *user_right;
@end
@interface DeviceVersionModel : NSObject
@property (nonatomic, strong) NSString *dev_description;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *version;
@end

@interface SelectRoomModel : NSObject
@property (nonatomic, strong) NSString *room_name;
@property (nonatomic, assign) int isSelectRoom;
@end
