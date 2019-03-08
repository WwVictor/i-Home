//
//  ElectricityRecordController.h
//  iThing
//
//  Created by Frank on 2018/8/2.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJYViewController.h"
#import "MyFileHeader.h"

@interface ElectricityRecordController : XJYViewController
@property (nonatomic, strong)DeviceInformationModel *deviceInfo;
@property (nonatomic, strong)DeviceStatusModel *deviceStatus;
@end
