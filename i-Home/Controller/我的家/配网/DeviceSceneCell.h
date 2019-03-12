//
//  DeviceSceneCell.h
//  iThing
//
//  Created by Frank on 2018/8/3.
//  Copyright © 2018年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
@interface DeviceSceneCell : UITableViewCell
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *sceneName;
@property (nonatomic, assign)BOOL isSelectDevice;
@end
