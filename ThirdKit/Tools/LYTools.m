//
//  LYTools.m
//  LYSmartCommunity-owner
//
//  Created by xiaocui on 17/3/6.
//  Copyright © 2017年 liaoyuan. All rights reserved.
//

#import "LYTools.h"
#import <CommonCrypto/CommonDigest.h>
#import <iconv.h>
#define CC_SHA512_DIGEST_LENGTH     64          /* digest length in bytes */
#define CC_SHA512_BLOCK_BYTES      128          /* block size in bytes */
@implementation LYTools
//通过RGB获得颜色
+ (UIColor *)getColorFromRGB:(NSString *)inColorString
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

/**
 通过Hex取色
 
 @param color hex字符串
 @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


/**
 通过给定标准字符串生成制定大小和颜色的富文本字符串
 
 @param font 大小
 @param color 颜色
 @param string 给定字符串
 @return 富文本字符串
 */
+ (NSAttributedString *)attributedStringWithFont:(CGFloat)font color:(UIColor *)color string:(NSString *)string
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary]; // 创建属性字典
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:font]; // 设置font
    attrs[NSForegroundColorAttributeName] = color; // 设置颜色
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:string attributes:attrs]; // 初始化富文本占位字符串
    return attStr;
}



//动态计算lable的高度
+(CGFloat )getHeighWithTitle:(NSString *)title font:(UIFont *)font width:(float)width {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
    
}

+(CGFloat) widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height

{
    
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.width;
    
}




/**
 字典转json
 @param dict 字典
 @return json串
 */
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}


/**
 jsonstring 转字典
 @param jsonString 字符串
 @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}




/**
 jsonstring 转数组
 
 @param jsonString jsonString 字符串
 @return 数组
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}


/**
 数组转json
 @param arr 数组
 @return json串
 */
+ (NSString *)jsonStringWithArray:(NSArray *)arr
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}


/**
 字符串比较
 
 @param string 第一个字符串
 @param otherString 第二个字符串
 @return 返回类型
 */
+(BOOL)compareString:(NSString *)string WithAnotherString:(NSString *)otherString{
    if ([string compare:otherString]==NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}
/**
 *判断是否是手机号
 */
+(BOOL)isTelphoneWithPhonenum:(NSString *)phonenumber{
    
    NSString *telRegex = @"^1[345678]\\d{9}$";
    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:phonenumber];
}




/**
 *获取当前的日期  返回的是时间戳
 */

+(NSString *)catchTheStartTime{
    
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    
    return timeString;
}






+ (NSString *)base64StringFromText:(NSString *)text{
    
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    
    return base64String;
    
}

//获取当前的日期
+(NSString *)catchThecurrentTime{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}


//获取当前的日期
+(NSString *)catchCurrentTime{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}

//获取当前的日期
+(NSString *)catchCurrentHourAndMin{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"HH:mm"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    return DateTime;
}
/**
 登录成功之后获取用户信息
 
 @param responseObject 拿到userID phone 的字典 （phone 只在注册成功直接登录时要传）
 @param phoneStr phone
 */






//// 主界面
//+ (void)setupTabBarViewController
//{
//
//
//    NSString *communityType =  [[NSUserDefaults standardUserDefaults]objectForKey:@"communityType"];
//
//    if ([communityType isEqualToString:@"1"]) {
//
//        NewBaseTabBarViewController *tabBarViewController =[[NewBaseTabBarViewController alloc]init];
//        tabBarViewController.view.backgroundColor = [UIColor whiteColor];
//        RTRootNavigationController *rootVC= [[RTRootNavigationController alloc] initWithRootViewControllerNoWrapping:tabBarViewController];
//        [UIApplication sharedApplication].keyWindow.rootViewController= rootVC;
//
//
//    }else{
//
//        CYLBaseTabBarViewController *tabBarControllerConfig =[[CYLBaseTabBarViewController alloc]init];
//
//        [CYLPlusButtonSubclass registerPlusButton];
//
//        CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
//
//        RTRootNavigationController *rootVC= [[RTRootNavigationController alloc] initWithRootViewControllerNoWrapping:tabBarController];
//        [UIApplication sharedApplication].keyWindow.rootViewController= rootVC;
//
//    }
//
//
//}





// 将image转为base64 string
+ (NSString *)transImageToBase64Str:(UIImage *)newImage
{
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.8f);
    NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *imageSrc = [NSString stringWithFormat:@"data:image/jpeg;base64,%@",encodedImageStr];
    return imageSrc;
}
// 车牌号
+ (BOOL)checkCarID:(NSString *)carID
{
    NSString *carRegex = @"^[\u4e00-\u9fa5][a-zA-Z](([DF](?![a-zA-Z0-9]*[IO])[0-9]{5})|([0-9]{5}[DF]))|^[冀豫云辽黑湘皖鲁苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼渝京津沪新京军空海北沈兰济南广成使领A-Z]{1}[a-zA-Z0-9]{5}[a-zA-Z0-9挂学警港澳]{1}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    return [carTest evaluateWithObject:carID];
    return YES;
}


/**
 读取json文件
 
 @param jsonFileName json文件名
 @return 返回的数组
 */
+ (NSArray *)getAllTextValuesFromJsonFile:(NSString *)jsonFileName
{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];;
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    return arr;
}



/**
 提示框  无操作
 
 @param title 标题
 @param message 信息
 @param vc 显示控制器
 */
+ (void)showAlertControllerWithTitle:(NSString *)title msg:(NSString *)message onController:(UIViewController *)vc{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:sure];
    [vc presentViewController:alertController animated:YES completion:nil];
}
/**
 alertControlelr
 
 @param title 标题
 @param message 提示信息
 @param vc 显示在当前vc
 @param sureAction 确定操作
 */
+ (void)showAlertControllerWithTitle:(NSString *)title msg:(NSString *)message onController:(UIViewController *)vc action:(void(^)(void))sureAction{
    
    
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sureAction();
    }];
    [alertController addAction:cancel];
    [alertController addAction:sure];
    
    [vc presentViewController:alertController animated:YES completion:nil];
    
}


+ (void)showTextFiledAlertControllerWithTitle:(NSString *)title
                                          msg:(NSString *)message
                                    tfSetting:(void(^)(UITextField *textField))tfSetting
                                 onController:(UIViewController *)vc
                                       action:(void(^)(NSString *tfValue))sureAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        tfSetting(textField);
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *tf = alert.textFields[0];
        sureAction(tf.text);
    }]];
    [vc presentViewController:alert animated:YES completion:nil];
}



/**
 int 转 2进制
 
 @param tmpid int
 @param length 字符串长度
 @return 返回的字符串
 */
+ (NSString *)decimalTOBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;
    
}
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (UIImage *)qrCodeImageWithInfo:(NSString *)info  width:(CGFloat)width{
    
    if (!info) {
        return nil;
    }
    
    NSData *strData = [info dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    //创建二维码滤镜
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:strData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    //颜色滤镜
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setDefaults];
    [colorFilter setValue:qrImage forKey:kCIInputImageKey];
    [colorFilter setValue:[CIColor colorWithRed:0 green:0 blue:0] forKey:@"inputColor0"];
    CIImage *colorImage = colorFilter.outputImage;
    //返回二维码
    CGFloat scale = width/31;
    UIImage *codeImage = [UIImage imageWithCIImage:[colorImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)]];
    return codeImage;
}






//数组排序  顺序倒序  自己传值
+(void)mySort:(NSMutableArray*)mutArray andInterger:(NSInteger)interger{
    id tempObj = nil;
    unsigned long flag = mutArray.count-1;
    while (flag>0) {
        int k = (int)flag;
        flag = 0;
        for (int j =0; j<k; j++) {
            NSInteger order = interger;
            if ([[mutArray[j]description]compare:[mutArray[j+1]description]]==-order) {
                tempObj = mutArray[j];
                mutArray[j]=mutArray[j+1];
                mutArray[j+1]=tempObj;
                flag=j;
            }
        }
    }
}



+(NSString*)sha512HashFor:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA512_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_SHA512_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
//    NSLog(@"ret == %ld",ret.length);
    return ret;
}


+(NSString *)getLocalLanguage
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"] isEqualToString:@"zh-Hans"]) {//开头匹配
        return @"zh-CN";
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"] isEqualToString:@"zh-Hant"]) {
        return @"zh-HK";
    }else {
        return @"en";
    }
}


/**
 *  重新绘制图片
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color withImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
+(BOOL)isCharacterString:(NSString *)string
{
    NSString *regex = @"[~`!@#$%^&*()_+=[]|{};':\",./<>?]{,}/€£¥,’";//规定的特殊字符，可以自己随意添加
    
    //计算字符串长度
    NSInteger str_length = [string length];
    
    NSInteger allIndex = 0;
    for (int i = 0; i<str_length; i++) {
        //取出i
        NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
        if([regex rangeOfString:subStr].location != NSNotFound)
        {  //存在
            allIndex++;
        }
    }
    
    if (allIndex > 0) {
        //纯特殊字符
        return YES;
    }
    else
    {
        //非纯特殊字符
        return NO;
    }
}
+(BOOL)isAllCharacterString:(NSString *)string
{
    NSString *regex = @"[~`!@#$%^&*()_+=[]|{};':\",./<>?]{,}/€£¥,’";//规定的特殊字符，可以自己随意添加
    
    //计算字符串长度
    NSInteger str_length = [string length];
    
    NSInteger allIndex = 0;
    for (int i = 0; i<str_length; i++) {
        //取出i
        NSString *subStr = [string substringWithRange:NSMakeRange(i, 1)];
        if([regex rangeOfString:subStr].location != NSNotFound)
        {  //存在
            allIndex++;
        }
    }
    
    if (allIndex > 0) {
        //纯特殊字符
        return YES;
    }
    else
    {
        //非纯特殊字符
        return NO;
    }
}




+(void)postBossDemoWithUrl:(NSString*)url

                     param:(NSDictionary*)param

                   success:(void(^)(NSDictionary *dict))success

                      fail:(void (^)(NSError *error))fail

{
//    AFHTTPSessionManager *manager =  [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];// 请求返回的格式为json
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"application/json", @"text/javascript",@"text/html", nil];
//    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData *data = (NSData *)responseObject;
//        if (data.length == 0) {
//            NSError *error;
//            fail(error);
////            success(nil);
//        }else{
//            NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
////            NSString *str1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            if (dict == nil) {
//                NSMutableDictionary *dicts = [NSMutableDictionary dictionary];
//                [dicts setValue:str forKey:@"result"];
//                // 请求成功数据处理
//                success(dicts);
//            }else{
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                    // 请求成功数据处理
//                    success(dict);
//
//                } else {
//
//                }
//            }
//
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        fail(error);
//        NSLog(@"请求失败error=%@", error);
//    }];

    
}
+(void)postBossHeaderDemoWithUrl:(NSString *)url param:(NSDictionary *)param success:(void (^)(NSDictionary *))success fail:(void (^)(NSError *))fail
{
//        NSString *accessPath = url;
//        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
////    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:accessPath parameters:param error:nil];
//        request.timeoutInterval = 10;
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//
//        NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
////            NSData *data = (NSData *)responseObject;
////            if (data.length == 0 ) {
////
////            }
////            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//
//            if (!error) {
//                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
////                NSLog(@"-----responseObject===%@+++++",dict);
//                if ([dict isKindOfClass:[NSDictionary class]]) {
//                        // 请求成功数据处理
//                        success(dict);
//
//                } else {
//
//                }
//            } else {
//                fail(error);
//                NSLog(@"请求失败error=%@", error);
//            }
//        }];
//        [task resume];
}
+(void)getBossDemoWithUrl:(NSString*)url

                     param:(NSDictionary*)param

                   success:(void(^)(NSDictionary *dict))success

                      fail:(void (^)(NSError *error))fail

{
//    NSString *accessPath = url;
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:accessPath parameters:param error:nil];
//    request.timeoutInterval = 5;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        NSError * error1;
//        NSStringEncoding enc = kCFStringEncodingUTF8;
//        NSString* strdata = [[NSString alloc]initWithData:responseObject encoding:enc];//在将NSString类型转为NSData
//        NSData * data = [strdata dataUsingEncoding:NSUTF8StringEncoding];//这样解决的乱码问题。
//        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1 ];
//        if (!error) {
//            if ([json isKindOfClass:[NSDictionary class]]) {
//                    // 请求成功数据处理
//                    success(json);
//            } else {
//                
//            }
//        } else {
//            NSLog(@"请求失败error=%@", error);
//        }
//    }];
//    [task resume];
    
}
- (NSData *)cleanDataUTF8:(NSData *)data {
    iconv_t cd = iconv_open("UTF-8", "UTF-8"); // 从UTF-8转UTF-8
    int one = 1;
    iconvctl(cd, ICONV_SET_DISCARD_ILSEQ, &one); // 剔除非UTF-8的字符
    
    size_t inbytesleft, outbytesleft;
    inbytesleft = outbytesleft = data.length;
    char *inbuf  = (char *)data.bytes;
    char *outbuf = malloc(sizeof(char) * data.length);
    char *outptr = outbuf;
    if (iconv(cd, &inbuf, &inbytesleft, &outptr, &outbytesleft)
        == (size_t)-1) {
        NSLog(@"this should not happen, seriously");
        return nil;
    }
    NSData *result = [NSData dataWithBytes:outbuf length:data.length - outbytesleft];
    iconv_close(cd);
    free(outbuf);
    return result;
}


@end
