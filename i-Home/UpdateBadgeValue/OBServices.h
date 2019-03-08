//
//  OBServices.h
//  OmniBox
//
//  Created by Divella on 16/7/15.
//  Copyright © 2016年 Victor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OBService.h"

@interface OBServices : NSObject
-(NSObject* )request:(NSString *)url params:(NSString *)params arguments:(NSMutableArray *)args;

- (void) registe:(NSString *)url observice:(OBService*)observice;



@end


