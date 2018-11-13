//
//  ViewController.m
//  Device
//
//  Created by Vein on 2018/11/13.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "ViewController.h"

#import "VGDevice.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"hostName: %@", [VGDevice hostName]);
    NSLog(@"buildVersion: %@", [VGDevice buildVersion]);
    NSLog(@"appVersion: %@", [VGDevice appVersion]);
    NSLog(@"bundleID: %@", [VGDevice bundleID]);
    NSLog(@"appName: %@", [VGDevice appName]);
    NSLog(@"ipAddresses: %@", [VGDevice ipAddresses]);
    NSLog(@"deviceModel: %@", [VGDevice deviceModel]);
    NSLog(@"systemVersion: %@", [VGDevice systemVersion]);
    NSLog(@"MACAddress: %@", [VGDevice MACAddress]);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
