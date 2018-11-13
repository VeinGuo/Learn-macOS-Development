//
//  VGDevice.h
//  Device
//
//  Created by Vein on 2018/11/13.
//  Copyright © 2018 Vein. All rights reserved.
//
#import "VGDevice.h"

//for mac address
#include <IOKit/IOKitLib.h>
#include <IOKit/network/IOEthernetInterface.h>
#include <IOKit/network/IONetworkInterface.h>
#include <IOKit/network/IOEthernetController.h>

#include <ifaddrs.h>
#include <net/if.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if_dl.h>

static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices);
static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress, UInt8 bufferSize);

@implementation VGDevice

+ (NSString *)hostName {
    return [NSHost currentHost].name;
}

//获取build version
+ (NSString *)buildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

//获取Bundle version
+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//获取BundleID
+ (NSString *)bundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

//获取app的名字
+ (NSString *)appName {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    return appName;
}

//获取ip地址
+ (NSString *)ipAddresses {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Get NSString from C String
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)systemVersion {
    return [NSProcessInfo processInfo].operatingSystemVersionString;
}

+ (NSString *)getSysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);

    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);

    NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];

    free(answer);
    return results;
}

+ (NSString *)platform {
    return [self getSysInfoByName:"hw.machine"];
}

+ (NSString *)hardwareModel {
    return [self getSysInfoByName:"hw.model"];
}

+ (VGDeviceFamily)deviceFamily {
    NSString *hardwareModelVal = [self hardwareModel];

    if ([hardwareModelVal hasPrefix:@"Macmini"]) {
        return VGDeviceFamilyMacMini;
    } else if ([hardwareModelVal hasPrefix:@"MacBookAir"]) {
        return VGDeviceFamilyMacBookAir;
    } else if ([hardwareModelVal hasPrefix:@"MacBookPro"]) {
        return VGDeviceFamilyMacBookPro;
    } else if ([hardwareModelVal hasPrefix:@"MacPro"]) {
        return VGDeviceFamilyMacPro;
    } else if ([hardwareModelVal hasPrefix:@"iMac"]) {
        return VGDeviceFamilyiMac;
    } else if ([hardwareModelVal hasPrefix:@"MacBook"]) {
        return VGDeviceFamilyMacBook;
    }
    return VGDeviceFamilyUnknown;
}

+ (NSString *)deviceModel {
    switch ([self deviceFamily]) {
        case VGDeviceFamilyiMac:
            return @"iMac";
            break;
        case VGDeviceFamilyMacBookAir:
            return @"MacBook Air";
            break;
        case VGDeviceFamilyMacPro:
            return @"Mac Pro";
            break;
        case VGDeviceFamilyMacBook:
            return @"MacBook";
            break;
        case VGDeviceFamilyMacMini:
            return @"Mac mini";
            break;
        case VGDeviceFamilyMacBookPro:
            return @"MacBook Pro";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)MACAddress {
    kern_return_t kernResult = KERN_SUCCESS;
    io_iterator_t intfIterator;
    UInt8 lMACAddress[kIOEthernetAddressSize]; //lMACAddress for local instance

    kernResult = FindEthernetInterfaces(&intfIterator);
    
    NSString *address = @"";
    
    if (KERN_SUCCESS != kernResult) {
        printf("FindEthernetInterfaces returned 0x%08x\n", kernResult);
    } else {
        kernResult = GetMACAddress(intfIterator, lMACAddress, sizeof(address));

        if (KERN_SUCCESS != kernResult) {
            printf("GetMACAddress returned 0x%08x\n", kernResult);
            return nil;
        } else {
            return [NSString stringWithFormat:@"%02X:%02x:%02X:%02X:%02X:%02X", lMACAddress[0], lMACAddress[1], lMACAddress[2], lMACAddress[3], lMACAddress[4], lMACAddress[5]];
        }
    }

    (void)IOObjectRelease(intfIterator); // Release the iterator.
    return @"";
}

static kern_return_t FindEthernetInterfaces(io_iterator_t *matchingServices)
{
    kern_return_t           kernResult;
    CFMutableDictionaryRef  matchingDict;
    CFMutableDictionaryRef  propertyMatchDict;
    
    matchingDict = IOServiceMatching(kIOEthernetInterfaceClass);
    
    if (NULL == matchingDict) {
        printf("IOServiceMatching returned a NULL dictionary.\n");
    }
    else {
        propertyMatchDict = CFDictionaryCreateMutable(kCFAllocatorDefault, 0,
                                                      &kCFTypeDictionaryKeyCallBacks,
                                                      &kCFTypeDictionaryValueCallBacks);
        
        if (NULL == propertyMatchDict) {
            printf("CFDictionaryCreateMutable returned a NULL dictionary.\n");
        }
        else {
            CFDictionarySetValue(propertyMatchDict, CFSTR(kIOPrimaryInterface), kCFBooleanTrue);
            CFDictionarySetValue(matchingDict, CFSTR(kIOPropertyMatchKey), propertyMatchDict);
            CFRelease(propertyMatchDict);
        }
    }
    kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matchingDict, matchingServices);
    if (KERN_SUCCESS != kernResult) {
        printf("IOServiceGetMatchingServices returned 0x%08x\n", kernResult);
    }
    
    return kernResult;
}

static kern_return_t GetMACAddress(io_iterator_t intfIterator, UInt8 *MACAddress, UInt8 bufferSize) {
    io_object_t intfService;
    io_object_t controllerService;
    kern_return_t kernResult = KERN_FAILURE;
    
    if (bufferSize < kIOEthernetAddressSize) {
        return kernResult;
    }
    
    bzero(MACAddress, bufferSize);
    
    while ((intfService = IOIteratorNext(intfIterator))) {
        CFTypeRef MACAddressAsCFData;
        kernResult = IORegistryEntryGetParentEntry(intfService,
                                                   kIOServicePlane,
                                                   &controllerService);
        
        if (KERN_SUCCESS != kernResult) {
            printf("IORegistryEntryGetParentEntry returned 0x%08x\n", kernResult);
        } else {
            MACAddressAsCFData = IORegistryEntryCreateCFProperty(controllerService,
                                                                 CFSTR(kIOMACAddress),
                                                                 kCFAllocatorDefault,
                                                                 0);
            if (MACAddressAsCFData) {
                CFDataGetBytes(MACAddressAsCFData, CFRangeMake(0, kIOEthernetAddressSize), MACAddress);
                CFRelease(MACAddressAsCFData);
            }
            (void)IOObjectRelease(controllerService);
        }
        (void)IOObjectRelease(intfService);
    }
    
    return kernResult;
}


@end
