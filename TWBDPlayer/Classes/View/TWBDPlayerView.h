//
//  TWBDPlayerView.h
//  testBDPlayer
//
//  Created by Tilt on 2018/12/11.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWBDPlayerView : UIView
///视频地址
@property (nonatomic, strong) NSString *videoUrlStr;

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) UIImageView *bgImgView;
///旋转屏幕后改变全屏按钮状态
@property (nonatomic, assign) BOOL isFullScreen;

+ (instancetype)playerWithFrame:(CGRect)frame withVideoUrlStr:(NSString *)videoUrlStr;

///结束按钮的block
@property (nonatomic, copy) void(^closeBtnBlock)(void);
///全屏按钮的block
@property (nonatomic, copy) void(^fullScreenBtnBlock)(BOOL isFullScreen);

///未设置了videoUrlStr 可使用此方法
- (void)startWithVideoUrlStr:(NSString *)videoUrlStr;
///设置了videoUrlStr 可使用此方法
- (void)start;
@end
