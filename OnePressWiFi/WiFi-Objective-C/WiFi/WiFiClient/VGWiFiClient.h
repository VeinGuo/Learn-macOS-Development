//
//  VGWiFiClient.h
//  WiFi
//
//  Created by Vein on 2018/11/12.
//  Copyright © 2018 Vein. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VGWiFiClientState) {
    VGWiFiClientStateIdle,
    VGWiFiClientConnecting,
    VGWiFiClientConnected,
};

extern NSString * const VGWiFiClientConnectionInterrupted;
extern NSString * const VGWiFiClientConnectionInvalidated;

@class VGWiFiClient;

@protocol VGWiFiClientDelegate <NSObject>

@optional
- (void)bssidDidChangeForWiFiInterfaceBSSID:(NSString *)bssid;

- (void)linkDidChangeForWiFiClientState:(VGWiFiClientState)state;

- (void)linkQualityDidChangeForWiFiClient:(VGWiFiClient *)client
                                     rssi:(NSInteger)rssi
                             transmitRate:(double)transmitRate;

- (void)modeDidChangeForWiFiClient:(VGWiFiClient *)client;
- (void)scanCacheUpdatedForWiFiClient:(VGWiFiClient *)client;
- (void)ssidDidChangeWiFiClient:(VGWiFiClient *)client;

@end

@interface VGWiFiClient : NSObject

// Info
@property (nonatomic, readonly) NSString *ssid;
@property (nonatomic, readonly) NSString *bssid;
@property (nonatomic, readonly) NSInteger rssi;
@property (nonatomic, readonly) double transmitRate;

// Channel
@property (nonatomic, readonly) NSInteger channelNumber;
@property (nonatomic, readonly) CWChannelWidth channelWidth;
@property (nonatomic, readonly) CWChannelBand channelBand;

@property (nonatomic, readonly) NSString *hardwareAddress;
@property (nonatomic, readonly) CWPHYMode activePHYMode;
@property (nonatomic, readonly) CWInterfaceMode interfaceMode;

@property (nonatomic, readonly) VGWiFiClientState state;

@property (nonatomic, weak) id <VGWiFiClientDelegate> delegate;

+ (VGWiFiClient *)sharedWiFiClient;

/**
 associate to enterprise network.

 @param ssid The ssid to which the Wi-Fi interface will associate.
 @param username The username to use for 802.1X authentication.
 @param password The password to use for 802.1X authentication.
 @param completion The block connection completion status is synchronized in the main thread.
 */
- (void)associateToEnterpriseNetworkWithSSID:(NSString *)ssid
                                    username:(NSString *)username
                                    password:(NSString *)password
                                  completion:(void(^)(NSError *error))completion;

/**
 associate to network.

 @param ssid The ssid to which the Wi-Fi interface will associate.
 @param password The password to use for 802.1X authentication.
 @param completion The block connection completion status is synchronized in the main thread.
 */
- (void)associateToNetworkWithSSID:(NSString *)ssid
                          password:(NSString *)password
                        completion:(void(^)(NSError *error))completion;

/**
 disassociate
 */
- (void)disassociate;

- (void)checkConnectedWithSSID:(NSString *)ssid;

@end

NS_ASSUME_NONNULL_END
