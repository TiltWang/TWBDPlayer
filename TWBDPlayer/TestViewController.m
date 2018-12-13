//
//  TestViewController.m
//  TWBDPlayer
//
//  Created by Tilt on 2018/12/13.
//  Copyright © 2018年 tilt. All rights reserved.
//

#import "TestViewController.h"
#import "TWBDPlayerConfig.h"
#import "TWBDPlayerView.h"
#import <TWBaseTool.h>
#import "UIImage+BDImage.h"
#import "TestViewController.h"

@interface TestViewController ()
@property (nonatomic, strong) TWBDPlayerView *playerView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [TWBDPlayerConfig sharedInstance].sliderTinColor = [UIColor greenColor];
    [TWBDPlayerConfig sharedInstance].hideLockBtn = YES;
    [TWBDPlayerConfig sharedInstance].hideFullScreenBtn = YES;
    [TWBDPlayerConfig sharedInstance].hideSpeedBtn = YES;
    
    self.playerView = [TWBDPlayerView playerWithFrame:CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9 / 16.0) withVideoUrlStr:@"http://tb-video.bdstatic.com/tieba-smallvideo/45_a68a54ff67c9db5bb05748e14c600a3b.mp4"];
    self.playerView.titleStr = @"test标题";
    __weak typeof(self) weakSelf = self;
    self.playerView.closeBtnBlock = ^{
        TWLog(@"结束");
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.view addSubview:self.playerView];
}

- (void)viewWillDisappear:(BOOL)animated {
//    [self.playerView removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.playerView startWithVideoUrlStr:@"http://tb-video.bdstatic.com/videocp/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4"];
    self.playerView.titleStr = @"testNew标题";
}

- (void)viewDidLayoutSubviews {
    if (ScreenWidth > ScreenHeight) {
        self.playerView.frame = [UIScreen mainScreen].bounds;
        self.playerView.isFullScreen = YES;
    } else {
        self.playerView.frame = CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9 / 16.0);
        self.playerView.isFullScreen = NO;
    }
}

@end
