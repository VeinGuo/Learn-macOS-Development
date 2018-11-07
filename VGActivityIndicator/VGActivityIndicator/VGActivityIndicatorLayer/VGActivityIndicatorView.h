//
//  VGActivityIndicatorView.h
//  VGActivityIndicator
//
//  Created by Vein on 2018/11/6.
//  Copyright © 2018 vein. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VGActivityIndicatorViewStyle) {
    VGActivityIndicatorViewStyleWhite,
    VGActivityIndicatorViewStyleGray
};

IB_DESIGNABLE @interface VGActivityIndicatorView : NSView

- (instancetype)initWithActivityIndicatorStyle:(VGActivityIndicatorViewStyle)style NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithFrame:(NSRect)frame NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@property(nonatomic) VGActivityIndicatorViewStyle activityIndicatorViewStyle; // default is VGActivityIndicatorLayerStyleWhite
@property(nonatomic) BOOL hidesWhenStopped; // default is YES. calls -setHidden when animating gets set to NO

@property (nonatomic, copy) NSColor *lineColor;

@property (nonatomic, readonly, getter=isAnimating) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

- (BOOL)isAnimating;

@end

NS_ASSUME_NONNULL_END
