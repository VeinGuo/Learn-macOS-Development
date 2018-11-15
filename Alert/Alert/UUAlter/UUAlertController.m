//
//  UUAlertController.m
//  Alert
//
//  Created by Vein on 2018/11/15.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "UUAlertController.h"
#import "UUAlertWindow.h"
#import "UUAlertWindowFrame.h"
#import "UUAlertParentWindow.h"
#include <QuartzCore/QuartzCore.h>

@interface UUAlertController () <NSFileManagerDelegate>

@end

@implementation UUAlertController {
    UUAlertWindow *_popoverWindow;
    NSRect _screenRect;
    NSRect _viewRect;
}

- (instancetype)init {
    if ((self = [super init])) {
        [self _setInitialPropertyValues];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self _setInitialPropertyValues];
}

#pragma mark -
#pragma mark - Memory Management

- (void)dealloc {
    _popoverWindow.popoverController = nil;
}

#pragma mark -
#pragma mark Public Methods

- (instancetype)initWithContentViewController:(NSViewController *)viewController {
    if ((self = [super init])) {
        [self _setInitialPropertyValues];
        self.contentViewController = viewController;
    }
    return self;
}

- (void)presentPopoverInView:(NSView *)positionView anchorsToPositionView:(BOOL)anchors {
    if (self.popoverIsVisible) {
        return;
    } // If it's already visible, do nothing
    NSWindow *mainWindow = [positionView window];
    _positionView = positionView;
    _viewRect = positionView.frame;
    _screenRect = mainWindow.frame;
    
    CGFloat mainWindowMaxY = CGRectGetMaxY(mainWindow.frame);
    CGFloat mainWindowMaxX = CGRectGetMaxX(mainWindow.frame);
    CGFloat mainWindowWidth = CGRectGetWidth(mainWindow.frame);
    CGFloat mainWindowHeight = CGRectGetHeight(mainWindow.frame);
    CGFloat screenOriginX = (mainWindowMaxX - mainWindowWidth/2 - self.contentSize.width/2);
    CGFloat screenOriginY = (mainWindowMaxY - mainWindowHeight/2 - self.contentSize.height/2);
    _screenRect.origin = CGPointMake(screenOriginX, screenOriginY);
    
    NSRect windowFrame = [self popoverFrameWithSize:self.contentSize];   // Calculate the window frame based on the arrow direction
    [_popoverWindow setFrame:windowFrame display:YES];                                                         // Se the frame of the window
    [[_popoverWindow animationForKey:@"alphaValue"] setDelegate:self];

    // Show the popover
    [self _callDelegateMethod:@selector(popoverWillShow:)]; // Call the delegate
    if (self.animates && self.animationType != UUAlertAnimationTypeFadeOut) {
        // Animate the popover in
        [_popoverWindow presentAnimated];
    } else {
        [_popoverWindow setAlphaValue:1.0];
        [mainWindow addChildWindow:_popoverWindow ordered:NSWindowAbove]; // Add the popover as a child window of the main window
        [_popoverWindow makeKeyAndOrderFront:nil];                        // Show the popover
        [self _callDelegateMethod:@selector(popoverDidShow:)];            // Call the delegate
    }

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if (anchors) { // If the anchors option is enabled, register for frame change notifications
        [nc addObserver:self selector:@selector(_positionViewFrameChanged:) name:NSViewFrameDidChangeNotification object:self.positionView];
    }
    // When -closesWhenPopoverResignsKey is set to YES, the popover will automatically close when the popover loses its key status
    if (self.closesWhenPopoverResignsKey) {
        [nc addObserver:self selector:@selector(closePopover:) name:NSWindowDidResignKeyNotification object:_popoverWindow];
        if (!self.closesWhenApplicationBecomesInactive) {
            [nc addObserver:self selector:@selector(applicationDidBecomeActive:) name:NSApplicationDidBecomeActiveNotification object:nil];
        }
    } else if (self.closesWhenApplicationBecomesInactive) {
        // this is only needed if closesWhenPopoverResignsKey is NO, otherwise we already get a "resign key" notification when resigning active
        [nc addObserver:self selector:@selector(closePopover:) name:NSApplicationDidResignActiveNotification object:nil];
    }
}

- (IBAction)closePopover:(id)sender {
    if (![_popoverWindow isVisible]) {
        return;
    }
    if ([sender isKindOfClass:[NSNotification class]] && [[(NSNotification *)sender name] isEqualToString:NSWindowDidResignKeyNotification]) {
        // ignore "resign key" notification sent when app becomes inactive unless closesWhenApplicationBecomesInactive is enabled
        if (!self.closesWhenApplicationBecomesInactive && ![NSApp isActive])
            return;
    }
    BOOL close = YES;
    // Check to see if the delegate has implemented the -popoverShouldClose: method
    if ([self.delegate respondsToSelector:@selector(popoverShouldClose:)]) {
        close = [self.delegate popoverShouldClose:self];
    }
    if (close) {
        [self forceClosePopover:nil];
    }
}

- (IBAction)forceClosePopover:(id)sender {
    if (![_popoverWindow isVisible]) {
        return;
    }
    [self _callDelegateMethod:@selector(popoverWillClose:)]; // Call delegate
    if (self.animates && self.animationType != UUAlertAnimationTypeFadeIn) {
        [_popoverWindow dismissAnimated];
    } else {
        [self _closePopoverAndResetVariables:NO];
    }
}

// Calculate the frame of the window depending on the arrow direction
- (NSRect)popoverFrameWithSize:(NSSize)contentSize {
    NSRect contentRect = NSZeroRect;
    contentRect.size = contentSize;
    CGFloat mainWindowMaxY = CGRectGetMaxY(_screenRect);
    CGFloat mainWindowMaxX = CGRectGetMaxX(_screenRect);
    CGFloat mainWindowWidth = CGRectGetWidth(_screenRect);
    CGFloat mainWindowHeight = CGRectGetHeight(_screenRect);
    CGFloat screenOriginX = (mainWindowMaxX - mainWindowWidth/2 - contentSize.width/2);
    CGFloat screenOriginY = (mainWindowMaxY - mainWindowHeight/2 - contentSize.height/2);
    
    contentRect.origin = CGPointMake(screenOriginX, screenOriginY);
    NSRect windowFrame = [_popoverWindow frameRectForContentRect:contentRect];
    return windowFrame;
}

- (NSRect)popoverCenterFrameWithSize:(NSSize)contentSize {
    NSRect contentRect = NSZeroRect;
    contentRect.size = contentSize;
    CGFloat mainWindowMaxY = CGRectGetMaxY(_screenRect);
    CGFloat mainWindowMaxX = CGRectGetMaxX(_screenRect);
    CGFloat mainWindowWidth = CGRectGetWidth(_screenRect);
    CGFloat mainWindowHeight = CGRectGetHeight(_screenRect);
    CGFloat screenOriginX = (mainWindowMaxX - mainWindowWidth/2 - contentSize.width/2);
    CGFloat screenOriginY = (mainWindowMaxY - mainWindowHeight/2 - contentSize.height/2);
    
    contentRect.origin = CGPointMake(screenOriginX, screenOriginY);
    NSRect windowFrame = [_popoverWindow frameRectForContentRect:contentRect];
    return windowFrame;
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
#pragma unused(animation)
#pragma unused(flag)
    // Detect the end of fade out and close the window
    if (0.0 == [_popoverWindow alphaValue])
        [self _closePopoverAndResetVariables:YES];
    else if (1.0 == [_popoverWindow alphaValue]) {
        [[_positionView window] addChildWindow:_popoverWindow ordered:NSWindowAbove];
        [self _callDelegateMethod:@selector(popoverDidShow:)];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    // when the user clicks in the parent window for activating the app, the parent window becomes key which prevents
    if ([_popoverWindow isVisible])
        [self performSelector:@selector(checkPopoverKeyWindowStatus) withObject:nil afterDelay:0];
}

- (void)checkPopoverKeyWindowStatus {
    id parentWindow = [_positionView window]; // could be INPopoverParentWindow
    BOOL isKey = [parentWindow respondsToSelector:@selector(isReallyKeyWindow)] ? [parentWindow isReallyKeyWindow] : [parentWindow isKeyWindow];
    if (isKey)
        [_popoverWindow makeKeyWindow];
}

#pragma mark -
#pragma mark Getters

- (NSColor *)color {
    return _popoverWindow.frameView.color;
}

- (CGFloat)borderWidth {
    return _popoverWindow.frameView.borderWidth;
}

- (NSColor *)borderColor {
    return _popoverWindow.frameView.borderColor;
}

- (NSColor *)topHighlightColor {
    return _popoverWindow.frameView.topHighlightColor;
}

- (CGFloat)cornerRadius {
    return _popoverWindow.frameView.cornerRadius;
}

- (NSView *)contentView {
    return [_popoverWindow popoverContentView];
}

- (BOOL)popoverIsVisible {
    return [_popoverWindow isVisible];
}

#pragma mark -
#pragma mark Setters

- (void)setColor:(NSColor *)newColor {
    _popoverWindow.frameView.color = newColor;
}

- (void)setBorderWidth:(CGFloat)newBorderWidth {
    _popoverWindow.frameView.borderWidth = newBorderWidth;
}

- (void)setBorderColor:(NSColor *)newBorderColor {
    _popoverWindow.frameView.borderColor = newBorderColor;
}

- (void)setTopHighlightColor:(NSColor *)newTopHighlightColor {
    _popoverWindow.frameView.topHighlightColor = newTopHighlightColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _popoverWindow.frameView.cornerRadius = cornerRadius;
}


- (void)setContentViewController:(NSViewController *)newContentViewController {
    if (_contentViewController != newContentViewController) {
        [_popoverWindow setPopoverContentView:nil]; // Clear the content view
        _contentViewController = newContentViewController;
        NSView *contentView = [_contentViewController view];
        self.contentSize = [contentView frame].size;
        [_popoverWindow setPopoverContentView:contentView];
    }
}

- (void)setContentSize:(NSSize)newContentSize {
    // We use -frameRectForContentRect: just to get the frame size because the origin it returns is not the one we want to use. Instead, -windowFrameWithSize:andArrowDirection: is used to  complete the frame
    _contentSize = newContentSize;
    NSRect adjustedRect = [self popoverFrameWithSize:newContentSize];
    [_popoverWindow setFrame:adjustedRect display:YES animate:self.animates];
}

#pragma mark -
#pragma mark Private

// Set the default values for all the properties as described in the header documentation
- (void)_setInitialPropertyValues {
    // Create an empty popover window
    _popoverWindow = [[UUAlertWindow alloc] initWithContentRect:NSZeroRect styleMask:NSWindowStyleMaskBorderless backing:NSBackingStoreBuffered defer:NO];
    _popoverWindow.popoverController = self;

    // set defaults like iCal popover
    self.color = [NSColor colorWithCalibratedWhite:0.94 alpha:0.92];
    self.borderColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.92];
    self.borderWidth = 1.0;
    self.closesWhenEscapeKeyPressed = YES;
    self.closesWhenPopoverResignsKey = YES;
    self.closesWhenApplicationBecomesInactive = NO;
    self.animates = YES;
    self.animationType = UUAlertAnimationTypePop;

    // create animation to get callback - delegate is set when opening popover to avoid memory cycles
    CAAnimation *animation = [CABasicAnimation animation];
    [_popoverWindow setAnimations:[NSDictionary dictionaryWithObject:animation forKey:@"alphaValue"]];
}


- (void)_positionViewFrameChanged:(NSNotification *)notification {
    NSRect superviewBounds = [[self.positionView superview] bounds];
    if (!(NSContainsRect(superviewBounds, [self.positionView frame]))) {
        [self forceClosePopover:nil]; // If the position view goes off screen then close the popover
        return;
    }
    NSRect newFrame = [_popoverWindow frame];
    _screenRect = [self.positionView convertRect:_viewRect toView:nil];                                          // Convert the rect to window coordinates
    _screenRect.origin = [[self.positionView window] convertBaseToScreen:_screenRect.origin];                    // Convert window coordinates to screen coordinates
    NSRect calculatedFrame = [self popoverFrameWithSize:self.contentSize]; // Calculate the window frame based on the arrow direction
    newFrame.origin = calculatedFrame.origin;
    [_popoverWindow setFrame:newFrame display:YES animate:NO]; // Set the frame of the window
}

- (void)_closePopoverAndResetVariables:(BOOL)fromAnimation {
    NSWindow *positionWindow = [self.positionView window];
    [_popoverWindow orderOut:nil];                          // Close the window
    [self _callDelegateMethod:@selector(popoverDidClose:)]; // Call the delegate to inform that the popover has closed
    [positionWindow removeChildWindow:_popoverWindow];      // Remove it as a child window
    [positionWindow makeKeyAndOrderFront:nil];
    // Clear all the ivars
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _positionView = nil;
    _screenRect = NSZeroRect;
    _viewRect = NSZeroRect;

    // When using ARC and no animation, there is a "message sent to deallocated instance" crash if setDelegate: is not performed at the end of the event.
    if (fromAnimation) {
        [[_popoverWindow animationForKey:@"alphaValue"] setDelegate:nil];
    } else {
        [[_popoverWindow animationForKey:@"alphaValue"] performSelector:@selector(setDelegate:) withObject:nil afterDelay:0];
    }
}

- (void)_callDelegateMethod:(SEL)selector {
    if ([self.delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.delegate performSelector:selector
                            withObject:self];
#pragma clang diagnostic pop
    }
}

@end
