//
//  ltp_event.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/30.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp.h"
static NSMutableArray* EVENT_QUEUE;
static NSCondition* EVENT_COND;
static id<LongToothEventHandler> EVENT_HANDLER;
void ltp_event_init(id<LongToothEventHandler> handler){
    EVENT_HANDLER = handler;
    EVENT_QUEUE = [[NSMutableArray alloc]init];
    EVENT_COND = [[NSCondition alloc]init];
}

@interface ltp_event:NSObject
@property (nonatomic) int code;
@property (nonatomic) NSString* _Nonnull ltid;
@property (nonatomic) NSString* _Nullable srv;
@property (nonatomic) NSData* _Nullable msg;
@property (nonatomic) id<LongToothAttachment> attachment;
@end;
@implementation ltp_event
@end

void ltp_event_fire(int code, NSString* _Nonnull ltid, NSString* _Nullable srv_str,NSData* _Nullable msg,id<LongToothAttachment> _Nullable attachment){
    @autoreleasepool {
        ltp_event* event = [[ltp_event alloc]init];
        event.code = code;
        event.ltid = ltid;
        event.srv = srv_str;
        event.msg = msg;
        event.attachment = attachment;
        [EVENT_COND lock];
        [EVENT_QUEUE addObject:event];
        [EVENT_COND signal];
        [EVENT_COND unlock];
    }
}

void ltp_event_maintain(){
    while(true){ //victor
    @autoreleasepool {
        ltp_event* event = nil;
        [EVENT_COND lock];
        if(EVENT_QUEUE.count==0){
            [EVENT_COND wait];
        }
        event = [EVENT_QUEUE objectAtIndex:0];
        [EVENT_QUEUE removeObjectAtIndex:0];
        [EVENT_COND unlock];
        [EVENT_HANDLER handle:event.code withLongToothId:event.ltid withServiceName:event.srv withMessage:event.msg withAttachment:event.attachment];
    }
    }
}
