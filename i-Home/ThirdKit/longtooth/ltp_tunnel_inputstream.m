//
//  ltp_tunnel_inputstream.m
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/26.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import "ltp.h"
ltp_tunnel_inputstream* ltp_tunnel_inputstream_create(const char* _Nonnull sessionid){
    @autoreleasepool {
        return [[ltp_tunnel_inputstream alloc]initWithSessionId:sessionid];
    }
}

@implementation ltp_tunnel_inputstream

-(id) initWithSessionId:(const char* _Nonnull) sid{
    if(self=[super init]){
        memset(buffer,0,sizeof(buffer));
        head = 0;
        size = 0;
        memcpy(sessionid,sid,4);
        recv_timestamp = 0;
        recv_timeout = 0;
        closed = FALSE;
        cond = [[NSCondition alloc]init];
    }
    return (self);
}

-(int) input:(const char *)data length:(size_t)len{

//   ltp_log(@"%s %d before",__FUNCTION__,idx);
    if(closed){
        return -1;
    }
    recv_timestamp = ltp_sys_uptime();
    [cond lock];
    // 20170911 by victor
    int32_t pidx = ltp_bytes_int32(&data[20]);
//    ltp_log(@"%s %d %d before",__FUNCTION__,pidx,_pidx);
    
    if ((pidx <_pidx)||(pidx-_pidx>64)) {
        [cond unlock];
        return -1;
    }
    int idx = pidx&0xff;
    
// 20170911 by victor
    
        int off = idx-head;
        if(size<64&&buffer[idx]==nil&&((off<64&&off>=0)||(off>=-255&&off<(-255+64)))){
            
            @autoreleasepool {
                @try {
                       buffer[idx]=[NSData dataWithBytes:&data[24] length:len-24];
                } @catch (NSException *exception) {
                    [cond unlock];
                    PT_Log(@"%s %@",__FUNCTION__,exception);
                    return -1;
                }
//                NSLog(@"%s %zu",__FUNCTION__,len);
//            [tempdata appendData:[NSData dataWithBytes:data length:len]];
                
            }
            size++;
            inputed+=(len-24);
            if(buffer[head]){
                [cond signal];
    //            ltp_log(@"%s %d",__FUNCTION__,idx);
            }
        }else{
            pidx = -1;
        }
    
    [cond unlock];
    //return idx;
    return pidx;
}
-(int64_t) countReaded{
    return readed;
}
-(int64_t) countInputed{
    return inputed;
}
-(int) read:(NSMutableData *)dest{
    int len = 0;
    [cond lock];// victor
    if(closed){
        //yixia neirong jiejue bingfa wenjian wenjian meiduwan tunnelbeiguanbi de qingkuang
        for (int i = 0; i< size; i++) {
            NSData* headdata = buffer[head];
            if(headdata!=nil){// victor
                buffer[head]=nil;
                size--;
                if(headdata.length>0){
                    head++;
                    head&=0xff;
                    _pidx ++; // 20170911 by victor
                    
                    readed+=headdata.length;
                    [dest appendData:headdata];
                    len+=headdata.length;
                    //                NSLog(@"%s %@ %zu %zu",__FUNCTION__,headdata,headdata.length,len);
                }
                
            }
            ltp_log(@"%s closed %d\r\n",__FUNCTION__,size);
            //        return -1;
            
        }
        if (len == 0) {
            len = -1;// victor
        }
    }
    
    while(!closed){
        @autoreleasepool {
        NSData* headdata = buffer[head];
        if(headdata==nil){
            if(len==0){
            [cond wait];
//            ltp_log(@"%s wakeup",__FUNCTION__);
            }else{
                break;
            }
        }
        if(!closed&&headdata!=nil){// victor
            
            buffer[head]=nil;
            size--;
            if(headdata.length>0){
                head++;
                head&=0xff;
                _pidx ++; // 20170911 by victor
                
                readed+=headdata.length;
                [dest appendData:headdata];
                len+=headdata.length;
//                NSLog(@"%s %@ %zu %zu",__FUNCTION__,headdata,headdata.length,len);
            }else{
                closed=1;
//                ltp_log(@"%s closed\r\n",__FUNCTION__);
                break;
            }
            
        }
        }
    }
    [cond unlock];
//    NSLog(@"%s %d",__FUNCTION__,len);
    return len;
}
-(int) keepalive:(int) pidx{
    int b=1;
            [cond lock];
    if (pidx>=_pidx) {
        int idx = pidx&0xff;

        int off = idx-head;
        if (pidx - _pidx>63) {
            b = 0;
        }
        if((off<64&&off>=0)||(off>=-255&&off<(-255+64))){
            NSData* dp = buffer[idx];
            if(dp==NULL){
                b=0;
            }
        }

    }
            [cond unlock];
    return b;
    
}
-(int64_t) idle:(int64_t) now{
    return now-recv_timestamp;
}

-(void) close{
    [cond lock];
    closed = 1;
    [cond signal];
    [cond unlock];
}

@end
