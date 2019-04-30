//
//  ltp_util.c
//  longtooth.oc
//
//  Created by Robin Shang on 2017/3/23.
//  Copyright © 2017年 Robin Shang. All rights reserved.
//
#include <sys/time.h>
#include <time.h>
#include "ltp.h"
#include "LTGCDAsyncSocket.h"
#import "LTSAMKeychainQuery.h"
#import "LTSAMKeychain.h"
#import <UIKit/UIKit.h>
int16_t ltp_bytes_int16(const char* _Nonnull buf) {
    int16_t i = 0;
    memcpy(&i,buf,2);
    return i;
}
void ltp_int16_bytes(int32_t i, char* _Nonnull buf) {
    memcpy(buf,&i,2);
}
int32_t ltp_bytes_int32(const char* _Nonnull buf) {
    int32_t i = 0;
    memcpy(&i,buf,4);
    return i;
}

void ltp_int32_bytes(int32_t i, char* _Nonnull buf) {
    memcpy(buf,&i,4);
}

void ltp_int64_bytes(int64_t l, char* _Nonnull buf) {
    memcpy(buf,&l,8);
}

int64_t ltp_bytes_int64(const char* _Nonnull buf) {
    int64_t l = 0;
    memcpy(&l,buf,8);
    return l;
}

void ltp_ltid_create(int64_t appid,int64_t id,char* _Nonnull ltid){
    
    int64_t l = ((id<<16)&0xFFFF000000000000LL)|appid;
    int i = (int)id;
    ltp_int64_bytes(l,ltid);
    ltp_int32_bytes(i,&ltid[8]);
}

int64_t ltp_str_int64(const char* _Nonnull str, int length) {
    int64_t result = 0;
    int negative = 0;
    int i = 0;
    int64_t limit = -0x7fffffffffffffffll;
    int64_t multmin;
    int digit;
    if (length > 0) {
        char firstChar = str[0];
        if (firstChar < 48) {
            if (firstChar == '-') {
                negative = 1;
                limit = 0x8000000000000000ll;
            } else if (firstChar != '+')
                return 0;
            
            if (length == 1)
                return 0;
            i++;
        }
        multmin = limit / 10;
        while (i < length) {
            
            digit = str[i++] - 48;
            if (digit < 0) {
                return 0;
            }
            if (result < multmin) {
                return 0;
            }
            result *= 10;
            if (result < limit + digit) {
                return 0;
            }
            result -= digit;
        }
    }
    return negative ? result : -result;
}

NSString* ltp_ltid_nsstring(NSData* ltid){
    char ltid_str[48];
    memset(ltid_str,0,48);
    ltp_ltid_str(ltid.bytes, ltid_str);
    return [NSString stringWithCString:ltid_str encoding:NSUTF8StringEncoding];

}
void ltp_ltid_str(const char* _Nonnull ltid,char* _Nonnull dest){
    int64_t l = ltp_bytes_int64(ltid);
    int64_t _appid = l & 0xffffffffffffLL;
    int64_t _id = (ltp_bytes_int32(&ltid[8])&0xFFFFFFFFLL) | ((l >> 16)&0x0000FFFF00000000LL);

    
    int64_t devid = _appid&0xFFFFFFFFFLL;
    int64_t appid = (int32_t)(_appid>>36&0xFFFLL);
    int64_t id = _id;
    int32_t a = (int32_t)(id>>36&0xFFF);
    int32_t b = (int32_t)(id>>24&0xFFF);
    int32_t c = (int32_t)(id>>12&0xFFF);
    int32_t d = (int32_t)(id&0xFFF);
    int size = sprintf(dest, "%lld.%lld.%d.%d.%d.%d",devid,appid,a,b,c,d);
    dest[size]=0;
    //    return devid+"."+appid+"."+a+"."+b+"."+c+"."+d;
}

void ltp_str_ltid(NSString* _Nonnull str, char* _Nonnull ltid) {

    NSArray* array = [str componentsSeparatedByString:@"."];
    if(array.count==6){
        int64_t devid = [array[0] longLongValue];
        int64_t appid = [array[1] longLongValue];
        int64_t a = [array[2] longLongValue];
        int64_t b = [array[3] longLongValue];
        int64_t c = [array[4] longLongValue];
        int64_t d = [array[5] longLongValue];

        appid = ((appid & 0xFFFLL) << 36) | (devid & 0xFFFFFFFFFLL);
        int64_t id = (a & 0xFFFLL) << 36 | (b & 0xFFFLL) << 24 | ((c & 0xFFFLL) << 12) | (d & 0xFFFLL);
    
        ltp_ltid_create(appid, id, ltid);
    }
}

void ltp_ltid_bytes(const char* _Nonnull ltid,char* _Nonnull dest){
    memcpy(dest,ltid,12);
}
void ltp_bytes_ltid(const char* _Nonnull bytes, char* _Nonnull ltid) {
    memcpy(ltid, bytes, 12);
}

void ltp_bytes_ltaddr(const char* _Nonnull data,char* _Nonnull ltaddr) {
    memcpy(ltaddr,data,6);
}
void ltp_ltaddr_bytes(const char* _Nonnull ltaddr,char* _Nonnull dest){
    memcpy(dest,ltaddr,6);
}

size_t ltp_hexstr_bytes(const char* _Nonnull hex, char* _Nonnull out) {

    size_t l = strlen(hex);
    int i = 0;
    for (; i < l; i += 2) {
        int b = hex[i];
        if (b > 96 && b < 103) {
            b = b - 87;
        } else if (b > 64 && b < 71) {
            b = b - 55;
        } else if (b > 47 && b < 58) {
            b = b - 48;
        } else {
            //				throw new IllegalArgumentException(s);
        }
        int b1 = hex[i + 1];
        if (b1 > 96 && b1 < 103) {
            b1 = b1 - 87;
        } else if (b1 > 64 && b1 < 71) {
            b1 = b1 - 55;
        } else if (b1 > 47 && b1 < 58) {
            b1 = b1 - 48;
        } else {
            //				throw new IllegalArgumentException(s);
        }
        out[i / 2] = (char) (b << 4 | b1);
    }
    return l/2;
    //		return array;
}

int64_t ltp_sys_uptime() {
    
    return ltp_sys_clock();
}
int64_t ltp_sys_clock(){
    
    int64_t lcurtime = 0;
    struct timeval tv;
    gettimeofday(&tv, NULL);
    lcurtime = tv.tv_sec * 1000 + tv.tv_usec / 1000;
    return lcurtime;

}

int lt_hash(const void* val, ssize_t val_len)
{
    const char *end=val+val_len;
    const char *val_temp = (char *)val;
    int  hash;
    for (hash = 0; val_temp < end; val_temp++)
    {
        hash *= 16777619;
        hash ^= val_temp[0];
    }
    return (hash);
    
}

NSData* _Nullable ltp_proper_ipaddr(NSString* _Nonnull ipAddr, uint16_t ipPort)
{
    NSError *addresseError = nil;
    NSArray *addresseArray = [LTGCDAsyncSocket lookupHost:ipAddr
                                                     port:ipPort
                                                    error:&addresseError];
    if (addresseError) {
        NSLog(@"address error %@",addresseError);
    }
    
    NSData *ipv6Addr = nil;
    NSData *ipv4Addr = nil;
    for (NSData *addrData in addresseArray) {
        if ([LTGCDAsyncSocket isIPv6Address:addrData]) {
            ipv6Addr = addrData;
        }else if([LTGCDAsyncSocket isIPv4Address:addrData]){
            ipv4Addr = addrData;
        }
    }
    return ipv6Addr==nil?ipv4Addr:ipv6Addr;
}
NSString* ltp_hardware_uuid(){
    NSString *ret = nil;
    NSString *tempRet = nil;
#if TARGET_OS_IPHONE

    NSError *error1 = nil;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appName=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    ret  = [userDefaults objectForKey:@"ltid_uuid"];
    if (ret == nil)
    {
        
        tempRet = [LTSAMKeychain passwordForService:appName account:@"incoding" error:&error1];
        
        if (tempRet == nil) {
            
            ret  = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [userDefaults setObject:ret forKey:@"ltid_uuid"];
            [userDefaults synchronize];
            NSError *error = nil;
            LTSAMKeychainQuery *query = [[LTSAMKeychainQuery alloc] init];
            query.service = appName;
            query.account = @"incoding";
            query.password = ret;
            query.synchronizationMode = LTSAMKeychainQuerySynchronizationModeNo;
            
            @try {
                [query save:&error];
            }
            @catch (NSException *exception) {
                NSString* s = [NSString stringWithFormat:@"%@;%@",error1==nil?@"nil":[error1 description],error==nil?@"nil":[error description]];
                @throw [NSException exceptionWithName:@"LTSAMKeychain" reason:s userInfo:nil];
            }
            return ret;
            
        }else{
      
        [userDefaults setObject:tempRet forKey:@"ltid_uuid"];
        [userDefaults synchronize];
        ret = tempRet;
            
        }
    }
    
#elif TARGET_OS_MAC
    io_service_t platformExpert ;
    platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice")) ;
    
    if (platformExpert) {
        CFTypeRef serialNumberAsCFString ;
        serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, CFSTR("IOPlatformUUID"), kCFAllocatorDefault, 0) ;
        if (serialNumberAsCFString) {
            ret = NSUserName();
            ret = [ret stringByAppendingString:@"-"];
            ret = [ret stringByAppendingString:[(__bridge NSString *)(CFStringRef)serialNumberAsCFString copy]];
            CFRelease(serialNumberAsCFString); serialNumberAsCFString = NULL;
        }
        IOObjectRelease(platformExpert);
    }
    
#endif
    
    
    return ret;
    
    
}
void ltp_log(NSString* _Nonnull format,...){
//    NSLog(<#NSString * _Nonnull format, ...#>)
    va_list argp;
    va_start (argp, format); /* 将可变长参数转换为va_list */
    NSLogv (format, argp); /* 将va_list传递给子函数 */
    va_end (argp);
}

BOOL ltp_bytes_equals(const char* _Nonnull bytes1,const char* _Nonnull bytes2,size_t len){
    return memcmp(bytes1, bytes2, len)==0;
}
