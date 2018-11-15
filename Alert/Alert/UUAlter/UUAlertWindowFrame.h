//
//  UUAlertWindowFrame.h
//  Alert
//
//  Created by Vein on 2018/11/15.
//  Copyright © 2018 Vein. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface UUAlertWindowFrame : NSView

@property (nonatomic, strong) NSColor *color;
@property (nonatomic, strong) NSColor *borderColor;
@property (nonatomic, strong) NSColor *topHighlightColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

@end

NS_ASSUME_NONNULL_END
