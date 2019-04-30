//
//  HomeFourTableViewCell.h
//  RecordLife
//
//  Created by 谢俊逸 on 15/03/2017.
//  Copyright © 2017 谢俊逸. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileHeader.h"
#import "XJYChart.h"
static NSString* kBarChartCell = @"BarChartCell";

@interface BarChartCell : UITableViewCell
@property (nonatomic, strong) XBarChartConfiguration *configuration;
@property (nonatomic, strong) XBarChart* barChart;
-(void)configWithData:(NSMutableArray *)dataArray;
@end
