//
//  VGDevice.h
//  Device
//
//  Created by Vein on 2018/11/13.
//  Copyright © 2018 Vein. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    VGDeviceFamilyMacBookAir,
    VGDeviceFamilyMacBookPro,
    VGDeviceFamilyMacBook,
    VGDeviceFamilyMacPro,
    VGDeviceFamilyiMac,
    VGDeviceFamilyMacMini,
    VGDeviceFamilyUnknown
} VGDeviceFamily;

NS_ASSUME_NONNULL_BEGIN

@interface VGDevice : NSObject

+ (NSString *)hostName;

//获取build version
+ (NSString *)buildVersion;
//获取Bundle version
+ (NSString *)appVersion;
//获取BundleID
+ (NSString *)bundleID;
//获取app的名字
+ (NSString *)appName;
+ (NSString *)ipAddresses;

+ (VGDeviceFamily)deviceFamily;
+ (NSString *)deviceModel;
+ (NSString *)systemVersion;

+ (NSString *)MACAddress;

@end

NS_ASSUME_NONNULL_END
