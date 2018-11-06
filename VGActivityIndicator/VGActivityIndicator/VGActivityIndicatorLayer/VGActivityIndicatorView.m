//
//  VGActivityIndicatorLayer.m
//  VGActivityIndicator
//
//  Created by Vein on 2018/11/6.
//  Copyright © 2018 vein. All rights reserved.
//

#import "VGActivityIndicatorView.h"

@interface VGActivityIndicatorView ()

@property (nonatomic, strong) NSArray <CALayer *> *lineLayers;
@property (nonatomic, assign) NSInteger lineIndex;

@property (nonatomic, getter=isAnimating) BOOL animating;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation VGActivityIndicatorView

- (instancetype)init {
    return [self initWithFrame:NSMakeRect(0, 0, 16, 16)];
}

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithActivityIndicatorStyle:(VGActivityIndicatorViewStyle)style {
    self = [super initWithFrame:NSMakeRect(0, 0, 16, 16)];
    if (self) {
        [self commonInit];
        self.activityIndicatorViewStyle = style;
    }
    return self;
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

- (void)commonInit {
    _lineIndex = 0;
    _hidesWhenStopped = YES;
    [self createlineLayers];
    self.activityIndicatorViewStyle = VGActivityIndicatorLayerStyleWhite;
}

- (void)initLineLayers {
    CGRect lineBounds = [self lineBoundsForCurrentBounds];
    CGPoint lineAnchorPoint = [self lineAnchorPointForCurrentBounds];
    CGPoint linePosition = CGPointMake([self bounds].size.width/2, [self bounds].size.height/2);
    CGFloat lineCornerRadius = lineBounds.size.width/2;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    for (CALayer *line in self.lineLayers) {
        line.bounds = lineBounds;
        line.anchorPoint = lineAnchorPoint;
        line.position = linePosition;
        line.cornerRadius = lineCornerRadius;
    }
    [CATransaction commit];
}

- (void)advancePosition {
    self.lineIndex++;
    if (self.lineIndex >= 12) {
        self.lineIndex = 0;
    }
    
    CALayer *line = (CALayer *)[_lineLayers objectAtIndex:self.lineIndex];
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    line.opacity = 1.0;
    [CATransaction commit];
    
    line.opacity = 0.0;
    
    [self.layer setNeedsDisplay];
}

- (void)startAnimating {
    self.hidden = NO;
    if(self.isAnimating) {
        return;
    }
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer timerWithTimeInterval:0.05
                                          target:self
                                        selector:@selector(advancePosition)
                                        userInfo:nil
                                         repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.animating = YES;
}

- (void)stopAnimating {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.animating = NO;
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

- (void)createlineLayers {
    [self removelineLayers];
    
    NSMutableArray *layers = [[NSMutableArray alloc] init];
    
    CGRect lineBounds = [self lineBoundsForCurrentBounds];
    CGPoint lineAnchorPoint = [self lineAnchorPointForCurrentBounds];
    CGPoint linePosition = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat lineCornerRadius = lineBounds.size.width / 2;
    
    NSInteger numlines = 12;
    
    for (NSUInteger i = 0; i < numlines; i++) {
        CALayer *newline = [CALayer layer];
        
        newline.bounds = lineBounds;
        newline.anchorPoint = lineAnchorPoint;
        newline.position = linePosition;
        newline.transform = CATransform3DMakeRotation(i*(-6.282185/numlines), 0.0, 0.0, 1.0);
        newline.cornerRadius = lineCornerRadius;
        newline.backgroundColor = self.lineColor.CGColor;
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
        newline.opacity = 1;
        [CATransaction commit];
        
        CABasicAnimation *anim = [CABasicAnimation animation];
        anim.duration = 0.7f;
        NSDictionary* actions = [NSDictionary dictionaryWithObjectsAndKeys:
                                 anim, @"opacity",
                                 nil];
        [newline setActions:actions];
        self.wantsLayer = YES;
        [self.layer addSublayer: newline];
        [layers addObject:newline];
    }
    self.lineLayers = [layers copy];
}

- (void)removelineLayers {
    for (CALayer *layer in self.lineLayers) {
        [layer removeFromSuperlayer];
    }
}

- (CGRect)lineBoundsForCurrentBounds {
    CGSize size = self.bounds.size;
    CGFloat minSide = size.width > size.height ? size.height : size.width;
    CGFloat width = minSide * 0.095f;
    CGFloat height = minSide * 0.30f;
    return CGRectMake(0, 0, width, height);
}

- (CGPoint)lineAnchorPointForCurrentBounds {
    CGSize size = [self bounds].size;
    CGFloat minSide = size.width > size.height ? size.height : size.width;
    CGFloat height = minSide * 0.30f;
    return CGPointMake(0.5, -0.9*(minSide-height)/minSide);
}

- (void)setActivityIndicatorViewStyle:(VGActivityIndicatorViewStyle)activityIndicatorViewStyle {
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    switch (activityIndicatorViewStyle) {
        case VGActivityIndicatorLayerStyleWhite:
            self.lineColor = [NSColor whiteColor];
            break;
        case VGActivityIndicatorLayerStyleGray:
            self.lineColor = [NSColor darkGrayColor];
            break;
    }
}

- (BOOL)isAnimating {
    return _animating;
}

- (void)setLineColor:(NSColor *)color {
    _lineColor = color;
    
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
    for (CALayer *line in self.lineLayers) {
        line.backgroundColor = color.CGColor;
    }
    [CATransaction commit];
}

@end


