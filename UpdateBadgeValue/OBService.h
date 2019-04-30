//
//  OBService.h
//  OmniBox
//
//  Created by Divella on 16/7/15.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UPDATE_TABBAR_BADGEVALUE @"update/tabbar/badgevalue"
#define UPDATE_PERSONCENTER_BADGEVALUE @"update/personcenter/badgevalue"
#define UPDATE_APPDELEAGTE_BADGEVALUE @"update/appdelegate/badgevalue"



@protocol OBServiceDelegate <NSObject>
- (NSObject *) onRequest:(NSString *)context path:(NSString *)path params: (NSString *)params arguments:(NSMutableArray *)args;
@end

@interface OBService : NSObject
- (NSObject *) onRequest:(NSString *)context path:(NSString *)path params: (NSString *)params arguments:(NSMutableArray *)args;
@end
