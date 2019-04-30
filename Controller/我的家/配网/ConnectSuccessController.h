//
//  ConnectSuccessController.h
//  iThing
//
//  Created by Frank on 2019/1/10.
//  Copyright © 2019 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface ConnectSuccessController : UIViewController
@property (nonatomic, strong)NSString *wifiString;
@property (nonatomic, strong)NSString *passwordString;
@property (nonatomic, strong)DeviceMessageModel *deviceMessModel;
@property (nonatomic, strong)DeviceMessageModel *oldDeviceModel;
@end

NS_ASSUME_NONNULL_END
