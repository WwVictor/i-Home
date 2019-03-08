//
//  DBManager.h
//  FMDBManager
//
//  Created by Divella on 16/5/25.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "iThingHeader.h"
#import "MyFileHeader.h"
#import "FMDatabaseModel.h"
@interface DBManager : NSObject

+ (DBManager *)shareManager;

/**
 @brief 用户表数据结构操作方法
 */
// 插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertUserTableWithFile:(UserMessageModel *)model;
// 按照user_id去查找
- (UserMessageModel *)selectFromUserTableWithUserId:(NSString *)user_id;
// 按照user_id去删除
- (void)deleteUserTableWithWithUserId:(NSString *)user_id;
//查找整個UserTable表格
- (NSMutableArray<UserMessageModel *>*)selectFromUserTable;
//根据user_id修改password
- (void)updateUserTableWithPassword:(NSString *)password byUserId:(NSString *)user_id;
//根据user_id修改defalutLogin
- (void)updateUserTableWithDefalutLogin:(NSString *)defalutLogin byUserId:(NSString *)user_id;
/**
 @brief home表数据结构操作方法
 */
// 插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertHomeTableWithFile:(HomeInformationModel *)model;
// 按照home_id去查找
- (HomeInformationModel *)selectFromHomeTableWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照hoom_id去删除
- (void)deleteHomeTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
//查找整個HomeTable表格
- (NSMutableArray<HomeInformationModel *>*)selectFromHomeTable;
//查找整個userid表格
- (NSMutableArray<HomeInformationModel *>*)selectFromHomeTableWithUserId:(NSString *)user_id;
//根据home_id修改home_name
- (void)updateHomeTableWithHomeName:(NSString *)home_name byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据home_id修改is_defaultHome
- (void)updateHomeTableWithDefaultHome:(NSString *)is_defaultHome byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
/**
 @brief room表数据结构操作方法
 */
// 插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertRoomTableWithFile:(RoomInformationModel *)model;
// 按照room_id去查找
- (RoomInformationModel*)selectFromRoomTableWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照home_id去查找
- (NSMutableArray<RoomInformationModel *>*)selectFromRoomWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照room_id和home_id去删除
- (void)deleteRoomTableWithWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照home_id去删除
- (void)deleteRoomTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
//查找整個deviceTable表格
- (NSMutableArray<RoomInformationModel *>*)selectFromRoomTable;
//根据roomid修改roomname
- (void)updateRoomTableWithRoomName:(NSString *)roomName byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据roomid修改iconPath
- (void)updateRoomTableWithIconPath:(NSString *)iconPath byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据roomid修改rgb_color
- (void)updateRoomTableWithRgb_color:(NSString *)rgb_color byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据roomid修改roomOrder
- (void)updateRoomTableWithRoomOrder:(NSString *)roomorder byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据roomid修改is_defaultHome
- (void)updateRoomTableWithDefaultRoom:(NSString *)is_defaultRoom byRoomId:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;

//根据roomid修改dev_num
- (void)updateRoomTableWithDev_num:(int)dev_num byRoomId:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
/**
 @brief scene表数据结构操作方法
 */
// 插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertSceneTableWithFile:(SceneInformationModel *)model;
// 按照home_id和room_id去查找
- (NSMutableArray<SceneInformationModel *>*)selectFromSceneTableWithHomeId:(NSString *)home_id andRoomId:(NSString *)room_id andUserId:(NSString *)user_id;
// 按照home_id去查找
- (NSMutableArray<SceneInformationModel *>*)selectFromSceneTableWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照scene_id、home_id、room_id去查找
- (SceneInformationModel*)selectFromSceneWithRoomId:(NSString *)room_id andSceneId:(NSString *)scene_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照home_id和room_id去删除
- (void)deleteSceneTableWithWithHomeId:(NSString *)home_id andRoomId:(NSString *)room_id andUserId:(NSString *)user_id;
// 按照home_id去删除
- (void)deleteSceneTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照scene_id和room_id去删除
- (void)deleteSceneTableWithWithRoomId:(NSString *)room_id andSceneId:(NSString *)scene_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
//查找整個sceneTable表格
- (NSMutableArray<SceneInformationModel *>*)selectFromSceneTable;
//根据sceneid修改sceneName
- (void)updateSceneTableWithSceneName:(NSString *)sceneName bySceneid:(NSString *)sceneid byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据sceneid修改iconPath
- (void)updateSceneTableWithIconPath:(NSString *)iconPath bySceneid:(NSString *)sceneid byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据sceneid修改order
- (void)updateSceneTableWithOrder:(NSString *)order bySceneid:(NSString *)sceneid byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;









/**
 @brief room_device表数据结构操作方法
 */
// 插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertRoomDeviceTableWithFile:(DeviceInformationModel *)model;
// 按照device_id去查找
- (DeviceInformationModel *)selectFromRoomDeviceTableWithDeviceId:(NSString *)device_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照room_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromRoomDeviceTableWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照scene_id去查找
//- (NSMutableArray<DeviceInformationModel *>*)selectFromRoomDeviceWithSceneId:(NSString *)scene_id;
// 按照home_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromRoomDeviceWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照device_id去删除
- (void)deleteRoomDeviceTableWithWithFile:(DeviceInformationModel *)model;
// 按照room_id去删除
- (void)deleteRoomDeviceTableWithWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照room_id和device_id去删除
- (void)deleteRoomDeviceTableWithWithRoomId:(NSString *)room_id andDeviceId:(NSString *)device_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照scene_id去删除
//- (void)deleteRoomDeviceTableWithWithSceneId:(NSString *)scene_id;
// 按照home_id去删除
- (void)deleteRoomDeviceTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
//查找整個deviceTable表格
- (NSMutableArray<DeviceInformationModel *>*)selectFromRoomDeviceTable;
//根据device_id修改backgroundImage
- (void)updateRoomDeviceTableWithDeviceName:(NSString *)deviceName byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据device_id修改roomOrder
- (void)updateRoomDeviceTableWithDeviceOrder:(int)deviceOrder byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据device_id修改roomid
- (void)updateRoomDeviceTableWithRoomid:(NSString *)roomid byDeviceId:(NSString *)device_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据device_id修改ip_addr
- (void)updateRoomDeviceTableWithIpAddr:(NSString *)ip_addr byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据device_id修改sw_version
- (void)updateRoomDeviceTableWithSwVersion:(NSString *)sw_version byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
/**
 @brief scene_device表数据结构操作方法
 */
// 插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertSceneDeviceTableWithFile:(DeviceInformationModel *)model;
// 按照device_id去查找
- (DeviceInformationModel *)selectFromSceneDeviceTableWithDeviceId:(NSString *)device_id andSceneid:(NSString *)scene_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照room_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceTableWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照scene_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceWithSceneId:(NSString *)scene_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照home_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照device_id去删除
- (void)deleteSceneDeviceTableWithWithFile:(DeviceInformationModel *)model;
// 按照room_id去删除
- (void)deleteSceneDeviceTableWithWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照scene_id device_id去删除
- (void)deleteSceneDeviceTableWithWithSceneId:(NSString *)scene_id andDeviceId:(NSString *)device_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照 device_id去删除
- (void)deleteSceneDeviceTableWithWithDeviceId:(NSString *)device_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照scene_id device_id去删除
- (void)deleteSceneDeviceTableWithWithSceneId:(NSString *)scene_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
// 按照home_id去删除
- (void)deleteSceneDeviceTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id;
//查找整個deviceTable表格
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceTable;
//根据device_id修改backgroundImage
- (void)updateSceneDeviceTableWithDeviceName:(NSString *)deviceName byDeviceId:(NSString *)device_id bySceneid:(NSString *)scene_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据device_id修改roomOrder
- (void)updateSceneDeviceTableWithDeviceOrder:(int)deviceOrder byDeviceId:(NSString *)device_id bySceneid:(NSString *)scene_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;
//根据device_id修改seceneid
- (void)updateSceneDeviceTableWithSceneid:(NSString *)sceneid byDeviceId:(NSString *)device_id bySceneid:(NSString *)scene_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id;





//设备数据插入
- (void)insertDeviceTableWithFile:(DeviceStatusModel *)model withTable:(NSString *)table;
//按照device_id去删除
- (void)deleteDeviceTableWithWithLongtooId:(NSString *)longtoo_id andEp:(int)ep andHomeId:(NSString *)home_id andUserId:(NSString *)user_id withTable:(NSString *)table;
// 按照device_id去查找
- (DeviceStatusModel *)selectFromDeviceTableWithLongtooId:(NSString *)longtoo_id andEp:(int)ep andHomeId:(NSString *)home_id andUserId:(NSString *)user_id withTable:(NSString *)table;
//查找Table表格
- (NSMutableArray<DeviceStatusModel *>*)selectFromDeviceTable:(NSString *)table;
//根据device_id修改deviceEp
//- (void)updateDeviceTableWithEp:(int)ep byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改status
- (void)updateDeviceTableWithOn:(int)on byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改brightness
- (void)updateDeviceTableWithBrightness:(int)brightness byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改saturation
- (void)updateDeviceTableWithSaturation:(int)saturation byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改hue
- (void)updateDeviceTableWithHue:(int)hue byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改brightness
- (void)updateDeviceTableWithEngery:(int)engery byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改plugged
- (void)updateDeviceTableWithPlugged:(int)plugged byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改setTemp
- (void)updateDeviceTableWithSetTemp:(int)setTemp byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改fanSpeed
- (void)updateDeviceTableWithFanSpeed:(int)fanSpeed byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改mode
- (void)updateDeviceTableWithMode:(int)mode byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改currentTemp
- (void)updateDeviceTableWithCurrentTemp:(int)currentTemp byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;
//根据device_id修改offline
- (void)updateDeviceTableWithOffline:(int)offline byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table;



@end
