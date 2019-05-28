//
//  TWBDPlayerView.m
//  testBDPlayer
//
//  Created by Tilt on 2018/12/11.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import "TWBDPlayerView.h"
#import <BDCloudMediaPlayer/BDCloudMediaPlayer.h>
#import "UIImage+BDImage.h"
#import "TWBDMenuView.h"
#import "TWBDPlayerConfig.h"
#import <TWBaseTool.h>
#import "TWBDPlayerLoadingView.h"

@interface TWBDPlayerView ()
@property (nonatomic, strong) BDCloudMediaPlayerController *player;

@property (nonatomic, strong) TWBDMenuView *menuView;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) BOOL becomeAvtiveNeedPlay;

@property (nonatomic, strong) TWBDPlayerLoadingView *loadingView;

@property (nonatomic, assign) BOOL isDisplayedLoadingView;
@end

@implementation TWBDPlayerView

#pragma mark - Action

- (void)playBtnAction:(BOOL)isPlaying {
    if (isPlaying) {
        if (self.player.loadState == BDCloudMediaPlayerLoadStateUnknown) {
            [self start];
        } else {
            [self.player play];
            [self restartTimer];
        }
    } else {
        [self.player pause];
        [self stopTimer];
    }
}

- (void)restartTimer {
    [self stopTimer];
    [self timer];
}

- (void)timerAction {
    self.menuView.totalTime = self.player.duration;
    self.menuView.currentTime = self.player.currentPlaybackTime;
}
- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)stop {
    [self.player stop];
}
- (void)pause {
    [self.player pause];
    [self.menuView pause];
}

- (void)startWithVideoUrlStr:(NSString *)videoUrlStr {
    self.videoUrlStr = videoUrlStr;
    [self.player stop];
    [self.player reset];
    self.player.contentString = videoUrlStr;
    [self.player prepareToPlay];
    [self timer];
    self.menuView.isPlaying= YES;
    
    [self showLoading];
}
- (void)start {
    [self startWithVideoUrlStr:self.videoUrlStr];
}

- (void)showLoading {
    if (self.isDisplayedLoadingView) {
        return;
    }
    [self addSubview:self.loadingView];
    self.isDisplayedLoadingView = YES;
}
- (void)hideLoading {
    if (self.isDisplayedLoadingView) {
        [self.loadingView removeFromSuperview];
        self.isDisplayedLoadingView = NO;
    }
}

#pragma mark - NSNotification

- (void)appDidEnterBackgroundNotify:(NSNotification *)notify {
    if ([self.player isPlaying]) {
        [self.player pause];
        self.becomeAvtiveNeedPlay = YES;
    }
}

- (void)appDidBecomeActiveNotify:(NSNotification *)notify {
    if (self.becomeAvtiveNeedPlay) {
        [self.player play];
        self.becomeAvtiveNeedPlay = NO;
    }
}

- (void)playerBufferingStart:(NSNotification *)notify {
    [self showLoading];
}

- (void)playerPlaybackIsPrepared:(NSNotification *)notify {
    [self hideLoading];
}

- (void)playerBufferingEnd:(NSNotification *)notify {
    [self hideLoading];
}

#pragma mark - Life Cycle

+ (instancetype)playerWithFrame:(CGRect)frame withVideoUrlStr:(NSString *)videoUrlStr {
    TWBDPlayerView *playerView = [[TWBDPlayerView alloc] initWithFrame:frame];
    playerView.videoUrlStr = videoUrlStr;
    return playerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActiveNotify:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackgroundNotify:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerBufferingStart:) name:BDCloudMediaPlayerBufferingStartNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackIsPrepared:) name:BDCloudMediaPlayerPlaybackIsPreparedToPlayNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerBufferingEnd:) name:BDCloudMediaPlayerBufferingEndNotification object:nil];
        
    }
    return self;
}
- (void)layoutSubviews {
    self.bgImgView.frame =self.bounds;
    self.player.view.frame = self.bounds;
    self.menuView.frame = self.bounds;
    self.loadingView.frame = self.bounds;
}

- (void)removeFromSuperview {
    [self stopTimer];
    [self.player stop];
    [self.player.view removeFromSuperview];
    [self.menuView removeFromSuperview];
}

- (void)dealloc {
//    NSLog(@"%@ dealloc", [self class]);
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BDCloudMediaPlayerBufferingStartNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BDCloudMediaPlayerPlaybackIsPreparedToPlayNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BDCloudMediaPlayerBufferingEndNotification object:nil];
}

- (void)setupUI {
    [self addSubview:self.bgImgView];
//    self.bgImgView.frame = self.bounds;
    self.player = [[BDCloudMediaPlayerController alloc] initWithContentString:@""];
    [self addSubview:self.player.view];
//    self.player.view.frame = self.bounds;
    self.player.shouldAutoplay = YES;
    [self.player setPauseInBackground:YES];
    [self.player prepareToPlay];
    [self addSubview:self.menuView];
}

#pragma mark - Getter

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.backgroundColor = [UIColor lightGrayColor];
        if ([TWBDPlayerConfig sharedInstance].videoPlaceholderImg) {
            _bgImgView.image = [TWBDPlayerConfig sharedInstance].videoPlaceholderImg;
        }
    }
    return _bgImgView;
}

- (TWBDMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[TWBDMenuView alloc] initWithFrame:self.bounds];
        __weak typeof(self) weakSelf = self;
        _menuView.closeBtnBlock = ^{
            if (weakSelf.closeBtnBlock) {
                weakSelf.closeBtnBlock();
            }
        };
        _menuView.playBtnBlock = ^(BOOL isPlaying) {
            [weakSelf playBtnAction:isPlaying];
        };
        _menuView.sliderBeginChangeBlock = ^{
            [weakSelf stopTimer];
        };
        _menuView.sliderFinishedBlock = ^(float value) {
            [weakSelf.player seek:value];
            [weakSelf restartTimer];
        };
        _menuView.speedBtnBlock = ^(CGFloat playSpeed) {
            weakSelf.player.playbackRate = playSpeed;
        };
        _menuView.fullScreenBtnBlock = ^(BOOL isFullScreen) {
            if (weakSelf.fullScreenBtnBlock) {
                weakSelf.fullScreenBtnBlock(isFullScreen);
            }
        };
        _menuView.lockBtnBlock = ^(BOOL isLocked) {
            if (weakSelf.lockBtnBlock) {
                weakSelf.lockBtnBlock(isLocked);
            }
        };
    }
    return _menuView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (TWBDPlayerLoadingView *)loadingView {
    if (!_loadingView) {
        CGFloat width = 40;
        CGFloat x = (self.bounds.size.width - width) / 2.0;
        CGFloat y = (self.bounds.size.height - width) / 2.0;//self.bounds
        _loadingView = [TWBDPlayerLoadingView loadingViewWithFrame:CGRectMake(x, y, width, width) circleBgColor:HEXACOLOR(0xffffff, 0.3) circleColor:[TWBDPlayerConfig sharedInstance].themeColor circleWidth:30 lineWidth:6];
        self.isDisplayedLoadingView = NO;
    }
    return _loadingView;
}

#pragma mark - Setter

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.menuView.titleStr = titleStr;
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    self.menuView.isFullScreen = isFullScreen;
}

- (void)setVideoUrlStr:(NSString *)videoUrlStr {
    _videoUrlStr = videoUrlStr;
    if (!IsNilOrNull(videoUrlStr) && videoUrlStr.length > 0) {
        self.menuView.isReadyToPlay = YES;
    } else {
        self.menuView.isReadyToPlay = NO;
    }
}


@end
