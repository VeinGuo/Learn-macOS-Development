//
//  UUAlertParentWindow.m
//  Alert
//
//  Created by Vein on 2018/11/15.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "UUAlertParentWindow.h"

#import "UUAlertWindow.h"

@implementation UUAlertParentWindow

- (BOOL)isKeyWindow
{
    BOOL isKey = [super isKeyWindow];
    if (!isKey) {
        for (NSWindow *childWindow in [self childWindows]) {
            if ([childWindow isKindOfClass:[UUAlertWindow class]]) {
                // if we have popover attached, window is key if app is active
                isKey = [NSApp isActive];
                break;
            }
        }
    }
    return isKey;
}

- (BOOL)isReallyKeyWindow
{
    return [super isKeyWindow];
}

@end
