//
//  UUAlertWindow.h
//  Alert
//
//  Created by Vein on 2018/11/15.
//  Copyright © 2018 Vein. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "UUAlertControllerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class UUAlertWindowFrame;
@class UUAlertController;

@interface UUAlertWindow : NSPanel

@property (nonatomic, readonly) UUAlertWindowFrame *frameView; // Equivalent to contentView
@property (nonatomic, weak) UUAlertController *popoverController;
@property (nonatomic, strong) NSView *popoverContentView;

- (void)presentAnimated;
- (void)dismissAnimated;

@end

NS_ASSUME_NONNULL_END
