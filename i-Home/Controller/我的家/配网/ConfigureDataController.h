//
//  ConfigureDataController.h
//  iThing
//
//  Created by Frank on 2018/7/31.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabaseModel.h"
@interface ConfigureDataController : UIViewController
@property (nonatomic, strong)NSString *wifiString;
@property (nonatomic, strong)NSString *passwordString;
@property (nonatomic, strong)DeviceMessageModel *deviceMessModel;
@property (nonatomic, strong)DeviceMessageModel *oldDeviceModel;
@end
