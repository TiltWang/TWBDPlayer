//
//  ViewController.m
//  TWBDPlayer
//
//  Created by Tilt on 2018/12/13.
//  Copyright © 2018年 tilt. All rights reserved.
//

#import "ViewController.h"
//#import "TWBDPlayerConfig.h"
//#import "TWBDPlayerView.h"
//#import <TWBaseTool.h>
//#import "UIImage+BDImage.h"
#import "TestViewController.h"

@interface ViewController ()
//@property (nonatomic, strong) TWBDPlayerView *playerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [TWBDPlayerConfig sharedInstance].sliderTinColor = [UIColor greenColor];
//    [TWBDPlayerConfig sharedInstance].hideLockBtn = YES;
//    [TWBDPlayerConfig sharedInstance].hideFullScreenBtn = YES;
//    [TWBDPlayerConfig sharedInstance].hideSpeedBtn = YES;
//
//    self.playerView = [TWBDPlayerView playerWithFrame:CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9 / 16.0) withVideoUrlStr:@"http://tb-video.bdstatic.com/tieba-smallvideo/45_a68a54ff67c9db5bb05748e14c600a3b.mp4"];
//    self.playerView.titleStr = @"test标题";
//    self.playerView.closeBtnBlock = ^{
//        TWLog(@"结束");
//    };
//    [self.view addSubview:self.playerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.playerView startWithVideoUrlStr:@"http://tb-video.bdstatic.com/videocp/12045395_f9f87b84aaf4ff1fee62742f2d39687f.mp4"];
//    self.playerView.titleStr = @"testNew标题";
    TestViewController *testVC = [[TestViewController alloc] init];
    [self presentViewController:testVC animated:YES completion:nil];
}

//- (void)viewDidLayoutSubviews {
//    if (ScreenWidth > ScreenHeight) {
//        self.playerView.frame = [UIScreen mainScreen].bounds;
//        self.playerView.isFullScreen = YES;
//    } else {
//        self.playerView.frame = CGRectMake(0, 88, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9 / 16.0);
//        self.playerView.isFullScreen = NO;
//    }
//}

@end
