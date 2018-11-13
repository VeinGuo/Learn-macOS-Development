//
//  VGWiFiClient.m
//  WiFi
//
//  Created by Vein on 2018/11/12.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "VGWiFiClient.h"

NSString * const VGWiFiClientConnectionInterrupted = @"VGWiFiClientConnectionInterrupted";
NSString * const VGWiFiClientConnectionInvalidated = @"VGWiFiClientConnectionInvalidated";

NSErrorDomain const VGWiFiClientError = @"WiFiClientError";

@interface VGWiFiClient () <CWEventDelegate>

@property (nonatomic, assign) VGWiFiClientState state;

@property (nonatomic, strong) CWWiFiClient *wifiClinet;
@property (nonatomic, weak) CWInterface *currentInterface;

// Info
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic, copy) NSString *bssid;
@property (nonatomic, assign) NSInteger rssi;
@property (nonatomic, assign) double transmitRate;

// Channel
@property (nonatomic, assign) NSInteger channelNumber;
@property (nonatomic, assign) CWChannelWidth channelWidth;
@property (nonatomic, assign) CWChannelBand channelBand;

@property (nonatomic, copy) NSString *hardwareAddress;
@property (nonatomic, assign) CWPHYMode activePHYMode;
@property (nonatomic, assign) CWInterfaceMode interfaceMode;

@end

@implementation VGWiFiClient

+ (VGWiFiClient *)sharedWiFiClient {
    static id shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.wifiClinet = [CWWiFiClient sharedWiFiClient];
        _state = VGWiFiClientStateIdle;
        [self startMonitorEvent];
    }
    return self;
}

- (void)startMonitorEvent {
    self.wifiClinet.delegate = self;
    NSLog(@"Start Wifi Clinet Monitor Event");
    NSError *error = nil;
    [self.wifiClinet startMonitoringEventWithType:CWEventTypeBSSIDDidChange error:&error];
    [self.wifiClinet startMonitoringEventWithType:CWEventTypeLinkDidChange error:&error];
    [self.wifiClinet startMonitoringEventWithType:CWEventTypeLinkQualityDidChange error:&error];
    [self.wifiClinet startMonitoringEventWithType:CWEventTypeModeDidChange error:&error];
    [self.wifiClinet startMonitoringEventWithType:CWEventTypeScanCacheUpdated error:&error];
    [self.wifiClinet startMonitoringEventWithType:CWEventTypeSSIDDidChange error:&error];
    NSLog(@"startMonitoringEvent error: %@", error);
}

- (void)stopMonitorEvent {
    NSError *error = nil;
    [self.wifiClinet stopMonitoringAllEventsAndReturnError:&error];
    NSLog(@"stopMonitoringAllEventsAndReturnError error: %@", error);
}

#pragma mark - associate

- (void)associateToEnterpriseNetworkWithSSID:(NSString *)ssid
                                    username:(NSString *)userName
                                    password:(NSString *)password
                                    completion:(void(^)(NSError *error))completion {
    self.state = VGWiFiClientConnecting;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [self _associateToEnterpriseNetworkWithSSID:ssid
                                           username:userName
                                           password:password
                                         completion:completion];
    });
}

- (void)_associateToEnterpriseNetworkWithSSID:(NSString *)ssid
                                     username:(NSString *)userName
                                     password:(NSString *)password
                                   completion:(void(^)(NSError *error))completion {
    __block NSError *error = nil;
    BOOL isSuccess = NO;
    for (CWNetwork *network in [self.currentInterface cachedScanResults]) {
        if ([network.ssid isEqualToString:ssid]) {
            isSuccess = [self.currentInterface associateToEnterpriseNetwork:network identity:nil username:userName password:password error:&error];
            break;
        }
    }
    
    dispatch_block_t block = ^{
        if (!error && isSuccess) {
            self.state = VGWiFiClientConnected;
        } else {
            self.state = VGWiFiClientStateIdle;
            if (!error) {
                error = [NSError errorWithDomain:VGWiFiClientError
                                            code:651
                                        userInfo:@{NSLocalizedDescriptionKey : @"WiFi connection failed."}];
            }
        }
        if (completion) {
            completion(error);
        }
    };
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)associateToNetworkWithSSID:(NSString *)ssid
                                    password:(NSString *)password
                                  completion:(void(^)(NSError *error))completion {
    self.state = VGWiFiClientConnecting;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [self _associateToNetworkWithSSID:ssid
                                 password:password
                               completion:completion];
    });
}

- (void)_associateToNetworkWithSSID:(NSString *)ssid
                           password:(NSString *)password
                         completion:(void(^)(NSError *error))completion {
    __block NSError *error = nil;
    BOOL isSuccess = NO;
    for (CWNetwork *network in [self.currentInterface cachedScanResults]) {
        if ([network.ssid isEqualToString:ssid]) {
            isSuccess = [self.currentInterface associateToNetwork:network password:password error:&error];
            break;
        }
    }
    
    dispatch_block_t block = ^{
        if (!error && isSuccess) {
            self.state = VGWiFiClientConnected;
        } else {
            self.state = VGWiFiClientStateIdle;
            if (!error) {
                error = [NSError errorWithDomain:VGWiFiClientError
                                            code:651
                                        userInfo:@{NSLocalizedDescriptionKey : @"WiFi connection failed."}];
            }
        }
        
        if (completion) {
            completion(error);
        }
    };
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

- (void)disassociate {
    [self.currentInterface disassociate];
    self.state = VGWiFiClientStateIdle;
}

- (void)checkConnectedWithSSID:(NSString *)ssid {
    if (!ssid.length) { return; }
    if ([self.ssid isEqualToString:ssid]) {
        self.state = VGWiFiClientConnected;
    }
}

#pragma mark - CWEventDelegate

- (void)bssidDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName {
    if ([self.delegate respondsToSelector:@selector(bssidDidChangeForWiFiInterfaceBSSID:)]) {
        [self.delegate bssidDidChangeForWiFiInterfaceBSSID:self.bssid];
    }
}

- (void)linkDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName {
    dispatch_block_t block = ^{
        if (!self.ssid.length && self.state != VGWiFiClientConnecting) {
            self.state = VGWiFiClientStateIdle;
        }
    };
    
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    
    if ([self.delegate respondsToSelector:@selector(linkDidChangeForWiFiClientState:)]) {
        [self.delegate linkDidChangeForWiFiClientState:self.state];
    }
}

- (void)linkQualityDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName
                                                rssi:(NSInteger)rssi
                                        transmitRate:(double)transmitRate {
    if ([self.delegate respondsToSelector:@selector(linkQualityDidChangeForWiFiClient:rssi:transmitRate:)]) {
        [self.delegate linkQualityDidChangeForWiFiClient:self rssi:self.rssi transmitRate:self.transmitRate];
    }
}

- (void)modeDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName {
    if ([self.delegate respondsToSelector:@selector(modeDidChangeForWiFiClient:)]) {
        [self.delegate modeDidChangeForWiFiClient:self];
    }
}

- (void)scanCacheUpdatedForWiFiInterfaceWithName:(NSString *)interfaceName {
    if ([self.delegate respondsToSelector:@selector(scanCacheUpdatedForWiFiClient:)]) {
        [self.delegate scanCacheUpdatedForWiFiClient:self];
    }
}

- (void)ssidDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName {
    if ([self.delegate respondsToSelector:@selector(ssidDidChangeWiFiClient:)]) {
        [self.delegate ssidDidChangeWiFiClient:self];
    }
}


// 连接暂时中断
- (void)clientConnectionInterrupted {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VGWiFiClientConnectionInterrupted object:nil];
    });
}

// 连接永久无效
- (void)clientConnectionInvalidated {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VGWiFiClientConnectionInvalidated object:nil];
    });

}

#pragma mark - Getter

- (CWInterface *)currentInterface {
    return self.wifiClinet.interface;
}

- (NSString *)ssid {
    return self.currentInterface.ssid;
}

- (NSString *)bssid {
    return self.currentInterface.bssid;
}

- (NSInteger)rssi {
    return self.currentInterface.rssiValue;
}

- (CGFloat)transmitRate {
    return self.currentInterface.transmitRate;
}

- (NSInteger)channelNumber {
    return self.currentInterface.wlanChannel.channelNumber;
}

- (CWChannelWidth)channelWidth {
    return self.currentInterface.wlanChannel.channelWidth;
}

- (CWChannelBand)channelBand {
    return self.currentInterface.wlanChannel.channelBand;
}

- (NSString *)hardwareAddress {
    return self.currentInterface.hardwareAddress;
}

- (CWPHYMode)activePHYMode {
    return self.currentInterface.activePHYMode;
}

- (CWInterfaceMode)interfaceMode {
    return self.currentInterface.interfaceMode;
}

@end
