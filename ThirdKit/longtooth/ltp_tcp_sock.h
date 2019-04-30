//
//  ltp_tcp_sock.h
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTGCDAsyncSocket.h"

#include "ltp.h"

@interface LTPTcpSock : NSObject<LTPSock,LTGCDAsyncSocketDelegate>
{
    LTGCDAsyncSocket *sock;
    NSLock* lock;
}
-(void) connect:(NSString*) host port:(NSUInteger) port;
-(void) close;
@end
