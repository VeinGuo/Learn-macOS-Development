//
//  UUAlertWindowFrame.m
//  Alert
//
//  Created by Vein on 2018/11/15.
//  Copyright © 2018 Vein. All rights reserved.
//

#import "UUAlertWindowFrame.h"

@implementation UUAlertWindowFrame

- (instancetype)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        _color = [NSColor colorWithCalibratedWhite:0.0 alpha:0.8];
        _cornerRadius = 4.0;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    NSRect bounds = [self bounds];
    if (((NSUInteger)self.borderWidth % 2) == 1) { // Remove draw glitch on odd border width
        bounds = NSInsetRect(bounds, 0.5, 0.5);
    }

    NSBezierPath *path = [self _popoverBezierPathWithRect:bounds];
    if (self.color) {
        [self.color set];
        [path fill];
    }
    if (self.borderWidth > 0) {
        [path setLineWidth:self.borderWidth];
        [self.borderColor set];
        [path stroke];
    }

    const CGFloat radius = self.cornerRadius;

    if (self.topHighlightColor) {
        [self.topHighlightColor set];
        NSRect bounds = [self bounds];
        NSRect lineRect = NSMakeRect(floor(NSMinX(bounds) + (radius / 2.0)), NSMaxY(bounds) - self.borderWidth - 1, NSWidth(bounds) - radius, 1.0);

        NSRectFill(lineRect);
    }
}

#pragma mark -
#pragma mark Private

- (NSBezierPath *)_popoverBezierPathWithRect:(NSRect)aRect {
    const CGFloat radius = self.cornerRadius;
    const CGFloat inset = radius;
    const NSRect drawingRect = NSInsetRect(aRect, inset, inset);
    const CGFloat minX = NSMinX(drawingRect);
    const CGFloat maxX = NSMaxX(drawingRect);
    const CGFloat minY = NSMinY(drawingRect);
    const CGFloat maxY = NSMaxY(drawingRect);

    NSBezierPath *path = [NSBezierPath bezierPath];
    [path setLineJoinStyle:NSRoundLineJoinStyle];

    [path appendBezierPathWithArcWithCenter:NSMakePoint(minX, minY) radius:radius startAngle:180.0 endAngle:270.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(maxX, minY) radius:radius startAngle:270.0 endAngle:360.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(maxX, maxY) radius:radius startAngle:0.0 endAngle:90.0];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(minX, maxY) radius:radius startAngle:90.0 endAngle:180.0];
    [path closePath];

    return path;
}

#pragma mark -
#pragma mark Accessors

// Redraw the frame every time a property is changed
- (void)setColor:(NSColor *)newColor {
    if (_color != newColor) {
        _color = newColor;
        [self setNeedsDisplay:YES];
    }
}

- (void)setBorderColor:(NSColor *)newBorderColor {
    if (_borderColor != newBorderColor) {
        _borderColor = newBorderColor;
        [self setNeedsDisplay:YES];
    }
}


- (void)setBorderWidth:(CGFloat)newBorderWidth {
    if (_borderWidth != newBorderWidth) {
        _borderWidth = newBorderWidth;
        [self setNeedsDisplay:YES];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        [self setNeedsDisplay:YES];
    }
}

@end
