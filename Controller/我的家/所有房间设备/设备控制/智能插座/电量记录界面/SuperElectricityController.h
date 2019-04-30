//
//  SuperElectricityController.h
//  iThing
//
//  Created by Frank on 2019/1/4.
//  Copyright © 2019 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface SuperElectricityController : UIViewController
@property (nonatomic, strong)DeviceInformationModel *deviceInfo;
@property (nonatomic, strong)DeviceStatusModel *deviceStatus;
@end

NS_ASSUME_NONNULL_END
