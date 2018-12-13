//
//  TWBDMenuView.h
//  testBDPlayer
//
//  Created by Tilt on 2018/12/12.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWBDMenuView : UIView

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, assign) NSTimeInterval totalTime;

@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, assign) BOOL isFullScreen;

///全屏按钮的block
@property (nonatomic, copy) void(^fullScreenBtnBlock)(BOOL isFullScreen);
///结束按钮的block
@property (nonatomic, copy) void(^closeBtnBlock)(void);
///播放按钮的block
@property (nonatomic, copy) void(^playBtnBlock)(BOOL isPlaying);
///播放按钮的block
@property (nonatomic, copy) void(^speedBtnBlock)(CGFloat playSpeed);
///slider结束按钮的block
@property (nonatomic, copy) void(^sliderFinishedBlock)(float value);
///slider开始按钮的block
@property (nonatomic, copy) void(^sliderBeginChangeBlock)(void);

- (void)pause;
@end
