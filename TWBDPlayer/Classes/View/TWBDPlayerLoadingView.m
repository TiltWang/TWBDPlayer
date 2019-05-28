//
//  TWBDPlayerLoadingView.m
//  TWBDPlayer
//
//  Created by Tilt on 2019/5/28.
//  Copyright © 2019 tilt. All rights reserved.
//

#import "TWBDPlayerLoadingView.h"

@interface TWBDPlayerLoadingView ()

@property (nonatomic, strong) TWBDPlayerLoadingIndicatorView *indicatorView;

@property (nonatomic, strong) UIView *contrainerView;

////加载器圆圈的颜色
@property (nonatomic, strong) UIColor *color;
/// 加载器圆圈的宽度
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat circleWidth;

@property (nonatomic, strong) UIColor *circleBgColor;

@end

@implementation TWBDPlayerLoadingView

+ (instancetype)loadingViewWithFrame:(CGRect)frame circleBgColor:(UIColor *)circleBgColor circleColor:(UIColor *)circleColor circleWidth:(CGFloat)circleWidth lineWidth:(CGFloat)lineWidth {
    TWBDPlayerLoadingView *loadingView = [[TWBDPlayerLoadingView alloc] initWithFrame:frame];
    loadingView.color = circleColor;
    loadingView.lineWidth = lineWidth;
    loadingView.circleWidth = circleWidth;
    loadingView.circleBgColor = circleBgColor;
    [loadingView setupUI];
    return loadingView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)dealloc {
    //    TWLog(@"%@ dealloc", [self class]);
}

- (void)setupUI {
    [self addSubview:self.contrainerView];
    [self addSubview:self.indicatorView];
}

- (void)layoutSubviews {
    CGFloat x = (self.frame.size.width - self.circleWidth) / 2.0;
    CGFloat y = (self.frame.size.height - self.circleWidth) / 2.0;
    self.indicatorView.frame = CGRectMake(x, y, self.circleWidth, self.circleWidth);
    CGFloat conW = self.circleWidth + 6;
    CGFloat conX = (self.frame.size.width - conW) / 2.0;
    CGFloat conY = (self.frame.size.height - conW) / 2.0;
    self.contrainerView.frame = CGRectMake(conX, conY, conW, conW);
}

- (TWBDPlayerLoadingIndicatorView *)indicatorView {
    if (!_indicatorView) {
        CGFloat x = (self.frame.size.width - self.circleWidth) / 2.0;
        CGFloat y = (self.frame.size.height - self.circleWidth) / 2.0;
        _indicatorView = [[TWBDPlayerLoadingIndicatorView alloc] initWithFrame:CGRectMake(x, y, self.circleWidth, self.circleWidth)];
        _indicatorView.lineWidth = self.lineWidth;
        _indicatorView.color = self.color;
    }
    return _indicatorView;
}

- (UIView *)contrainerView {
    if (!_contrainerView) {
        CGFloat width = self.circleWidth + 6;
        CGFloat x = (self.frame.size.width - width) / 2.0;
        CGFloat y = (self.frame.size.height - width) / 2.0;
        _contrainerView = [[UIView alloc] initWithFrame:CGRectMake(x, y,width, width)];
        _contrainerView.backgroundColor = self.circleBgColor;
        _contrainerView.layer.cornerRadius = 3.0;
        _contrainerView.layer.masksToBounds = YES;
    }
    return _contrainerView;
}

- (void)addAnimation {
    [self.indicatorView addAnimation];
    self.isLoading = YES;
}

- (void)removeAnimation {
    self.isLoading = NO;
    [self.indicatorView removeAnimation];
}


@end

@implementation TWBDPlayerLoadingIndicatorView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = self.frame.size.width / 2;
        _color = [UIColor whiteColor];
        _lineWidth = 8.0f;
        [self addAnimation];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < 360; i++) {
        CGFloat beginAngle = M_PI * 2 / 360 * i;
        CGFloat toAngle  = beginAngle + M_PI * 2 / 360;
        CGFloat alpha = 1.0 / 360 * (i + 1);
        [self drawCircleWithContext:context beginAngle:beginAngle toAngle:toAngle color:_color alpha:alpha];
    }
}

#pragma mark - 私有方法

/** Draw the circle indicator view */
- (void)drawCircleWithContext:(CGContextRef)context beginAngle:(CGFloat)beginAngle toAngle:(CGFloat) toAngle color:(UIColor *)color alpha:(CGFloat)alpha {
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGFloat r, g, b;
    [color getRed:&r green:&g blue:&b alpha:nil];
    CGContextSetRGBStrokeColor(context, r, g, b, alpha);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextAddArc(context, self.frame.size.width / 2, self.frame.size.height / 2, self.frame.size.width / 2, beginAngle, toAngle, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

#pragma mark - 公开方法

- (void)addAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = @(0);
    animation.toValue = @(M_PI * 2);
    animation.duration = 1.f;
    animation.repeatCount = INT_MAX;
    
    [self.layer addAnimation:animation forKey:@"rotate"];
}

- (void)removeAnimation {
    [self.layer removeAllAnimations];
}

#pragma mark - 属性

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

@end
