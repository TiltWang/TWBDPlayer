//
//  TWBDPlayerConfig.m
//  testBDPlayer
//
//  Created by Tilt on 2018/12/12.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import "TWBDPlayerConfig.h"
#import <BDCloudMediaPlayer/BDCloudMediaPlayer.h>
#import <TWBaseTool.h>

@interface TWBDPlayerConfig () <BDCloudMediaPlayerAuthDelegate>

@end

@implementation TWBDPlayerConfig

static TWBDPlayerConfig *_instance=nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if(!_instance){
            _instance = [[TWBDPlayerConfig alloc] init];
        }
    });
    return _instance;
}

- (void)setBDPlayerAccessKey:(NSString *)accessKey {
    [[BDCloudMediaPlayerAuth sharedInstance] setAccessKey:accessKey];
    [BDCloudMediaPlayerAuth sharedInstance].delegate = self;
}

#pragma mark - BDCloudMediaPlayerAuthDelegate

/**
 认证开始。
 */
- (void)authStart {
    TWLog(@"百度云认证开始");
}

/**
 认证结束。
 
 @param error 错误不为空时，表示认证失败。
 */
- (void)authEnd:(NSError*)error {
    if (error) {
        TWLog(@"百度云认证失败error: %@", error);
    } else {
        TWLog(@"百度云认证成功");
    }
}


@end
