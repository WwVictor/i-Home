//
//  YearElectricityCell.h
//  iThing
//
//  Created by Frank on 2018/11/6.
//  Copyright © 2018 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
#import "XJYChart.h"
static NSString* kYearElectricityCell = @"YearElectricityCell";
NS_ASSUME_NONNULL_BEGIN

@interface YearElectricityCell : UITableViewCell
@property (nonatomic, strong) XBarChartConfiguration *configuration;
@property (nonatomic, strong) XBarChart* barChart;
-(void)configWithData:(NSMutableArray *)dataArray andWithTime:(NSMutableArray *)timeArray;
@end

NS_ASSUME_NONNULL_END
