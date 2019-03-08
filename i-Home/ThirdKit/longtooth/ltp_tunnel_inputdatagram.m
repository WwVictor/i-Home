//
//  ltp_tunnel_inputdatagram.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/7/31.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp.h"
#define DATABUFLEN 32
ltp_tunnel_inputdatagram* ltp_tunnel_inputdatagram_create(){
    @autoreleasepool {
        return [[ltp_tunnel_inputdatagram alloc]init];
    }
}

@implementation ltp_tunnel_inputdatagram

-(id) init{
    if(self=[super init]){
        h=0;
        t=0;
        l=0;
        closed = FALSE;
        cond = [[NSCondition alloc]init];
        recv_timestamp = ltp_sys_uptime();
    }
    return (self);
}

-(void) close{
    [cond lock];
    closed = true;
    [cond signal];
    [cond unlock];
}


-(void) input:(const char* _Nonnull) data length:(size_t) len{
    recv_timestamp = ltp_sys_uptime();
    [cond lock];
    if(l==DATABUFLEN){
        h++;
        h%=DATABUFLEN;
        l--;
    }
    buf[t]=[NSData dataWithBytes:&data[20] length:len-20];
    t++;
    t%=DATABUFLEN;
    l++;
    if(l==1){
        [cond signal];
    }
    [cond unlock];
}

-(NSInteger) read:(NSMutableData* _Nullable) dest{
    NSInteger i = -1;
    [cond lock];
    while (!closed){
        if(l==0){
            [cond wait];
        }else{
            NSData* data = buf[h];
            buf[h] = nil;
            [dest appendData:data];
            i = data.length;
            h++;
            h%=DATABUFLEN;
            l--;
            break;
        }
    }
    [cond unlock];
    return i;
}
-(int64_t) idle:(int64_t) now{
    return now-recv_timestamp;
}
@end
