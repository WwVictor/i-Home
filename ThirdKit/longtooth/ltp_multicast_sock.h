//
//  ltp_multicast_sock.h
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTGCDAsyncUdpSocket.h"
#import "ltp.h"
@interface LTPMulticastSock : NSObject<LTPSock,LTGCDAsyncUdpSocketDelegate>
{
    LTGCDAsyncUdpSocket *sock;
}
-(void) start;
@end

