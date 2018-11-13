//
//  ViewController.m
//  WiFi
//
//  Created by Vein on 2018/11/12.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "ViewController.h"

#import "VGWiFiClient.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[VGWiFiClient sharedWiFiClient] associateToEnterpriseNetworkWithSSID:@"test" username:@"vein" password:@"123456" completion:^(NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
    }];
}

- (IBAction)disconnect:(NSButton *)sender {
    [[VGWiFiClient sharedWiFiClient] disassociate];
}

@end
