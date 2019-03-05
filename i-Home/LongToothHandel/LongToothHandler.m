//
//  LongToothHandler.m
//  OmniBox
//
//  Created by Frank on 2018/3/26.
//  Copyright © 2018年 Victor. All rights reserved.
//

#import "LongToothHandler.h"
#import <iconv.h>
//#import "OBService.h"
@implementation LongToothHandler
#pragma  mark ----实现单例
static LongToothHandler *_instance;
+ (instancetype)sharedInstance{
    return [[self alloc]init];
}

- (id)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    if (_instance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [super allocWithZone:zone];
        });
    }
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

- (void)registeredLongToothHost:(NSString *)host port:(NSInteger)port devid:(int)devId appid:(int)appId appkey:(NSString *)appKey block:(EventBlock)block{
    LongToothEventHandlerImpl *eventHandler = [[LongToothEventHandlerImpl alloc] init];
    eventHandler.eventBlock = ^(NSInteger event) {
        block(event);
    };
    [LongTooth setRegisterHost:host andPort:port];
    NSInteger result = [LongTooth start:devId withAppId:appId withAppKey:appKey handleEventBy:eventHandler];
    [LongTooth configLogEnable:YES];
    if (result == LONGTOOTH_Start_Success) {
        //注册本地服务
        [LongTooth addService:GET_DEVICE_INFO handleServiceRequestBy:[[LongToothBrocastRequestHandlerImpl alloc]init]];
        [LongTooth addService:DEV_LTID handleServiceRequestBy:[[LongToothBrocastRequestHandlerImpl alloc]init]];
        [LongTooth addService:FW_REPORT handleServiceRequestBy:[[LongToothBrocastRequestHandlerImpl alloc]init]];
        [LongTooth addService:DEV_STATUS handleServiceRequestBy:[[LongToothBrocastRequestHandlerImpl alloc]init]];
        [LongTooth addService:SEARCH_DEVICE_INFO handleServiceRequestBy:[[LongToothBrocastRequestHandlerImpl alloc]init]];
    }
}

- (void)sendRequestWithRemoteLtid:(NSString *)ltid ServiceName:(NSString *)serviceName insData:(NSData *)insData block:(ReceiveInsBlock)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    LongToothServiceResponseHandlerImpl *responseHandler = [[LongToothServiceResponseHandlerImpl alloc]init];
    self.sendInsBlock = ^(NSDictionary *returnStr,NSString *serviceName) {
         block(returnStr,serviceName);
    };
    NSLog(@"request_ltid =====%@, serviceName=====%@",ltid,serviceName);
    [LongTooth request:ltid forService:serviceName setDataType:LT_ARGUMENTS withArguments:insData attach:nil handleServiceResponseBy:responseHandler];
    });
   
}
- (void)sendInsWithRemoteLtid:(NSString *)ltid BroadcastKey:(NSString *)key ServiceName:(NSString *)serviceName insData:(NSData *)insData block:(SendDeviceMessageBlock)block{
    self.sendDeviceMessageBlock = ^(NSDictionary *returnStr,NSString *serviceName) {
        block(returnStr,serviceName);
    };
//    NSString *ltidString = [LongTooth getId];
//    NSString *str = [NSString stringWithFormat:@"%@\\%@",ltidString,serviceName];
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [LongTooth broadcast:key withMessage:insData];
}

- (void)sendBroadInsWithLtid:(NSString *)ltid BroadcastKey:(NSString *)key ServiceName:(NSString *)serviceName insData:(NSData *)insData block:(SendDeviceMessageBlock)block
{
    self.sendDeviceMessageBlock = ^(NSDictionary *returnStr, NSString *serviceName) {
       block(returnStr,serviceName);
    };
    [LongTooth broadcast:key withMessage:insData];
}

- (void)configHandleBrocastDelegate:(id)delegate{
    
    if (!delegate) {
        return;
    }
    self.delegate = delegate;
}
-(void)listeningBrocast:(id)obj andServiceName:(NSString *)serviceName
{
    if ([_delegate respondsToSelector:@selector(handleBrocastNotification:andServiceName:)]) {
        [_delegate handleBrocastNotification:obj andServiceName:serviceName];
    }
}
- (void)configHandleWifiDelegate:(id)delegateWifi
{
    if (!delegateWifi) {
        return;
    }
    self.delegateWifi = delegateWifi;
}
- (void)listeningWifi:(id)obj andServiceName:(NSString *)serviceName
{
    if ([_delegateWifi respondsToSelector:@selector(handleWifiNotification:andServiceName:)]) {
        [_delegateWifi handleWifiNotification:obj andServiceName:serviceName];
    }
}

- (void)configHandleSendDelegate:(id)delegate
{
    if (!delegate) {
        return;
    }
    self.delegateSend = delegate;
}
- (void)listeningSend:(id)obj andServiceName:(NSString *)serviceName
{
    if ([_delegateSend respondsToSelector:@selector(handleSendNotification:andServiceName:)]) {
        [_delegateSend handleSendNotification:obj andServiceName:serviceName];
    }
}

- (void)configHandleEventDelegate:(id)delegateEvent
{
    if (!delegateEvent) {
        return;
    }
    self.delegateEvent = delegateEvent;
}
- (void)listeningEvent:(id)obj andServiceName:(NSString *)serviceName
{
    if ([_delegateEvent respondsToSelector:@selector(handleEventNotification:andServiceName:)]) {
        [_delegateEvent handleEventNotification:obj andServiceName:serviceName];
    }
}

-(void)configHandleGetDeviceStatusDelegate:(id)delegateStatus
{
    if (!delegateStatus) {
        return;
    }
    self.delegateStatus = delegateStatus;
}
-(void)listeningStatus:(id)obj andServiceName:(NSString *)serviceName
{
    if ([_delegateStatus respondsToSelector:@selector(handleGetDeviceStatusNotification:andServiceName:)]) {
        [_delegateStatus handleGetDeviceStatusNotification:obj andServiceName:serviceName];
    }
}
@end

@implementation LongToothEventHandlerImpl

- (void)handle:(NSInteger)event withLongToothId:(NSString *)ltid withServiceName:(NSString *)service withMessage:(NSData *)msg withAttachment:(id<LongToothAttachment>)attachment{
    NSLog(@"%s event:0x%lx ltid:%@ serv:%@",__func__,(long)event,ltid,service);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(event) forKey:@"event"];
    [dict setObject:ltid forKey:@"ltid"];
    switch (event) {
        case EVENT_LONGTOOTH_STARTED:
            NSLog(@"状态__启动");
            [[NSUserDefaults standardUserDefaults] setValue:ltid forKey:@"longtooth_id"];
            self.eventBlock(event);
            break;
        case EVENT_LONGTOOTH_ACTIVATED:
            NSLog(@"状态___在线");
            self.eventBlock(event);
            break;
        case EVENT_LONGTOOTH_OFFLINE:
            NSLog(@"状态__目标不在线");
            self.eventBlock(event);
            break;
        case EVENT_SERVICE_NOT_EXIST:
            NSLog(@"状态__目标不存在");
            self.eventBlock(event);
            break;
        case EVENT_LONGTOOTH_UNREACHABLE:
            NSLog(@"状态__目标ID无法访问 %@",ltid);
            self.eventBlock(event);
            break;
        case EVENT_LONGTOOTH_TIMEOUT:
            NSLog(@"状态__目标ID请求超时 %@",ltid);
            [[LongToothHandler sharedInstance] listeningEvent:dict andServiceName:service];
            self.eventBlock(event);
            break;
        case EVENT_LONGTOOTH_BROADCAST:
//            NSString *str1 = [[NSString alloc]initWithData:msg encoding:NSUTF8StringEncoding];
            NSLog(@"收到的广播数据: %@",[[NSString alloc]initWithData:msg encoding:NSUTF8StringEncoding]);
            NSLog(@"收到广播 %@",ltid);
            break;
        default:
            break;
    }
}

@end

@implementation LongToothBrocastRequestHandlerImpl

- (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // 从UTF-8转UTF-8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 剔除非UTF-8的字符
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}
- (void)handle:(id<LongToothTunnel>)ltt withLongToothId:(NSString *)ltid withServiceName:(NSString *)service dataTypeIs:(NSInteger)dataType withArguments:(NSData *)args{
    
    NSString *str = [[NSString alloc] initWithData:[self cleanUTF8:args] encoding:NSUTF8StringEncoding];
    NSData * data = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"requestHandler ----- stringLength == %ld , dataLength == %ld",str.length,data.length);
    NSLog(@"service === %@ ,requestHandler == %@",service,dict);
    if ([service isEqualToString:GET_DEVICE_INFO]) {
        [[LongToothHandler sharedInstance] listeningSend:dict andServiceName:service];
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendDeviceMessageBlock(dict,service);
    }else if ([service isEqualToString:DEV_LTID]){
        NSLog(@"dev_ltid === %@",dict);
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        [newDict setValue:ltid forKey:@"ltid"];
        hand.sendDeviceMessageBlock(newDict,service);
        [LongTooth respond:ltt setDataType:0 withArguments:nil attach:nil];
    }else if ([service isEqualToString:FW_REPORT]){
//        NSLog(@"fw_report === %@",dict);
        NSMutableDictionary *newDict = [NSMutableDictionary dictionary];
        [newDict addEntriesFromDictionary:dict];
        [newDict setValue:ltid forKey:@"ltid"];
       [[LongToothHandler sharedInstance] listeningEvent:newDict andServiceName:service];
    }else if ([service isEqualToString:DEV_STATUS]){
        
        DeviceStatusModel *devStatusModel = [DeviceStatusModel mj_objectWithKeyValues:dict];
        NSLog(@"longtoo_id == %@",devStatusModel.ltid);
        UserMessageModel *model = KGetUserMessage;
        HomeInformationModel *homeModel = KGetHome;
        NSMutableArray *arr = [[DBManager shareManager] selectFromRoomDeviceWithHomeId:homeModel.homeID andUserId:model.userID];
        for (int i = 0; i < arr.count; i++) {
            DeviceInformationModel *info = arr[i];
            if ([info.longtooth_id isEqualToString:devStatusModel.ltid] && [info.ep intValue]==devStatusModel.ep) {
                devStatusModel.room_id = info.room_id;
                devStatusModel.home_id = info.home_id;
                devStatusModel.user_id = info.user_id;
                devStatusModel.type = [info.type intValue];
                devStatusModel.serial_type = [info.serial_type intValue];
                devStatusModel.offline = 0;
//                NSLog(@"requestHandler === %@",dict);
                [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:info]];
                [[LongToothHandler sharedInstance] listeningSend:dict andServiceName:service];
                [[LongToothHandler sharedInstance] listeningStatus:dict andServiceName:service];
            }
        }
    }else if ([service isEqualToString:SEARCH_DEVICE_INFO]){
        [[LongToothHandler sharedInstance] listeningSend:dict andServiceName:service];
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendDeviceMessageBlock(dict,service);
//        LongToothHandler *hand = [[LongToothHandler alloc] init];
//        hand.sendDeviceMessageBlock(dict,service);
    }
}
//- (NSString *)getDeviceTableName:(DeviceInformationModel *)model
//{
//    if([model.type intValue] == 5 && [model.serial_type intValue] == 1){
//        return DimmerTabel;
//    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 4){
//        return BrightTempTabel;
//    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 2){
//        return BrightRBGTabel;
//    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 3){
//        return RGBTabel;
//    }else if ([model.type intValue] == 7 ){
//        return SocketTabel;
//    }else if ([model.type intValue] == 8){
//        return SwitchTabel;
//    }else if ([model.type intValue] == 13 || [model.type intValue] == 14){
//        return CurtainTabel;
//    }else if ([model.type intValue] == 21){
//        return AirCondiTabel;
//    }else{
//        return nil;
//    }
//}
@end
@implementation LongToothServiceResponseHandlerImpl

- (void)handle:(id<LongToothTunnel>)ltt withLongToothId:(NSString *)ltid withServiceName:(NSString *)service dataTypeIs:(NSInteger)dataType withArguments:(NSData *)args attach:(id<LongToothAttachment>)attachment{
    NSString *str = [[NSString alloc] initWithData:[self cleanUTF8:args] encoding:NSUTF8StringEncoding];
    NSData * data = [[NSData alloc]initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"responseHandler ----- stringLength == %ld , dataLength == %ld",str.length,data.length);
    NSLog(@"service === %@ ,responseHandler == %@",service,dict);
    if ([service isEqualToString:DEV_STATUS]) {
        DeviceStatusModel *devStatusModel = [DeviceStatusModel mj_objectWithKeyValues:dict];
        if (devStatusModel.sw_ver.length == 0) {
         devStatusModel.sw_ver = dict[@"sw_ver"];
        }
        NSLog(@"longtoo_id == %@",devStatusModel.ltid);
        UserMessageModel *model = KGetUserMessage;
        HomeInformationModel *homeModel = KGetHome;
        NSMutableArray *arr = [[DBManager shareManager] selectFromRoomDeviceWithHomeId:homeModel.homeID andUserId:model.userID];
        for (int i = 0; i < arr.count; i++) {
            DeviceInformationModel *info = arr[i];
            if ([info.longtooth_id isEqualToString:devStatusModel.ltid] && [info.ep intValue]==devStatusModel.ep) {
                devStatusModel.room_id = info.room_id;
                devStatusModel.home_id = info.home_id;
                devStatusModel.user_id = info.user_id;
                devStatusModel.type = [info.type intValue];
                devStatusModel.serial_type = [info.serial_type intValue];
                devStatusModel.offline = 0;
                NSLog(@"responseHandler === %@",dict);
                [[DBManager shareManager] insertDeviceTableWithFile:devStatusModel withTable:[[DeviceTypeManager shareManager] getDeviceTableName:info]];
                LongToothHandler *hand = [[LongToothHandler alloc] init];
                hand.sendInsBlock(dict,service);//block赋值
            }
        }
    }else if ([service isEqualToString:DEV_CONTROL]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:DEV_CHANGEWIFI]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:GET_DEVICEINFO]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:FW_UPDATE]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:DEV_INFO]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:SCH_GET]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:SCH_DELETE]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:SCH_SET]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:POWER_TODAY]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:POWER_LAST_2MONTH]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:POWER_LAST_YEAR]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:LEAVE_HOME_GET]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:LEAVE_HOME_SET]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:LEAVE_HOME_DELETE]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:COUNTDOWN_SET]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }else if ([service isEqualToString:COUNTDOWN_CLEAR]){
        LongToothHandler *hand = [[LongToothHandler alloc] init];
        hand.sendInsBlock(dict,service);//block赋值
        [[LongToothHandler sharedInstance] listeningSend:dict[@"result"] andServiceName:service];
    }
    
}
//- (NSString *)getDeviceTableName:(DeviceInformationModel *)model
//{
//    if([model.type intValue] == 5 && [model.serial_type intValue] == 1){
//        return DimmerTabel;
//    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 4){
//        return BrightTempTabel;
//    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 2){
//        return BrightRBGTabel;
//    }else if ([model.type intValue] == 5 && [model.serial_type intValue] == 3){
//        return RGBTabel;
//    }else if ([model.type intValue] == 7 ){
//        return SocketTabel;
//    }else if ([model.type intValue] == 8){
//        return SwitchTabel;
//    }else if ([model.type intValue] == 13 || [model.type intValue] == 14){
//        return CurtainTabel;
//    }else if ([model.type intValue] == 21){
//        return AirCondiTabel;
//    }else{
//        return nil;
//    }
//}
- (NSData *)cleanUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // 从UTF-8转UTF-8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 剔除非UTF-8的字符
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}
@end
