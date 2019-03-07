//
//  HomeFourTableViewCell.m
//  RecordLife
//
//  Created by 谢俊逸 on 15/03/2017.
//  Copyright © 2017 谢俊逸. All rights reserved.
//

#import "BarChartCell.h"
#import "XJYChart.h"
@interface BarChartCell ()<XJYChartDelegate>

@end

@implementation BarChartCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString*)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
      
      
      
   

      
      
   
  }
  return self;
}
- (void)configWithData:(NSMutableArray *)dataArray
{
    if (dataArray.count != 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 28)];
        titleLabel.text = Localized(@"tx_electricity_power");
        titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:21];
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 58, 60, 12)];
        label.text = @"(W.h)";
        label.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12];
        label.textColor = [UIColor black50PercentColor];
        [self.contentView addSubview:label];
        
        NSNumber *topNum = [NSNumber numberWithInt:0];
        NSMutableArray* itemArray = [[NSMutableArray alloc] init];
        UIColor* waveColor = [UIColor colorWithHexString:@"43A3FF" alpha:1.0];
        for (int i = 0; i < dataArray.count; i++) {
            
            int oldNum = [dataArray[i] intValue];
            NSNumber *dataNum = [NSNumber numberWithDouble:oldNum/3600.0];
            
            if ([dataNum doubleValue] > [topNum doubleValue]) {
                topNum = dataNum;
            }
            
            XBarItem* item1 = [[XBarItem alloc] initWithDataNumber:dataNum
                                                             color:waveColor
                                                      dataDescribe:[NSString stringWithFormat:@"%d",i+1]];
            [itemArray addObject:item1];
        }
        self.configuration = [XBarChartConfiguration new];
        self.configuration.isScrollable = NO;
        self.configuration.x_width = 40;
//        if ([topNum doubleValue] < 0.01) {
//            topNum = [NSNumber numberWithDouble:0.01];
//        }
        self.barChart =
        [[XBarChart alloc] initWithFrame:CGRectMake(15, 70, KScreenWidth-30, 230)
                           dataItemArray:itemArray
                               topNumber:topNum
                            bottomNumber:@(0)
                      chartConfiguration:self.configuration];
        self.barChart.barChartDelegate = self;
        [self.contentView addSubview:self.barChart];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel* dataLabel = [[UILabel alloc] init];
    dataLabel.text = @"(h)";
    dataLabel.backgroundColor = [UIColor whiteColor];
    dataLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:12];
    dataLabel.textColor = [UIColor black50PercentColor];
    [self.contentView addSubview:dataLabel];
    [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.barChart).offset(-15);
        make.right.mas_equalTo(self.contentView).offset(0);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(10);
    }];
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:nowDate];
//    NSInteger year = [dateComponent year];
//    NSInteger month = [dateComponent month];
//    NSInteger day = [dateComponent day];
    NSInteger hour = [dateComponent hour];
    if (hour>3&&hour<=21) {
        self.barChart.barChartView.contentOffset = CGPointMake((40+40*0.35)*(hour-3), self.barChart.barChartView.frame.origin.y-10);
    }
//    NSInteger minute = [dateComponent minute];
//    NSInteger second = [dateComponent second];
    
//    XBarItem* item1 = [[XBarItem alloc] initWithDataNumber:@(50.93)
//                                                     color:waveColor
//                                              dataDescribe:@"1"];
//    [itemArray addObject:item1];
//    XBarItem* item2 = [[XBarItem alloc] initWithDataNumber:@(90.04)
//                                                     color:waveColor
//                                              dataDescribe:@"2"];
//    [itemArray addObject:item2];
//    XBarItem* item3 = [[XBarItem alloc] initWithDataNumber:@(80.99)
//                                                     color:waveColor
//                                              dataDescribe:@"3"];
//    [itemArray addObject:item3];
//    XBarItem* item4 = [[XBarItem alloc] initWithDataNumber:@(70.48)
//                                                     color:waveColor
//                                              dataDescribe:@"4"];
//    [itemArray addObject:item4];
//    XBarItem* item5 = [[XBarItem alloc] initWithDataNumber:@(92.91)
//                                                     color:waveColor
//                                              dataDescribe:@"5"];
//    [itemArray addObject:item5];
//
//    XBarItem* item6 = [[XBarItem alloc] initWithDataNumber:@(74.93)
//                                                     color:waveColor
//                                              dataDescribe:@"6"];
//    [itemArray addObject:item6];
//    XBarItem* item7 = [[XBarItem alloc] initWithDataNumber:@(50.04)
//                                                     color:waveColor
//                                              dataDescribe:@"7"];
//    [itemArray addObject:item7];
//    XBarItem* item8 = [[XBarItem alloc] initWithDataNumber:@(44.99)
//                                                     color:waveColor
//                                              dataDescribe:@"8"];
//    [itemArray addObject:item8];
//    XBarItem* item9 = [[XBarItem alloc] initWithDataNumber:@(28.48)
//                                                     color:waveColor
//                                              dataDescribe:@"9"];
//    [itemArray addObject:item9];
//    XBarItem* item10 = [[XBarItem alloc] initWithDataNumber:@(52.91)
//                                                      color:waveColor
//                                               dataDescribe:@"10"];
//    [itemArray addObject:item10];
//    //
//    XBarItem* item11 = [[XBarItem alloc] initWithDataNumber:@(10.93)
//                                                      color:waveColor
//                                               dataDescribe:@"11"];
//    [itemArray addObject:item11];
//    XBarItem* item12 = [[XBarItem alloc] initWithDataNumber:@(17.04)
//                                                      color:waveColor
//                                               dataDescribe:@"12"];
//    [itemArray addObject:item12];
//    XBarItem* item13 = [[XBarItem alloc] initWithDataNumber:@(14.99)
//                                                      color:waveColor
//                                               dataDescribe:@"13"];
//    [itemArray addObject:item13];
//
//    XBarItem* item14 = [[XBarItem alloc] initWithDataNumber:@(50.93)
//                                                      color:waveColor
//                                               dataDescribe:@"14"];
//    [itemArray addObject:item14];
//    XBarItem* item15 = [[XBarItem alloc] initWithDataNumber:@(90.04)
//                                                      color:waveColor
//                                               dataDescribe:@"15"];
//    [itemArray addObject:item15];
//    XBarItem* item16 = [[XBarItem alloc] initWithDataNumber:@(80.99)
//                                                      color:waveColor
//                                               dataDescribe:@"16"];
//    [itemArray addObject:item16];
//    XBarItem* item17 = [[XBarItem alloc] initWithDataNumber:@(70.48)
//                                                      color:waveColor
//                                               dataDescribe:@"17"];
//    [itemArray addObject:item17];
//    XBarItem* item18 = [[XBarItem alloc] initWithDataNumber:@(92.91)
//                                                      color:waveColor
//                                               dataDescribe:@"18"];
//    [itemArray addObject:item18];
//
//    XBarItem* item19 = [[XBarItem alloc] initWithDataNumber:@(74.93)
//                                                      color:waveColor
//                                               dataDescribe:@"19"];
//    [itemArray addObject:item19];
//    XBarItem* item20 = [[XBarItem alloc] initWithDataNumber:@(50.04)
//                                                      color:waveColor
//                                               dataDescribe:@"20"];
//    [itemArray addObject:item20];
//    XBarItem* item21 = [[XBarItem alloc] initWithDataNumber:@(44.99)
//                                                      color:waveColor
//                                               dataDescribe:@"21"];
//    [itemArray addObject:item21];
//    XBarItem* item22 = [[XBarItem alloc] initWithDataNumber:@(28.48)
//                                                      color:waveColor
//                                               dataDescribe:@"22"];
//    [itemArray addObject:item22];
//    XBarItem* item23 = [[XBarItem alloc] initWithDataNumber:@(52.91)
//                                                      color:waveColor
//                                               dataDescribe:@"23"];
//    [itemArray addObject:item23];
//    //
//    XBarItem* item24 = [[XBarItem alloc] initWithDataNumber:@(10.93)
//                                                      color:waveColor
//                                               dataDescribe:@"24"];
//    [itemArray addObject:item24];
//    XBarItem* item25 = [[XBarItem alloc] initWithDataNumber:@(17.04)
//                                                      color:waveColor
//                                               dataDescribe:@"25"];
//    [itemArray addObject:item25];
//    XBarItem* item26 = [[XBarItem alloc] initWithDataNumber:@(14.99)
//                                                      color:waveColor
//                                               dataDescribe:@"26"];
//    [itemArray addObject:item26];
//
//    XBarItem* item27 = [[XBarItem alloc] initWithDataNumber:@(70.48)
//                                                      color:waveColor
//                                               dataDescribe:@"27"];
//    [itemArray addObject:item27];
//    XBarItem* item28 = [[XBarItem alloc] initWithDataNumber:@(92.91)
//                                                      color:waveColor
//                                               dataDescribe:@"28"];
//    [itemArray addObject:item28];
//
//    XBarItem* item29 = [[XBarItem alloc] initWithDataNumber:@(74.93)
//                                                      color:waveColor
//                                               dataDescribe:@"29"];
//    [itemArray addObject:item29];
//    XBarItem* item30 = [[XBarItem alloc] initWithDataNumber:@(50.04)
//                                                      color:waveColor
//                                               dataDescribe:@"30"];
//    [itemArray addObject:item30];
//    XBarItem* item31 = [[XBarItem alloc] initWithDataNumber:@(44.99)
//                                                      color:waveColor
//                                               dataDescribe:@"31"];
//    [itemArray addObject:item31];
}
#pragma mark XBarChartDelegate

- (void)userClickedOnBarAtIndex:(NSInteger)idx {
  NSLog(@"XBarChartDelegate touch Bat At idx %lu", idx);
}
@end
