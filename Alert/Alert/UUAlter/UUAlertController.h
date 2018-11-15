//
//  UUAlertController.h
//  Alert
//
//  Created by Vein on 2018/11/15.
//  Copyright © 2018 Vein. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UUAlertControllerDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UUAlertControllerDelegate;

@interface UUAlertController : NSObject

@property (nonatomic, assign) id <UUAlertControllerDelegate> delegate;

@property (nonatomic, strong) NSColor *color;

@property (nonatomic, strong) NSColor *borderColor;

@property (nonatomic, strong) NSColor *topHighlightColor;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) NSSize contentSize;

@property (nonatomic, assign) BOOL closesWhenEscapeKeyPressed;

@property (nonatomic, assign) BOOL closesWhenPopoverResignsKey;

@property (nonatomic, assign) BOOL closesWhenApplicationBecomesInactive;

@property (nonatomic, assign) BOOL animates;

@property (nonatomic, assign) UUAlertAnimationType animationType;

@property (nonatomic, strong) NSViewController *contentViewController;

@property (nonatomic, strong, readonly) NSView *positionView;

@property (nonatomic, strong, readonly) NSWindow *popoverWindow;

@property (nonatomic, assign, readonly) BOOL popoverIsVisible;


- (instancetype)initWithContentViewController:(NSViewController *)viewController;

- (void)presentPopoverInView:(NSView *)positionView anchorsToPositionView:(BOOL)anchors;

- (IBAction)closePopover:(id)sender;

- (IBAction)forceClosePopover:(id)sender;

- (NSRect)popoverFrameWithSize:(NSSize)contentSize;

- (NSRect)popoverCenterFrameWithSize:(NSSize)contentSize;

@end

@protocol UUAlertControllerDelegate <NSObject>
@optional

- (BOOL)popoverShouldClose:(UUAlertController *)popover;

- (void)popoverWillShow:(UUAlertController *)popover;

- (void)popoverDidShow:(UUAlertController *)popover;

- (void)popoverWillClose:(UUAlertController *)popover;

- (void)popoverDidClose:(UUAlertController *)popover;

@end

NS_ASSUME_NONNULL_END
