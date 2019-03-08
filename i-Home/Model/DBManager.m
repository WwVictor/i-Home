

//
//  DBManager.m
//  FMDBManager
//
//  Created by Divella on 16/5/25.
//  Copyright © 2016年 Victor. All rights reserved.
//
#import "DBManager.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "FMDatabaseQueue.h"
#define DimmerTabel @"ltdimmers"
#define BrightTempTabel @"ltbrighttemps"
#define BrightRBGTabel @"ltbrightrgbs"
#define RGBTabel @"ltrgbs"
#define SocketTabel @"ltsockets"
#define SwitchTabel @"ltswitchs"
#define CurtainTabel @"ltcurtains"
#define AirCondiTabel @"ltairconditioners"
NSString * const kdbManagerVersion = @"DBManagerVersion";
//const static NSInteger DB_MANAGER_VER = 1;

@implementation DBManager
{
    FMDatabase *dataBase ;
    //队列
    FMDatabaseQueue* _queue;
    NSMutableArray *loginModelArray;
    NSMutableArray *uploadModelArray;
    NSMutableArray *downloadModelArray;
}

//队列单例
+ (FMDatabaseQueue*)sharedQueue
{
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documenDirectory = [paths objectAtIndex:0];//去处需要的路径
    NSString* path = [documenDirectory stringByAppendingPathComponent:@"iThing.sqlite"];
    static FMDatabaseQueue *queue;
    if (queue == nil) {
       queue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return queue;
}
+ (DBManager *)shareManager {
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^{
        manager = [DBManager new];
        // 实例化对象
        [manager createTableWithName];
    });
    return manager;
}

- (void)createTableWithName {
    
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        //创建user表
        NSString *createUserTable = @"create table if not exists users(user_name varchar(48),user_id varchar(48),ltid varchar(48),PRIMARY KEY(user_id))";
        //创建home表
        NSString *createHomeTable = @"create table if not exists homes(user_id varchar(48),home_id varchar(48),home_name varchar(48),user_right varchar(48),is_default_home varchar(48),PRIMARY KEY(user_id,home_id))";
        // 创建room表
        NSString *createRoomTable = @"create table if not exists rooms(user_id varchar(48),home_id varchar(48),room_id varchar(48),room_name varchar(48),icon_order varchar(48),icon_path varchar(48),is_default_room varchar(48),dev_num int,PRIMARY KEY (user_id,room_id,home_id))";
        // 创建scene表
        NSString *createSceneTable = @"create table if not exists scenes(user_id varchar(48),scene_id varchar(48),room_id varchar(48),home_id varchar(48),icon_order varchar(48),icon_path varchar(48),scene_name varchar(48),PRIMARY KEY (user_id,scene_id,room_id,home_id))";
        // 创建room device表
        NSString *createRoomDeviceTable = @"create table if not exists roomdevices(user_id varchar(48),dev_id varchar(48),ep varchar(8),hw_ver varchar(48),icon_order varchar(48),icon_path varchar(48),longtooth_id varchar(48),dev_mac varchar(48),manufacturer varchar(48),model varchar(48),name varchar(48),room_id varchar(48),serial_type varchar(48),sw_ver varchar(48),type varchar(48),home_id varchar(48),PRIMARY KEY (user_id,dev_id,room_id,home_id))";
        // 创建scene device表
        NSString *createSceneDeviceTable = @"create table if not exists scenedevices(user_id varchar(48),dev_id varchar(48),room_id varchar(48),ep varchar(8),hw_ver varchar(48),icon_order varchar(48),icon_path varchar(48),longtooth_id varchar(48),dev_mac varchar(48),manufacturer varchar(48),model varchar(48),name varchar(48),scene_id varchar(48),serial_type varchar(48),sw_ver varchar(48),type varchar(48),home_id varchar(48),PRIMARY KEY (user_id,dev_id,scene_id,room_id,home_id))";

        //创建调光设备表
        NSString *createDimmerTable = [NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,onoff int,bri int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",DimmerTabel];
        //创建调光调色温设备表
        NSString *createBtempTable = [NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,onoff int,bri int,sat int,hue int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",BrightTempTabel];
        ///创建调光调rgb设备表
        NSString *createBRGBTable = [NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,onoff int,bri int,sat int,hue int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",BrightRBGTabel];
        
        //创建RGB设备表
        NSString *createRGBTable = [NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,onoff int,bri int,sat int,hue int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",RGBTabel];
        //创建socket设备表
        NSString *createSocketTable = [NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,onoff int,plugged int,engery int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",SocketTabel];
        //创建switch设备表
        NSString *createSwitchTable =[NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,onoff int,engery int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",SwitchTabel];
        //创建curtain设备表
        NSString *createCurtainTable = [NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,onoff int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",CurtainTabel];
        //创建air conditioner设备表
        NSString *createAirTable = [NSString stringWithFormat:@"create table if not exists %@(dev_id varchar(48),ltid varchar(48),room_id varchar(48),home_id varchar(48),user_id varchar(48),ep int,set_temp int,speed int,mode int,currentTemp int,type int,serial_type int,offline int,PRIMARY KEY(user_id,home_id,ep,ltid))",AirCondiTabel];
        if ([db executeUpdate:createUserTable]&&[db executeUpdate:createHomeTable]&&[db executeUpdate:createRoomDeviceTable]&&[db executeUpdate:createSceneDeviceTable]&&[db executeUpdate:createRoomTable]&&[db executeUpdate:createSceneTable]&&[db executeUpdate:createDimmerTable]&&[db executeUpdate:createBtempTable]&&[db executeUpdate:createBRGBTable]&&[db executeUpdate:createRGBTable]&&[db executeUpdate:createSocketTable]&&[db executeUpdate:createSwitchTable]&&[db executeUpdate:createCurtainTable]&&[db executeUpdate:createAirTable]) {
            NSLog(@"表创建成功");
        }else{
            NSLog(@"创建失败:%@",db.lastErrorMessage);
        }
    }];
}

#pragma mark ---- *********** User表数据结构操作方法
#pragma mark ---- 插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertUserTableWithFile:(UserMessageModel *)model
{
    //首先删除上一次存的数据
    [[DBManager shareManager] deleteUserTableWithWithUserId:model.userID];
    //加队列
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *insertSql = @"insert into users(user_name,user_id,ltid)values (?,?,?)";
        BOOL issuccessed = [db executeUpdate:insertSql,model.userName,model.userID,model.ltid];
        if (issuccessed) {
            NSLog(@"user数据插入成功");
        }else {
            NSLog(@"user数据插入失败%@",db.lastErrorMessage);
        }
    }];
}
#pragma mark ---- 按照user_id去查找
- (UserMessageModel *)selectFromUserTableWithUserId:(NSString *)user_id
{
    __block UserMessageModel *userModel = [[UserMessageModel alloc] init];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from users where user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,user_id];
        while ([set next]){
            userModel.userName = [set stringForColumn:@"user_name"];
            userModel.userID = [set stringForColumn:@"user_id"];
            userModel.ltid = [set stringForColumn:@"ltid"];
//            userModel.defalutLogin = [set stringForColumn:@"defalut_login"];
        }
        [set close];
    }];
    return userModel;
}
#pragma mark ---- 按照user_id去删除
- (void)deleteUserTableWithWithUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = @"delete from users where user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,user_id];
        if (!ret) {
            NSLog(@"userTable user_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"userTable user_id数据删除成功");
        }
    }];
}
#pragma mark ----查找整個UserTable表格
- (NSMutableArray<UserMessageModel *>*)selectFromUserTable
{
    __block NSMutableArray <UserMessageModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from users";
        FMResultSet *set = [db executeQuery:selectSql];
        while ([set next]){
            UserMessageModel *userModel = [[UserMessageModel alloc] init];
            userModel.userName = [set stringForColumn:@"user_name"];
            userModel.userID = [set stringForColumn:@"user_id"];
            userModel.ltid = [set stringForColumn:@"ltid"];
//            userModel.defalutLogin = [set stringForColumn:@"defalut_login"];
            
            [arr addObject:userModel];
        }
        [set close];
    }];
    return arr;
}
#pragma mark ----根据user_id修改password
- (void)updateUserTableWithPassword:(NSString *)password byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update users set user_password = '%@' where user_id = '%@'",password,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"user_password修改失败");
        } else {
            NSLog(@"user_password修改成功");
        }
    }];
}
#pragma mark ----根据user_id修改defalutLogin
- (void)updateUserTableWithDefalutLogin:(NSString *)defalutLogin byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update users set defalut_login = '%@' where user_id = '%@'",defalutLogin,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"defalut_login修改失败");
        } else {
            NSLog(@"defalut_login修改成功");
        }
    }];
}




#pragma mark ---- *********** home表数据结构操作方法

#pragma mark -  插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertHomeTableWithFile:(HomeInformationModel *)model
{
    //首先删除上一次存的数据
    [[DBManager shareManager] deleteHomeTableWithWithHomeId:model.homeID andUserId:model.userID];
    //加队列
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *insertSql = @"insert into homes(user_id,home_id,home_name,user_right,is_default_home)values (?,?,?,?,?)";
        BOOL issuccessed = [db executeUpdate:insertSql,model.userID,model.homeID,model.name,model.user_right,model.is_defaultHome];
        if (issuccessed) {
            NSLog(@"home数据插入成功");
        }else {
            NSLog(@"home数据插入失败%@",db.lastErrorMessage);
        }
    }];
}
#pragma mark -  按照hoom_id去查找
- (HomeInformationModel*)selectFromHomeTableWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block HomeInformationModel *homeModel = [[HomeInformationModel alloc] init];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from homes where home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,home_id,user_id];
        while ([set next]){
            homeModel.userID = [set stringForColumn:@"user_id"];
            homeModel.homeID = [set stringForColumn:@"home_id"];
            homeModel.name = [set stringForColumn:@"home_name"];
            
//            homeModel.last_update_bs_setting = [set stringForColumn:@"last_update_bs_setting"];
//            homeModel.app_zone_setting_last_update = [set stringForColumn:@"app_zone_setting_last_update"];
//            homeModel.app_scene_setting_last_update = [set stringForColumn:@"app_scene_setting_last_update"];
            
//            homeModel.app_ipcam_setting_last_update = [set stringForColumn:@"app_ipcam_setting_last_update"];
//            homeModel.app_automatic_setting_last_update = [set stringForColumn:@"app_automatic_setting_last_update"];
            homeModel.user_right = [set stringForColumn:@"user_right"];
            homeModel.is_defaultHome = [set stringForColumn:@"is_default_home"];
        }
        [set close];
    }];
    return homeModel;
}
#pragma mark - 按照hoom_id去删除
- (void)deleteHomeTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from homes where home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,home_id,user_id];
        
        if (!ret) {
            NSLog(@"home home_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"home home_id数据删除成功");
        }
        
    }];
}

//查找整個userid表格
- (NSMutableArray<HomeInformationModel *>*)selectFromHomeTableWithUserId:(NSString *)user_id
{
    __block NSMutableArray <HomeInformationModel*>*list = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from homes where user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,user_id];
        while ([set next]){
            HomeInformationModel *homeModel = [[HomeInformationModel alloc] init];
            homeModel.userID = [set stringForColumn:@"user_id"];
            homeModel.homeID = [set stringForColumn:@"home_id"];
            homeModel.name = [set stringForColumn:@"home_name"];
            
//            homeModel.last_update_bs_setting = [set stringForColumn:@"last_update_bs_setting"];
//            homeModel.app_zone_setting_last_update = [set stringForColumn:@"app_zone_setting_last_update"];
//            homeModel.app_scene_setting_last_update = [set stringForColumn:@"app_scene_setting_last_update"];
            
//            homeModel.app_ipcam_setting_last_update = [set stringForColumn:@"app_ipcam_setting_last_update"];
//            homeModel.app_automatic_setting_last_update = [set stringForColumn:@"app_automatic_setting_last_update"];
            homeModel.user_right = [set stringForColumn:@"user_right"];
            homeModel.is_defaultHome = [set stringForColumn:@"is_default_home"];
            [list addObject:homeModel];
        }
        [set close];
    }];
    return list;
}

#pragma mark - 查找整個HomeTable表格
- (NSMutableArray<HomeInformationModel *>*)selectFromHomeTable
{
    __block NSMutableArray <HomeInformationModel*>*list = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from homes";
        FMResultSet *set = [db executeQuery:selectSql];
        while ([set next]){
            HomeInformationModel *homeModel = [[HomeInformationModel alloc] init];
            homeModel.userID = [set stringForColumn:@"user_id"];
            homeModel.homeID = [set stringForColumn:@"home_id"];
            homeModel.name = [set stringForColumn:@"home_name"];
            
//            homeModel.last_update_bs_setting = [set stringForColumn:@"last_update_bs_setting"];
//            homeModel.app_zone_setting_last_update = [set stringForColumn:@"app_zone_setting_last_update"];
//            homeModel.app_scene_setting_last_update = [set stringForColumn:@"app_scene_setting_last_update"];
//
//            homeModel.app_ipcam_setting_last_update = [set stringForColumn:@"app_ipcam_setting_last_update"];
//            homeModel.app_automatic_setting_last_update = [set stringForColumn:@"app_automatic_setting_last_update"];
            homeModel.user_right = [set stringForColumn:@"user_right"];
            homeModel.is_defaultHome = [set stringForColumn:@"is_default_home"];
            [list addObject:homeModel];
        }
        [set close];
    }];
    return list;
}

#pragma mark ----根据home_id修改home_name
- (void)updateHomeTableWithHomeName:(NSString *)home_name byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update homes set home_name = '%@' where home_id = '%@' and user_id = '%@'",home_name,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"home_name修改失败");
        } else {
            NSLog(@"home_name修改成功");
        }
    }];
}
#pragma mark ---- 根据home_id修改is_defaultHome
- (void)updateHomeTableWithDefaultHome:(NSString *)is_defaultHome byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update homes set is_default_home = '%@' where home_id = '%@' and user_id = '%@'",is_defaultHome,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"is_defaultHome修改失败");
        } else {
            NSLog(@"is_defaultHome修改成功");
        }
    }];
}



#pragma mark ---- ***********  room表数据结构操作方法
#pragma mark -  插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertRoomTableWithFile:(RoomInformationModel *)model
{
    //首先删除上一次存的数据
    [[DBManager shareManager] deleteRoomTableWithWithRoomId:model.room_id andHomeId:model.home_id andUserId:model.user_id];
    //加队列
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *insertSql = @"insert into rooms(user_id,home_id,room_id,room_name,icon_order,icon_path,is_default_room,dev_num)values (?,?,?,?,?,?,?,?)";
        BOOL issuccessed = [db executeUpdate:insertSql,model.user_id,model.home_id,model.room_id,model.name,model.icon_order,model.icon_path,model.is_defaultRoom,model.dev_num];
        if (issuccessed) {
            NSLog(@"room数据插入成功");
        }else {
            
            NSLog(@"room数据插入失败%@",db.lastErrorMessage);
        }
    }];
}
#pragma mark -  按照room_id去查找
- (RoomInformationModel *)selectFromRoomTableWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block RoomInformationModel *roomModel = [[RoomInformationModel alloc] init];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from rooms where room_id = ? and home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,room_id,home_id,user_id];
        while ([set next]){
            roomModel.user_id = [set stringForColumn:@"user_id"];
            roomModel.home_id = [set stringForColumn:@"home_id"];
            roomModel.room_id = [set stringForColumn:@"room_id"];
            roomModel.name = [set stringForColumn:@"room_name"];
            
            roomModel.icon_order = [set stringForColumn:@"icon_order"];
            roomModel.icon_path = [set stringForColumn:@"icon_path"];
            
//            roomModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            roomModel.last_update = [set stringForColumn:@"last_update"];
//            roomModel.rgb_color = [set stringForColumn:@"rgb_color"];
            roomModel.is_defaultRoom = [set stringForColumn:@"is_default_room"];
            roomModel.dev_num = [set intForColumn:@"dev_num"];
        }
        [set close];
    }];
    
    return roomModel;
}
#pragma mark -  按照home_id去查找
- (NSMutableArray<RoomInformationModel *>*)selectFromRoomWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block NSMutableArray <RoomInformationModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from rooms where home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,home_id,user_id];
        while ([set next]){
            RoomInformationModel *roomModel = [[RoomInformationModel alloc] init];
            roomModel.user_id = [set stringForColumn:@"user_id"];
            roomModel.home_id = [set stringForColumn:@"home_id"];
            roomModel.room_id = [set stringForColumn:@"room_id"];
            roomModel.name = [set stringForColumn:@"room_name"];
            
            roomModel.icon_order = [set stringForColumn:@"icon_order"];
            roomModel.icon_path = [set stringForColumn:@"icon_path"];
            
//            roomModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            roomModel.last_update = [set stringForColumn:@"last_update"];
//            roomModel.rgb_color = [set stringForColumn:@"rgb_color"];
            roomModel.is_defaultRoom = [set stringForColumn:@"is_default_room"];
            roomModel.dev_num = [set intForColumn:@"dev_num"];
            [arr addObject:roomModel];
        }
        
        [set close];
        
    }];
    
    return arr;
}
#pragma mark -  按照room_id去删除
- (void)deleteRoomTableWithWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = @"delete from rooms where room_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,room_id,home_id,user_id];
        if (!ret) {
            NSLog(@"房间room_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"房间room_id数据删除成功");
        }
    }];
}
#pragma mark -  按照home_id去删除
- (void)deleteRoomTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *deleteSql = @"delete from rooms where home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,home_id,user_id];
        if (!ret) {
            NSLog(@"房间home_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"房间home_id数据删除成功");
        }
    }];
}
#pragma mark - 查找整個deviceTable表格
- (NSMutableArray<RoomInformationModel *>*)selectFromRoomTable
{
    __block NSMutableArray <RoomInformationModel*>*list = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from rooms";
        FMResultSet *set = [db executeQuery:selectSql];
        while ([set next]){
            RoomInformationModel *roomModel = [[RoomInformationModel alloc] init];
            roomModel.user_id = [set  stringForColumn:@"user_id"];
            roomModel.home_id = [set stringForColumn:@"home_id"];
            roomModel.room_id = [set stringForColumn:@"room_id"];
            roomModel.name = [set stringForColumn:@"room_name"];
            roomModel.icon_order = [set stringForColumn:@"icon_order"];
            roomModel.icon_path = [set stringForColumn:@"icon_path"];
//            roomModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            roomModel.last_update = [set stringForColumn:@"last_update"];
//            roomModel.rgb_color = [set stringForColumn:@"rgb_color"];
            roomModel.is_defaultRoom = [set stringForColumn:@"is_default_room"];
            [list addObject:roomModel];
        }
        [set close];
    }];
    return list;
}
#pragma mark - 根据roomid修改roomname
- (void)updateRoomTableWithRoomName:(NSString *)roomName byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update rooms set room_name = '%@' where home_id = '%@' and room_id = '%@' and user_id = '%@'",roomName,home_id,roomid,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"roomname修改失败");
        } else {
            NSLog(@"roomname修改成功");
        }
    }];
}
#pragma mark - 根据roomid修改iconPath
- (void)updateRoomTableWithIconPath:(NSString *)iconPath byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update rooms set icon_path = '%@' where room_id = '%@' and home_id = '%@' and user_id = '%@'",iconPath,roomid,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"iconPath修改失败");
        } else {
            NSLog(@"iconPath修改成功");
        }
    }];
}
#pragma mark - 根据roomid修改backgroundImage
- (void)updateRoomTableWithRgb_color:(NSString *)rgb_color byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update rooms set rgb_color = '%@' where room_id = '%@' and home_id = '%@' and user_id = '%@'",rgb_color,roomid,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"rgb_color修改失败");
        } else {
            NSLog(@"rgb_color修改成功");
        }
    }];
}
#pragma mark - 根据roomid修改roomOrder
- (void)updateRoomTableWithRoomOrder:(NSString *)roomorder byRoomid:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update rooms set icon_order = '%@' where room_id = '%@' and home_id = '%@' and user_id = '%@'",roomorder,roomid,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"room_order修改失败");
        } else {
            NSLog(@"room_order修改成功");
        }
    }];
}

#pragma mark - 根据home_id修改is_defaultHome
- (void)updateRoomTableWithDefaultRoom:(NSString *)is_defaultRoom byRoomId:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update rooms set is_default_room = '%@' where room_id = '%@' and home_id = '%@' and user_id = '%@'",is_defaultRoom,roomid,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"room_order修改失败");
        } else {
            NSLog(@"room_order修改成功");
        }
    }];
}
//根据roomid修改dev_num
- (void)updateRoomTableWithDev_num:(int)dev_num byRoomId:(NSString *)roomid byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update rooms set dev_num = '%d' where room_id = '%@' and home_id = '%@' and user_id = '%@'",dev_num,roomid,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"dev_num修改失败");
        } else {
            NSLog(@"dev_num修改成功");
        }
    }];
}

#pragma mark ---- *********** scene表数据结构操作方法
#pragma mark -  插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertSceneTableWithFile:(SceneInformationModel *)model
{
    //首先删除上一次存的数据
    [[DBManager shareManager] deleteSceneTableWithWithRoomId:model.room_id andSceneId:model.scene_id andHomeId:model.home_id andUserId:model.user_id];
    //加队列
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *insertSql = @"insert into scenes(user_id,scene_id,room_id,home_id,icon_order,icon_path,scene_name)values (?,?,?,?,?,?,?)";
        BOOL issuccessed = [db executeUpdate:insertSql,model.user_id,model.scene_id,model.room_id,model.home_id,model.icon_order,model.icon_path,model.name];
        if (issuccessed) {
            NSLog(@"scene数据插入成功");
        }else {
            NSLog(@"scene数据插入失败%@",db.lastErrorMessage);
        }
    }];
}
#pragma mark -  按照home_id和room_id去查找
- (NSMutableArray<SceneInformationModel *>*)selectFromSceneTableWithHomeId:(NSString *)home_id andRoomId:(NSString *)room_id andUserId:(NSString *)user_id
{
    __block NSMutableArray <SceneInformationModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenes where home_id = ? and room_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,home_id,room_id,user_id];
        while ([set next]){
            SceneInformationModel *sceneModel = [[SceneInformationModel alloc] init];
            sceneModel.user_id = [set stringForColumn:@"user_id"];
            sceneModel.scene_id = [set stringForColumn:@"scene_id"];
            sceneModel.room_id = [set stringForColumn:@"room_id"];
            sceneModel.home_id = [set stringForColumn:@"home_id"];
            sceneModel.icon_order = [set stringForColumn:@"icon_order"];
            sceneModel.icon_path = [set stringForColumn:@"icon_path"];
//            sceneModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            sceneModel.last_update = [set stringForColumn:@"last_update"];
            sceneModel.name = [set stringForColumn:@"scene_name"];
//            sceneModel.rgb_color = [set stringForColumn:@"rgb_color"];
            [arr addObject:sceneModel];
        }
        [set close];
    }];
    
    return arr;
}
#pragma mark -  按照home_id去查找
- (NSMutableArray<SceneInformationModel *>*)selectFromSceneTableWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block NSMutableArray <SceneInformationModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenes where home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,home_id,user_id];
        while ([set next]){
            SceneInformationModel *sceneModel = [[SceneInformationModel alloc] init];
            sceneModel.user_id = [set stringForColumn:@"user_id"];
            sceneModel.scene_id = [set stringForColumn:@"scene_id"];
            sceneModel.room_id = [set stringForColumn:@"room_id"];
            sceneModel.home_id = [set stringForColumn:@"home_id"];
            sceneModel.icon_order = [set stringForColumn:@"icon_order"];
            sceneModel.icon_path = [set stringForColumn:@"icon_path"];
//            sceneModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            sceneModel.last_update = [set stringForColumn:@"last_update"];
            sceneModel.name = [set stringForColumn:@"scene_name"];
//            sceneModel.rgb_color = [set stringForColumn:@"rgb_color"];
            [arr addObject:sceneModel];
        }
        [set close];
    }];
    
    return arr;
}

#pragma mark -  按照scene_id去查找
- (SceneInformationModel*)selectFromSceneWithRoomId:(NSString *)room_id andSceneId:(NSString *)scene_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block SceneInformationModel *sceneModel = [[SceneInformationModel alloc] init];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenes where room_id = ? and scene_id = ? and home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,room_id,scene_id,home_id,user_id];
        while ([set next]){
            sceneModel.user_id = [set stringForColumn:@"user_id"];
            sceneModel.scene_id = [set stringForColumn:@"scene_id"];
            sceneModel.room_id = [set stringForColumn:@"room_id"];
            sceneModel.home_id = [set stringForColumn:@"home_id"];
            sceneModel.icon_order = [set stringForColumn:@"icon_order"];
            sceneModel.icon_path = [set stringForColumn:@"icon_path"];
//            sceneModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            sceneModel.last_update = [set stringForColumn:@"last_update"];
            sceneModel.name = [set stringForColumn:@"scene_name"];
//            sceneModel.rgb_color = [set stringForColumn:@"rgb_color"];
        }
        [set close];
    }];
    return sceneModel;
}

#pragma mark -  按照room_id和home_id去删除
- (void)deleteSceneTableWithWithHomeId:(NSString *)home_id andRoomId:(NSString *)room_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenes where home_id = ? and room_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,home_id,room_id,user_id];
        
        if (!ret) {
            NSLog(@"场景room_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"场景room_id数据删除成功");
        }
        
    }];
}
#pragma mark -  按照room_id和scene_id去删除
- (void)deleteSceneTableWithWithRoomId:(NSString *)room_id andSceneId:(NSString *)scene_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenes where room_id = ? and scene_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,room_id,scene_id,home_id,user_id];
        
        if (!ret) {
            NSLog(@"场景scene_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"场景scene_id数据删除成功");
        }
        
    }];
}
#pragma mark -  按照home_id、user_id去删除
- (void)deleteSceneTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenes where home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,home_id,user_id];
        
        if (!ret) {
            NSLog(@"场景home_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"场景home_id数据删除成功");
        }
        
    }];
}
#pragma mark - 查找整個sceneTable表格
- (NSMutableArray<SceneInformationModel *>*)selectFromSceneTable
{
    __block NSMutableArray <SceneInformationModel*>*list = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenes";
        FMResultSet *set = [db executeQuery:selectSql];
        while ([set next]){
            SceneInformationModel *sceneModel = [[SceneInformationModel alloc] init];
            sceneModel.user_id = [set stringForColumn:@"user_id"];
            sceneModel.scene_id = [set stringForColumn:@"scene_id"];
            sceneModel.room_id = [set stringForColumn:@"room_id"];
            sceneModel.home_id = [set stringForColumn:@"home_id"];
            sceneModel.icon_order = [set stringForColumn:@"icon_order"];
            sceneModel.icon_path = [set stringForColumn:@"icon_path"];
//            sceneModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            sceneModel.last_update = [set stringForColumn:@"last_update"];
            sceneModel.name = [set stringForColumn:@"scene_name"];
//            sceneModel.rgb_color = [set stringForColumn:@"rgb_color"];
            [list addObject:sceneModel];
        }
        [set close];
    }];
    
    return list;
}



#pragma mark - 根据sceneid修改sceneName
- (void)updateSceneTableWithSceneName:(NSString *)sceneName bySceneid:(NSString *)sceneid byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update scenes set scene_name = '%@' where scene_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",sceneName,sceneid,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"scene_name修改失败");
        } else {
            NSLog(@"scene_name修改成功");
        }
    }];
}
#pragma mark - 根据sceneid修改iconPath
- (void)updateSceneTableWithIconPath:(NSString *)iconPath bySceneid:(NSString *)sceneid byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update scenes set icon_path = '%@' where scene_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",iconPath,sceneid,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"icon_path修改失败");
        } else {
            NSLog(@"icon_path修改成功");
        }
    }];
}

#pragma mark - 根据sceneid修改order
- (void)updateSceneTableWithOrder:(NSString *)order bySceneid:(NSString *)sceneid byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update scenes set icon_order = '%@' where scene_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",order,sceneid,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"scene_order修改失败");
        } else {
            NSLog(@"scene_order修改成功");
        }
    }];
}



#pragma mark ---- ***********  room_device表数据结构操作方法
#pragma mark -  插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertRoomDeviceTableWithFile:(DeviceInformationModel *)model
{
    //首先删除上一次存的数据
    [[DBManager shareManager] deleteRoomDeviceTableWithWithRoomId:model.room_id andDeviceId:model.dev_id andHomeId:model.home_id andUserId:model.user_id];
    //加队列
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *insertSql = @"insert into roomdevices(user_id,dev_id,ep,hw_ver,icon_order,icon_path,longtooth_id,dev_mac,manufacturer,model,name,room_id,serial_type,sw_ver,type,home_id)values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        BOOL issuccessed = [db executeUpdate:insertSql,model.user_id,model.dev_id,model.ep,model.hw_ver,model.icon_order,model.icon_path,model.longtooth_id,model.dev_mac,model.manufacturer,model.model,model.name,model.room_id,model.serial_type,model.sw_ver,model.type,model.home_id];
        if (issuccessed) {
//            [self insertDeviceTableWithFile:model.statusModel withTable:[self selectInsertTableWithDeviceType:model.type]];
            NSLog(@"room_device数据插入成功");
        }else {
            
            NSLog(@"room_device数据插入失败%@",db.lastErrorMessage);
        }
    }];
}
//-(NSString *)selectInsertTableWithDeviceType:(int)deviceType
//{
//    if (deviceType == 0) {
//        return DimmerTabel;
//    }else if (deviceType == 1){
//        return LEDTabel;
//    }else if (deviceType == 1){
//        return RGBTabel;
//    }else if (deviceType == 1){
//        return SwitchTabel;
//    }else if (deviceType == 1){
//        return SocketTabel;
//    }else if (deviceType == 1){
//       return CurtainTabel;
//    }else{
//      return AirCondiTabel;
//    }
//
//}

#pragma mark -  按照device_id去查找
- (DeviceInformationModel *)selectFromRoomDeviceTableWithDeviceId:(NSString *)device_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from roomdevices where dev_id = ? and room_id = ? and home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,device_id,room_id,home_id,user_id];
        while ([set next]){
            
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
        }
        
        [set close];
        
    }];
    
    return deviceModel;
}
#pragma mark -  按照room_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromRoomDeviceTableWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block NSMutableArray <DeviceInformationModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from roomdevices where room_id = ? and home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,room_id,home_id,user_id];
        while ([set next]){
            DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
            
            [arr addObject:deviceModel];
        }
        
        [set close];
        
    }];
    
    return arr;
}
#pragma mark -  按照scene_id去查找
//- (NSMutableArray<DeviceInformationModel *>*)selectFromRoomDeviceWithSceneId:(NSString *)scene_id
//{
//    __block NSMutableArray <DeviceInformationModel*>*arr = [NSMutableArray array];
//    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
//        NSString *selectSql = @"select * from roomdevices where scene_id = ?";
//        FMResultSet *set = [db executeQuery:selectSql,scene_id];
//        while ([set next]){
//            DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
//
//            deviceModel.iconPath = [set stringForColumn:@"icon_path"];
//            deviceModel.deviceId = [set stringForColumn:@"device_id"];
//
//            deviceModel.macAddress = [set stringForColumn:@"mac_address"];
//            deviceModel.endpoint = [set stringForColumn:@"endpoint"];
//
//            deviceModel.deviceName = [set stringForColumn:@"device_name"];
//            deviceModel.deviceType = [set stringForColumn:@"device_type"];
//
//            deviceModel.deviceOrder = [set stringForColumn:@"device_order"];
//            deviceModel.roomId = [set stringForColumn:@"room_id"];
//
//            deviceModel.modelName = [set stringForColumn:@"model_name"];
//            deviceModel.sceneId = [set stringForColumn:@"scene_id"];
//            deviceModel.homeId = [set stringForColumn:@"home_id"];
//            deviceModel.ltId = [set stringForColumn:@"ltid"];
//            [arr addObject:deviceModel];
//        }
//
//        [set close];
//
//    }];
//
//    return arr;
//}
#pragma mark -  按照home_id去查找
- (NSMutableArray<DeviceInformationModel *> *)selectFromRoomDeviceWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block NSMutableArray <DeviceInformationModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from roomdevices where home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,home_id,user_id];
        while ([set next]){
            DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
            
            [arr addObject:deviceModel];
        }
        
        [set close];
        
    }];
    
    return arr;
}
#pragma mark -  按照home_id去删除
- (void)deleteRoomDeviceTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from roomdevices where home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,home_id,user_id];
        
        if (!ret) {
            NSLog(@"设备home_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"设备home_id数据删除成功");
        }
        
    }];
}
#pragma mark -  按照device_id去删除
- (void)deleteRoomDeviceTableWithWithFile:(DeviceInformationModel *)model
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from roomdevices where dev_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,model.dev_id];
        
        if (!ret) {
            NSLog(@"设备device_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"设备device_id数据删除成功");
//            [self deleteDeviceTableWithWithDeviceId:model.device_id withTable:[self selectInsertTableWithDeviceType:model.deviceType]];
        }
        
    }];
}
#pragma mark -  按照room_id去删除
- (void)deleteRoomDeviceTableWithWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from roomdevices where room_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,room_id,home_id,user_id];
        
        if (!ret) {
            NSLog(@"设备room_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"设备room_id数据删除成功");
        }
        
    }];
}

#pragma mark -  按照room_id和device_id去删除
- (void)deleteRoomDeviceTableWithWithRoomId:(NSString *)room_id andDeviceId:(NSString *)device_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from roomdevices where room_id = ? and dev_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,room_id,device_id,home_id,user_id];
        
        if (!ret) {
            NSLog(@"设备room_id和device_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"设备room_id和device_id数据删除成功");
        }
        
    }];
}

#pragma mark -  按照scene_id去删除
//- (void)deleteRoomDeviceTableWithWithSceneId:(NSString *)scene_id
//{
//    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
//        
//        NSString *deleteSql = @"delete from roomdevices where scene_id = ?";
//        BOOL ret = [db executeUpdate:deleteSql,scene_id];
//        
//        if (!ret) {
//            NSLog(@"设备scene_id数据删除失败%@",db.lastErrorMessage);
//        }else{
//            NSLog(@"设备scene_id数据删除成功");
//        }
//        
//    }];
//}
#pragma mark - 查找整個deviceTable表格
- (NSMutableArray<DeviceInformationModel *>*)selectFromRoomDeviceTable
{
    __block NSMutableArray <DeviceInformationModel*>*list = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from roomdevices";
        FMResultSet *set = [db executeQuery:selectSql];
        while ([set next]){
            DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
            [list addObject:deviceModel];
        }
        [set close];
    }];
    return list;
}

#pragma mark - 根据device_id修改deviceName
- (void)updateRoomDeviceTableWithDeviceName:(NSString *)deviceName byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update roomdevices set name = '%@' where dev_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",deviceName,device_id,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"device_name修改失败");
        } else {
            NSLog(@"device_name修改成功");
        }
    }];
}
#pragma mark - 根据device_id修改roomOrder
- (void)updateRoomDeviceTableWithDeviceOrder:(int)deviceOrder byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update roomdevices set device_order = '%d' where dev_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",deviceOrder,device_id,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"device_order修改失败");
        } else {
            NSLog(@"device_order修改成功");
        }
    }];
}
#pragma mark - 根据device_id修改roomid
- (void)updateRoomDeviceTableWithRoomid:(NSString *)roomid byDeviceId:(NSString *)device_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update roomdevices set room_id = '%@' where dev_id = '%@' and home_id = '%@' and user_id = '%@'",roomid,device_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"room_id修改失败");
        } else {
            NSLog(@"room_id修改成功");
        }
    }];
}
#pragma mark - 根据device_id修改ip_addr
- (void)updateRoomDeviceTableWithIpAddr:(NSString *)ip_addr byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update roomdevices set ip_addr = '%@' where dev_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",ip_addr,device_id,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"ip_addr修改失败");
        } else {
            NSLog(@"ip_addr修改成功");
        }
    }];
}

#pragma mark - 根据device_id修改sw_version
- (void)updateRoomDeviceTableWithSwVersion:(NSString *)sw_version byDeviceId:(NSString *)device_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update roomdevices set sw_ver = '%@' where dev_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",sw_version,device_id,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"sw_version修改失败");
        } else {
            NSLog(@"sw_version修改成功");
        }
    }];
}
#pragma mark ---- ***********  scene_device表数据结构操作方法
/**
 @brief scene_device表数据结构操作方法
 */
#pragma mark-  插入数据用的方法 参数是根据表里插入的字段决定的
- (void)insertSceneDeviceTableWithFile:(DeviceInformationModel *)model
{
    //首先删除上一次存的数据
    [[DBManager shareManager] deleteSceneDeviceTableWithWithSceneId:model.scene_id andDeviceId:model.dev_id andRoomId:model.room_id andHomeId:model.home_id andUserId:model.user_id];
    //加队列
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        
        NSString *insertSql = @"insert into scenedevices(user_id,dev_id,room_id,ep,hw_ver,icon_order,icon_path,longtooth_id,dev_mac,manufacturer,model,name,scene_id,serial_type,sw_ver,type,home_id)values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        BOOL issuccessed = [db executeUpdate:insertSql,model.user_id,model.dev_id,model.room_id,model.ep,model.hw_ver,model.icon_order,model.icon_path,model.longtooth_id,model.dev_mac,model.manufacturer,model.model,model.name,model.scene_id,model.serial_type,model.sw_ver,model.type,model.home_id];
        if (issuccessed) {
//             [self insertDeviceTableWithFile:model.statusModel withTable:[self selectInsertTableWithDeviceType:model.deviceType]];
            NSLog(@"scene_device数据插入成功");
        }else {
            
            NSLog(@"scene_device数据插入失败%@",db.lastErrorMessage);
        }
    }];
}
#pragma mark-  按照device_id去查找
- (DeviceInformationModel*)selectFromSceneDeviceTableWithDeviceId:(NSString *)device_id andSceneid:(NSString *)scene_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenedevices where dev_id = ? and scene_id = ? and room_id = ? and home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,device_id,scene_id,room_id,home_id,user_id];
        while ([set next]){
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.scene_id = [set stringForColumn:@"scene_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
        }
        
        [set close];
        
    }];
    
    return deviceModel;
}
#pragma mark-  按照room_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceTableWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block NSMutableArray <DeviceInformationModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenedevices where room_id = ? and home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,room_id,home_id,user_id];
        while ([set next]){
            DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.scene_id = [set stringForColumn:@"scene_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
            [arr addObject:deviceModel];
        }
        
        [set close];
        
    }];
    
    return arr;
}
#pragma mark-  按照scene_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceWithSceneId:(NSString *)scene_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    __block NSMutableArray <DeviceInformationModel*>*arr = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenedevices where scene_id = ? and room_id = ? and home_id = ? and user_id = ?";
        FMResultSet *set = [db executeQuery:selectSql,scene_id,room_id,home_id,user_id];
        while ([set next]){
            DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.scene_id = [set stringForColumn:@"scene_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
            [arr addObject:deviceModel];
        }
        
        [set close];
        
    }];
    
    return arr;
}
#pragma mark-   按照home_id去查找
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
        __block NSMutableArray <DeviceInformationModel*>*arr = [NSMutableArray array];
        [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
            NSString *selectSql = @"select * from scenedevices where home_id = ? and user_id = ?";
            FMResultSet *set = [db executeQuery:selectSql,home_id,user_id];
            while ([set next]){
                DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
                deviceModel.user_id = [set stringForColumn:@"user_id"];
                deviceModel.dev_id = [set stringForColumn:@"dev_id"];
                deviceModel.room_id = [set stringForColumn:@"room_id"];
                deviceModel.ep = [set stringForColumn:@"ep"];
                deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
                deviceModel.icon_order = [set stringForColumn:@"icon_order"];
                deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//                deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//                deviceModel.last_update = [set stringForColumn:@"last_update"];
                deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
                
                deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
                deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
                deviceModel.model = [set stringForColumn:@"model"];
                deviceModel.name = [set stringForColumn:@"name"];
//                deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
                deviceModel.scene_id = [set stringForColumn:@"scene_id"];
                deviceModel.serial_type = [set stringForColumn:@"serial_type"];
                deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
                deviceModel.type = [set stringForColumn:@"type"];
                deviceModel.home_id = [set stringForColumn:@"home_id"];
//                deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//                deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
                
                [arr addObject:deviceModel];
            }
            
            [set close];
            
        }];
        
        return arr;
}
#pragma mark-   按照device_id去删除
- (void)deleteSceneDeviceTableWithWithFile:(DeviceInformationModel *)model
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenedevices where dev_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,model.dev_id];
        
        if (!ret) {
            NSLog(@"scenedevice_ home_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"scenedevice_ home_id数据删除成功");
//            [self deleteDeviceTableWithWithDeviceId:model.device_id withTable:[self selectInsertTableWithDeviceType:model.deviceType]];
        }
        
    }];
}
#pragma mark-   按照room_id去删除
- (void)deleteSceneDeviceTableWithWithRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenedevices where room_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,room_id,home_id,user_id];
        
        if (!ret) {
            NSLog(@"scenedevice_ room_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"scenedevice_ room_id数据删除成功");
        }
        
    }];
}
#pragma mark-   按照scene_id device_id去删除
- (void)deleteSceneDeviceTableWithWithSceneId:(NSString *)scene_id andDeviceId:(NSString *)device_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenedevices where scene_id = ? and dev_id = ? and room_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,scene_id,device_id,room_id,home_id,user_id];
        
        if (!ret) {
            NSLog(@"scenedevice_ scene_id,device_id 数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"scenedevice_ scene_id,device_id 数据删除成功");
        }
        
    }];
}
#pragma mark-   按照 device_id去删除
- (void)deleteSceneDeviceTableWithWithDeviceId:(NSString *)device_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenedevices where dev_id = ? and room_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,device_id,room_id,home_id,user_id];
        
        if (!ret) {
            NSLog(@"scenedevice_,device_id 数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"scenedevice_,device_id 数据删除成功");
        }
        
    }];
}
#pragma mark-   按照scene_id device_id去删除
- (void)deleteSceneDeviceTableWithWithSceneId:(NSString *)scene_id andRoomId:(NSString *)room_id andHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenedevices where scene_id = ? and room_id = ? and home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,scene_id,room_id,home_id,user_id];
        
        if (!ret) {
            NSLog(@"scenedevice_ scene_id,device_id 数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"scenedevice_ scene_id,device_id 数据删除成功");
        }
        
    }];
}
#pragma mark-   按照home_id去删除
- (void)deleteSceneDeviceTableWithWithHomeId:(NSString *)home_id andUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = @"delete from scenedevices where home_id = ? and user_id = ?";
        BOOL ret = [db executeUpdate:deleteSql,home_id,user_id];
        
        if (!ret) {
            NSLog(@"scenedevice_ home_id数据删除失败%@",db.lastErrorMessage);
        }else{
            NSLog(@"scenedevice_ home_id数据删除成功");
        }
        
    }];
}
#pragma mark-  查找整個deviceTable表格
- (NSMutableArray<DeviceInformationModel *>*)selectFromSceneDeviceTable
{
    __block NSMutableArray <DeviceInformationModel*>*list = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = @"select * from scenedevices";
        FMResultSet *set = [db executeQuery:selectSql];
        while ([set next]){
            DeviceInformationModel *deviceModel = [[DeviceInformationModel alloc] init];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.ep = [set stringForColumn:@"ep"];
            deviceModel.hw_ver = [set stringForColumn:@"hw_ver"];
            deviceModel.icon_order = [set stringForColumn:@"icon_order"];
            deviceModel.icon_path = [set stringForColumn:@"icon_path"];
//            deviceModel.is_icon_image = [set stringForColumn:@"is_icon_image"];
//            deviceModel.last_update = [set stringForColumn:@"last_update"];
            deviceModel.longtooth_id = [set stringForColumn:@"longtooth_id"];
            
            deviceModel.dev_mac = [set stringForColumn:@"dev_mac"];
            deviceModel.manufacturer = [set stringForColumn:@"manufacturer"];
            deviceModel.model = [set stringForColumn:@"model"];
            deviceModel.name = [set stringForColumn:@"name"];
//            deviceModel.rgb_color = [set stringForColumn:@"rgb_color"];
            deviceModel.scene_id = [set stringForColumn:@"scene_id"];
            deviceModel.serial_type = [set stringForColumn:@"serial_type"];
            deviceModel.sw_ver = [set stringForColumn:@"sw_ver"];
            deviceModel.type = [set stringForColumn:@"type"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
//            deviceModel.ip_addr = [set stringForColumn:@"ip_addr"];
//            deviceModel.statusModel = [self selectFromDeviceTableWithDeviceId:[set stringForColumn:@"device_id"] withTable:[self selectInsertTableWithDeviceType:[set intForColumn:@"device_type"]]];
            [list addObject:deviceModel];
        }
        [set close];
    }];
    return list;
}
//根据device_id修改deviceName
- (void)updateSceneDeviceTableWithDeviceName:(NSString *)deviceName byDeviceId:(NSString *)device_id bySceneid:(NSString *)scene_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update scenedevices set device_name = '%@' where dev_id = '%@' and scene_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",deviceName,device_id,scene_id,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"device_name修改失败");
        } else {
            NSLog(@"device_name修改成功");
        }
    }];
}
//根据device_id修改deviceOrder
- (void)updateSceneDeviceTableWithDeviceOrder:(int)deviceOrder byDeviceId:(NSString *)device_id bySceneid:(NSString *)scene_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update scenedevices set device_order = '%d' where dev_id = '%@' and scene_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",deviceOrder,device_id,scene_id,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"device_order修改失败");
        } else {
            NSLog(@"device_order修改成功");
        }
    }];
}
//根据device_id修改seceneid
- (void)updateSceneDeviceTableWithSceneid:(NSString *)sceneid byDeviceId:(NSString *)device_id bySceneid:(NSString *)scene_id byRoomId:(NSString *)room_id byHomeId:(NSString *)home_id byUserId:(NSString *)user_id
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update scenedevices set room_id = '%@' where dev_id = '%@' and scene_id = '%@' and room_id = '%@' and home_id = '%@' and user_id = '%@'",scene_id,device_id,scene_id,room_id,home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"room_id修改失败");
        } else {
            NSLog(@"room_id修改成功");
        }
    }];
}


#pragma mark - <<<<<<<<<<<<<把数据插入设备表>>>>>>>>>>>>
-(void)insertDeviceTableWithFile:(DeviceStatusModel *)model withTable:(NSString *)table
{
    //首先删除上一次存的数据
    [[DBManager shareManager] deleteDeviceTableWithWithLongtooId:model.ltid andEp:model.ep andHomeId:model.home_id andUserId:model.user_id withTable:table];
    //加队列
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *insertSql = [self selectInsertDeviceTable:table];
//        BOOL issuccessed = [self selectInsertDeviceTable:table withFile:model withDatabase:db];
        BOOL issuccessed = NO;
        if([table isEqualToString:DimmerTabel]){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.onoff],[NSNumber numberWithInt:model.bri],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else if (([table isEqualToString:BrightTempTabel])){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.onoff],[NSNumber numberWithInt:model.bri],[NSNumber numberWithInt:model.sat],[NSNumber numberWithInt:model.hue],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else if (([table isEqualToString:BrightRBGTabel])){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.onoff],[NSNumber numberWithInt:model.bri],[NSNumber numberWithInt:model.sat],[NSNumber numberWithInt:model.hue],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else if (([table isEqualToString:RGBTabel])){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.onoff],[NSNumber numberWithInt:model.bri],[NSNumber numberWithInt:model.sat],[NSNumber numberWithInt:model.hue],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else if (([table isEqualToString:SocketTabel])){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.onoff],[NSNumber numberWithInt:model.plugged],[NSNumber numberWithInt:model.engery],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else if (([table isEqualToString:SwitchTabel])){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.onoff],[NSNumber numberWithInt:model.engery],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else if (([table isEqualToString:CurtainTabel])){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.onoff],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else if (([table isEqualToString:AirCondiTabel])){
            issuccessed = [db executeUpdate:insertSql,model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,[NSNumber numberWithInt:model.ep],[NSNumber numberWithInt:model.set_temp],[NSNumber numberWithInt:model.speed],[NSNumber numberWithInt:model.mode],[NSNumber numberWithInt:model.currentTemp],[NSNumber numberWithInt:model.type],[NSNumber numberWithInt:model.serial_type],[NSNumber numberWithInt:model.offline]];
        }else{
            
        }
        if (issuccessed) {
            NSLog(@"%@数据插入成功",table);
        }else {
            
            NSLog(@"%@数据插入失败%@",table,db.lastErrorMessage);
        }
    }];
}

- (BOOL)selectInsertDeviceTable:(NSString *)table withFile:(DeviceStatusModel *)model withDatabase:(FMDatabase *)db
{
    if([table isEqualToString:DimmerTabel]){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.onoff,model.bri,model.type,model.serial_type,model.offline];
    }else if (([table isEqualToString:BrightTempTabel])){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.onoff,model.bri,model.sat,model.hue,model.type,model.serial_type,model.offline];
    }else if (([table isEqualToString:BrightRBGTabel])){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.onoff,model.bri,model.sat,model.hue,model.type,model.serial_type,model.offline];
    }else if (([table isEqualToString:RGBTabel])){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.onoff,model.bri,model.sat,model.hue,model.type,model.serial_type,model.offline];
    }else if (([table isEqualToString:SocketTabel])){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.onoff,model.plugged,model.engery,model.type,model.serial_type,model.offline];
    }else if (([table isEqualToString:SwitchTabel])){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.onoff,model.engery,model.type,model.serial_type,model.offline];
    }else if (([table isEqualToString:CurtainTabel])){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.onoff,model.type,model.serial_type,model.offline];
    }else if (([table isEqualToString:AirCondiTabel])){
        return [db executeUpdate:[self selectInsertDeviceTable:table],model.dev_id,model.ltid,model.room_id,model.home_id,model.user_id,model.ep,model.set_temp,model.speed,model.mode,model.currentTemp,model.type,model.serial_type,model.offline];
    }else{
        return nil;
    }
}
- (NSString *)selectInsertDeviceTable:(NSString *)table
{
    if([table isEqualToString:DimmerTabel]){
        return @"insert into dimmers(dev_id,ltid,room_id,home_id,user_id,ep,onoff,bri,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?,?)";
    }else if (([table isEqualToString:BrightTempTabel])){
        return @"insert into ltbrighttemps(dev_id,ltid,room_id,home_id,user_id,ep,onoff,bri,sat,hue,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else if (([table isEqualToString:BrightRBGTabel])){
        return @"insert into ltbrightrgbs(dev_id,ltid,room_id,home_id,user_id,ep,onoff,bri,sat,hue,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else if (([table isEqualToString:RGBTabel])){
        return @"insert into ltrgbs(dev_id,ltid,room_id,home_id,user_id,ep,onoff,bri,sat,hue,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    }else if (([table isEqualToString:SocketTabel])){
        return @"insert into ltsockets(dev_id,ltid,room_id,home_id,user_id,ep,onoff,plugged,engery,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?,?,?)";
    }else if (([table isEqualToString:SwitchTabel])){
        return @"insert into ltswitchs(dev_id,ltid,room_id,home_id,user_id,ep,onoff,engery,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?,?)";
    }else if (([table isEqualToString:CurtainTabel])){
        return @"insert into ltcurtains(dev_id,ltid,room_id,home_id,user_id,ep,onoff,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?)";
    }else if (([table isEqualToString:AirCondiTabel])){
        return @"insert into ltairconditioners(dev_id,ltid,room_id,home_id,user_id,ep,set_temp,speed,mode,currentTemp,type,serial_type,offline)values (?,?,?,?,?,?,?,?,?,?,?,?)";
    }else{
        return nil;
    }
}

#pragma mark - 删除某个设备
-(void)deleteDeviceTableWithWithLongtooId:(NSString *)longtoo_id andEp:(int)ep andHomeId:(NSString *)home_id andUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        
        NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where ltid = ? and ep = ? and home_id = ? and user_id = ?",table];
        BOOL ret = [db executeUpdate:deleteSql,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        if (!ret) {
            NSLog(@"%@数据删除失败%@",table,db.lastErrorMessage);
        }else{
            NSLog(@"%@数据删除成功",table);
        }
        
    }];
}
#pragma mark - 按照device_id去查找
- (DeviceStatusModel *)selectFromDeviceTableWithLongtooId:(NSString *)longtoo_id andEp:(int)ep andHomeId:(NSString *)home_id andUserId:(NSString *)user_id withTable:(NSString *)table
{
    __block DeviceStatusModel *deviceModel = [[DeviceStatusModel alloc] init];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = [NSString stringWithFormat:@"select * from %@ where ltid = ? and ep = ? and home_id = ? and user_id = ?",table];
        FMResultSet *set = [db executeQuery:selectSql,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        while ([set next]){
            deviceModel.ltid = [set stringForColumn:@"ltid"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.type = [set intForColumn:@"type"];
            deviceModel.serial_type = [set intForColumn:@"serial_type"];
            deviceModel.ep = [set intForColumn:@"ep"];
            deviceModel.offline = [set intForColumn:@"offline"];
            if([table isEqualToString:DimmerTabel]){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
            }else if (([table isEqualToString:BrightTempTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
                deviceModel.sat = [set intForColumn:@"sat"];
                deviceModel.hue = [set intForColumn:@"hue"];
            }else if (([table isEqualToString:BrightRBGTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
                deviceModel.sat = [set intForColumn:@"sat"];
                deviceModel.hue = [set intForColumn:@"hue"];
            }else if (([table isEqualToString:RGBTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
                deviceModel.sat = [set intForColumn:@"sat"];
                deviceModel.hue = [set intForColumn:@"hue"];
            }else if (([table isEqualToString:SocketTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.plugged = [set intForColumn:@"plugged"];
                deviceModel.engery = [set intForColumn:@"engery"];
            }else if (([table isEqualToString:SwitchTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.engery = [set intForColumn:@"engery"];
            }else if (([table isEqualToString:CurtainTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
            }else if (([table isEqualToString:AirCondiTabel])){
                deviceModel.set_temp = [set intForColumn:@"set_temp"];
                deviceModel.speed = [set intForColumn:@"speed"];
                deviceModel.mode = [set intForColumn:@"mode"];
                deviceModel.currentTemp = [set intForColumn:@"currentTemp"];
            }
        }
        [set close];
    }];
    return deviceModel;
}
#pragma mark - 查找Table表格
- (NSMutableArray<DeviceStatusModel *>*)selectFromDeviceTable:(NSString *)table
{
    __block NSMutableArray <DeviceStatusModel*>*list = [NSMutableArray array];
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db) {
        NSString *selectSql = [NSString stringWithFormat:@"select * from %@",table];
        FMResultSet *set = [db executeQuery:selectSql];
        while ([set next]){
            DeviceStatusModel *deviceModel = [[DeviceStatusModel alloc] init];
            deviceModel.ltid = [set stringForColumn:@"ltid"];
            deviceModel.dev_id = [set stringForColumn:@"dev_id"];
            deviceModel.room_id = [set stringForColumn:@"room_id"];
            deviceModel.home_id = [set stringForColumn:@"home_id"];
            deviceModel.user_id = [set stringForColumn:@"user_id"];
            deviceModel.type = [set intForColumn:@"type"];
            deviceModel.serial_type = [set intForColumn:@"serial_type"];
            deviceModel.ep = [set intForColumn:@"ep"];
            deviceModel.offline = [set intForColumn:@"offline"];
            if([table isEqualToString:DimmerTabel]){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
            }else if (([table isEqualToString:BrightTempTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
                deviceModel.sat = [set intForColumn:@"sat"];
                deviceModel.hue = [set intForColumn:@"hue"];
            }else if (([table isEqualToString:BrightRBGTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
                deviceModel.sat = [set intForColumn:@"sat"];
                deviceModel.hue = [set intForColumn:@"hue"];
            }else if (([table isEqualToString:RGBTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.bri = [set intForColumn:@"bri"];
                deviceModel.sat = [set intForColumn:@"sat"];
                deviceModel.hue = [set intForColumn:@"hue"];
            }else if (([table isEqualToString:SocketTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.plugged = [set intForColumn:@"plugged"];
                deviceModel.engery = [set intForColumn:@"engery"];
            }else if (([table isEqualToString:SwitchTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
                deviceModel.engery = [set intForColumn:@"engery"];
            }else if (([table isEqualToString:CurtainTabel])){
                deviceModel.onoff = [set intForColumn:@"onoff"];
            }else if(([table isEqualToString:AirCondiTabel])){
                deviceModel.set_temp = [set intForColumn:@"set_temp"];
                deviceModel.speed = [set intForColumn:@"speed"];
                deviceModel.mode = [set intForColumn:@"mode"];
                deviceModel.currentTemp = [set intForColumn:@"currentTemp"];
            }
            [list addObject:deviceModel];
        }
        [set close];
    }];
    return list;
}

#pragma mark - 根据device_id修改deviceEp
//- (void)updateDeviceTableWithEp:(int)ep byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
//{
//    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
//        NSString *sql = [NSString stringWithFormat:@"update %@ set ep = '%d' where device_id = '%@'",table,deviceEp,device_id];
//        BOOL result = [db executeUpdate:sql];
//        if (!result) {
//            NSLog(@"%@修改ep失败",table);
//        } else {
//            NSLog(@"%@修改ep成功",table);
//        }
//    }];
//}
#pragma mark - 根据device_id修改status
- (void)updateDeviceTableWithOn:(int)on byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set onoff = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,on,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改status失败",table);
        } else {
            NSLog(@"%@修改status成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改brightness
- (void)updateDeviceTableWithBrightness:(int)brightness byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set bri = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,brightness,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改brightness失败",table);
        } else {
            NSLog(@"%@修改brightness成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改saturation
- (void)updateDeviceTableWithSaturation:(int)saturation byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set sat = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,saturation,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改saturation失败",table);
        } else {
            NSLog(@"%@修改saturation成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改hue
- (void)updateDeviceTableWithHue:(int)hue byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set hue = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,hue,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改hue失败",table);
        } else {
            NSLog(@"%@修改hue成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改brightness
- (void)updateDeviceTableWithEngery:(int)engery byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set engery = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,engery,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改engery失败",table);
        } else {
            NSLog(@"%@修改engery成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改plugged
- (void)updateDeviceTableWithPlugged:(int)plugged byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set plugged = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,plugged,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改plugged失败",table);
        } else {
            NSLog(@"%@修改plugged成功",table);
        }
    }];
}

#pragma mark - 根据device_id修改setTemp
- (void)updateDeviceTableWithSetTemp:(int)setTemp byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set set_temp = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,setTemp,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改setTemp失败",table);
        } else {
            NSLog(@"%@修改setTemp成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改fanSpeed
- (void)updateDeviceTableWithFanSpeed:(int)fanSpeed byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set speed = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,fanSpeed,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改fanSpeed失败",table);
        } else {
            NSLog(@"%@修改fanSpeed成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改mode
- (void)updateDeviceTableWithMode:(int)mode byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set mode = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,mode,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改mode失败",table);
        } else {
            NSLog(@"%@修改mode成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改currentTemp
- (void)updateDeviceTableWithCurrentTemp:(int)currentTemp byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set currentTemp = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,currentTemp,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改currentTemp失败",table);
        } else {
            NSLog(@"%@修改currentTemp成功",table);
        }
    }];
}
#pragma mark - 根据device_id修改offline
- (void)updateDeviceTableWithOffline:(int)offline byLongtooId:(NSString *)longtoo_id byEp:(int)ep byHomeId:(NSString *)home_id byUserId:(NSString *)user_id withTable:(NSString *)table
{
    [[DBManager sharedQueue] inDatabase:^(FMDatabase *db){
        NSString *sql = [NSString stringWithFormat:@"update %@ set offline = '%d' where ltid = '%@' and ep = '%@' and home_id = '%@' and user_id = '%@'",table,offline,longtoo_id,[NSNumber numberWithInt:ep],home_id,user_id];
        BOOL result = [db executeUpdate:sql];
        if (!result) {
            NSLog(@"%@修改offline失败",table);
        } else {
            NSLog(@"%@修改offline成功",table);
        }
    }];
}

@end
