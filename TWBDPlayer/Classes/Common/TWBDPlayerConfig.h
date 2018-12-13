//
//  TWBDPlayerConfig.h
//  testBDPlayer
//
//  Created by Tilt on 2018/12/12.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef struct {
//    int isFullScreen;  //是否全屏
//    int isShowMenu;    //是否显示菜单
//    int isLocked;      //是否锁屏
//} BDPlayerState;

@interface TWBDPlayerConfig : NSObject

@property (nonatomic, strong) NSString *videoPlaceholderImgUrl;

@property (nonatomic, strong) UIImage *videoPlaceholderImg;

@property (nonatomic, strong) UIColor *sliderTinColor;

@property (nonatomic, assign) BOOL hideLockBtn;

@property (nonatomic, assign) BOOL hideFullScreenBtn;

@property (nonatomic, assign) BOOL hideSpeedBtn;

+ (instancetype)sharedInstance;

///此方法请放在APPdelegate 的 didFinishLaunchingWithOptions 中
- (void)setBDPlayerAccessKey:(NSString *)accessKey;
@end
