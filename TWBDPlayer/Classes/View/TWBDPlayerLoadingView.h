//
//  TWBDPlayerLoadingView.h
//  TWBDPlayer
//
//  Created by Tilt on 2019/5/28.
//  Copyright © 2019 tilt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWBDPlayerLoadingView : UIView

@property (nonatomic, assign) BOOL isLoading;

+ (instancetype)loadingViewWithFrame:(CGRect)frame circleBgColor:(UIColor *)circleBgColor circleColor:(UIColor *)circleColor circleWidth:(CGFloat)circleWidth lineWidth:(CGFloat)lineWidth;

- (void)addAnimation;

- (void)removeAnimation;

@end

@interface TWBDPlayerLoadingIndicatorView : UIView

////加载器圆圈的颜色
@property (nonatomic, strong) UIColor *color;
/// 加载器圆圈的宽度
@property (nonatomic, assign) CGFloat lineWidth;

/// 添加动画
- (void)addAnimation;
/// 移除动画
- (void)removeAnimation;

@end

NS_ASSUME_NONNULL_END
