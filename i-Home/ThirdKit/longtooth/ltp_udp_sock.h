//
//  ltp_udp_sock.h
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTGCDAsyncUdpSocket.h"
#import "ltp.h"
@interface LTPUdpSock : NSObject<LTPSock,LTGCDAsyncUdpSocketDelegate>
{
    LTGCDAsyncUdpSocket* sock;
    NSLock* lock;
}
-(void) close;
-(void) start;

@end
