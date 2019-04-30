//
//  OBServices.m
//  OmniBox
//
//  Created by Divella on 16/7/15.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import "OBServices.h"
#import "AppDelegate.h"
@implementation OBServices

-(void)registe:(NSString *)url observice:(OBService *)observice
{
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];    
    if (myDelegate.concurrentHashMap == NULL) {
        myDelegate.concurrentHashMap = [[NSMutableDictionary alloc] init];
    }
    [myDelegate.concurrentHashMap setValue:observice forKey:url];
//    NSLog(@"-----%@",myDelegate.concurrentHashMap);
}

- (NSObject *)request:(NSString *)url params:(NSString *)params arguments:(NSMutableArray *)args
{
    AppDelegate *myDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    OBService * s = myDelegate.concurrentHashMap[url];
//    NSLog(@"======%@ s=%@",url,s);
    if (s != nil) {
        return [s onRequest:url path:nil params:params arguments:args];
    }
    return nil;
}
@end
