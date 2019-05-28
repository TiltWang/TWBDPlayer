//
//  TWBDMenuView.m
//  testBDPlayer
//
//  Created by Tilt on 2018/12/12.
//  Copyright © 2018年 eoffcn. All rights reserved.
//

#import "TWBDMenuView.h"
#import "UIImage+BDImage.h"
#import <TWBaseTool.h>
#import <Masonry.h>
#import "TWBDPlayerConfig.h"

@interface TWBDMenuView ()
@property (nonatomic, strong) UIView *coverRecognView;
@property (nonatomic, strong) UIView *topContrainerView;
@property (nonatomic, strong) UIView *bottomContrainerView;
@property (nonatomic, strong) UIButton *lockBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIButton *speedBtn;
@property (nonatomic, strong) UIButton *playBtn;
///当前播放时间
@property (nonatomic, strong) UILabel *currentLbl;
@property (nonatomic, strong) UISlider *slider;
///视频总时长
@property (nonatomic, strong) UILabel *totalLbl;
@property (nonatomic, strong) UIButton *fullScreenBtn;
///是否显示菜单
@property (nonatomic, assign) BOOL isShowMenu;
@property (nonatomic, assign) BOOL isLocked;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger currentSpeedLevel;
@end

static CGFloat topHeight = 40.0;
static CGFloat bottomHeight = 40.0;

@implementation TWBDMenuView


#pragma mark - Action
- (void)backBtnClick:(UIButton *)btn {
    [self stopTimer];
    if ([TWBDPlayerConfig sharedInstance].hideFullScreenBtn) {
        if (_closeBtnBlock) {
            _closeBtnBlock();
        }
    } else {
        if (self.isFullScreen) {
//            self.isFullScreen = NO;
            if (_fullScreenBtnBlock) {
                _fullScreenBtnBlock(self.fullScreenBtn.selected);
            }
        } else {
            if (_closeBtnBlock) {
                _closeBtnBlock();
            }
        }
    }
    [self timer];
}
- (void)lockBtnClick:(UIButton *)btn {
    [self stopTimer];
    btn.selected = !btn.selected;
    self.isLocked = btn.selected;
    if (_lockBtnBlock) {
        _lockBtnBlock(btn.selected);
    }
    [self timer];
}

- (void)speedBtnClick:(UIButton *)btn {
    self.currentSpeedLevel = self.currentSpeedLevel + 1;
    NSString *speedStr = self.speedBtn.titleLabel.text;
    speedStr = [speedStr stringByReplacingOccurrencesOfString:@"X" withString:@""];
    if ([speedStr floatValue] && _speedBtnBlock) {
        _speedBtnBlock([speedStr floatValue]);
    }
}

- (void)playBtnClick:(UIButton *)btn {
    [self stopTimer];
    btn.selected = !btn.selected;
    if (_playBtnBlock) {
        _playBtnBlock(btn.selected);
    }
    [self timer];
}
- (void)fullScreenBtnClick:(UIButton *)btn {
    [self stopTimer];
    if (_fullScreenBtnBlock) {
        _fullScreenBtnBlock(btn.selected);
    }
    [self timer];
}
- (void)sliderFinishAction:(UISlider *)slider {
    [self timer];
    if (self.totalTime <= 0) {
        return;
    }
    if (_sliderFinishedBlock) {
        _sliderFinishedBlock(slider.value);
    }
    self.currentTime = slider.value;
}
- (void)sliderBeginAction:(UISlider *)slider {
    [self stopTimer];
    if (self.totalTime <= 0) {
        return;
    }
    if (_sliderBeginChangeBlock) {
        _sliderBeginChangeBlock();
    }
}
    
- (void)restartTimer {
    [self stopTimer];
    [self timer];
}

- (void)timerAction {
    self.isShowMenu = NO;
}
- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"触摸开始");
    [self stopTimer];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"触摸结束");
    [self timer];
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
//    NSLog(@"单击是否显示菜单");
//    [self stopTimer];
    self.isShowMenu = ! self.isShowMenu;
    [self restartTimer];
    
}
- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
//    NSLog(@"双击是否全屏");
    if (self.isLocked) {
        return;
    }
//    [self stopTimer];
    [self fullScreenBtnClick:self.fullScreenBtn];
    [self restartTimer];
}
- (void)pause {
    self.playBtn.selected = NO;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        _isShowMenu = YES;
        _currentSpeedLevel = 0;
        [self setupUI];
        self.isReadyToPlay = NO;
        [self timer];
    }
    return self;
}

- (void)removeFromSuperview {
    [self stopTimer];
}

- (void)dealloc {
//    NSLog(@"%@ dealloc", [self class]);
    [self stopTimer];
}


- (void)setupUI {
    [self addSubview:self.coverRecognView];
    [self addSubview:self.topContrainerView];
    [self addSubview:self.bottomContrainerView];
    [self addSubview:self.lockBtn];
    [self.topContrainerView addSubview:self.backBtn];
    [self.topContrainerView addSubview:self.titleLbl];
    [self.topContrainerView addSubview:self.speedBtn];
    [self.bottomContrainerView addSubview:self.playBtn];
    [self.bottomContrainerView addSubview:self.currentLbl];
    [self.bottomContrainerView addSubview:self.slider];
    [self.bottomContrainerView addSubview:self.totalLbl];
    [self.bottomContrainerView addSubview:self.fullScreenBtn];
    [self.coverRecognView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    CGFloat fringeMargin = [TWUtil isHasFringe]? 10.0f : 0.0f;
    CGFloat edgeMargin = 10.0;
    [self.topContrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(topHeight + fringeMargin));
        make.top.left.right.equalTo(self);
    }];
    [self.bottomContrainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(bottomHeight + fringeMargin));
        make.bottom.left.right.equalTo(self);
    }];
    
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(fringeMargin + edgeMargin);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topContrainerView).offset(fringeMargin + edgeMargin);
        make.centerY.equalTo(self.topContrainerView).offset(fringeMargin / 2.0);
        make.width.height.equalTo(@32);
    }];
    [self.speedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topContrainerView).offset(- fringeMargin - edgeMargin);
        make.centerY.equalTo(self.backBtn);
        make.height.equalTo(@32);
        make.width.equalTo(@50);
    }];
    if ([TWBDPlayerConfig sharedInstance].hideSpeedBtn) {
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.left.equalTo(self.backBtn.mas_right).offset(5);
            make.right.equalTo(self.topContrainerView).offset(- fringeMargin - edgeMargin);
        }];
    } else {
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.left.equalTo(self.backBtn.mas_right).offset(5);
            make.right.equalTo(self.speedBtn.mas_left).offset(-5);
        }];
    }
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomContrainerView).offset(fringeMargin + edgeMargin);
        make.centerY.equalTo(self.bottomContrainerView).offset(- fringeMargin / 2.0);
        make.width.height.equalTo(@32);
    }];
    
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomContrainerView).offset(- fringeMargin - edgeMargin);
        make.centerY.equalTo(self.playBtn);
        make.width.height.equalTo(@22);
    }];
    [self.currentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.playBtn.mas_right).offset(5);
    }];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.playBtn);
        make.left.equalTo(self.currentLbl.mas_right).offset(5);
    }];
    if ([TWBDPlayerConfig sharedInstance].hideFullScreenBtn) {
        [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playBtn);
            make.left.equalTo(self.slider.mas_right).offset(5);
            make.right.equalTo(self.bottomContrainerView).offset(- fringeMargin - edgeMargin);
        }];
    } else {
        [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.playBtn);
            make.left.equalTo(self.slider.mas_right).offset(5);
            make.right.equalTo(self.fullScreenBtn.mas_left).offset(-5);
        }];
    }
    //测试
    self.currentLbl.text = @"00:00:00";
    self.totalLbl.text = @"00:00:00";
//    self.titleLbl.text = @"我是标题";
}


#pragma mark - Getter

- (UIView *)coverRecognView {
    if (!_coverRecognView) {
        _coverRecognView = [[UIView alloc] init];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [_coverRecognView addGestureRecognizer:singleTap];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [_coverRecognView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    return _coverRecognView;
}
- (UIView *)topContrainerView {
    if (!_topContrainerView) {
        _topContrainerView = [[UIView alloc] init];
        _topContrainerView.backgroundColor = HEXACOLOR(0x333333, 0.2);
    }
    return _topContrainerView;
}

- (UIView *)bottomContrainerView {
    if (!_bottomContrainerView) {
        _bottomContrainerView = [[UIView alloc] init];
        _bottomContrainerView.backgroundColor = HEXACOLOR(0x333333, 0.2);
    }
    return _bottomContrainerView;
}
- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [[UIButton alloc] init];
        [_lockBtn setImage:[UIImage bd_imageNamed:@"btn_player_unlock"] forState:UIControlStateNormal];
        [_lockBtn setImage:[UIImage bd_imageNamed:@"btn_player_lock"] forState:UIControlStateSelected];
        [_lockBtn addTarget:self action:@selector(lockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _lockBtn.hidden = [TWBDPlayerConfig sharedInstance].hideLockBtn;
    }
    return _lockBtn;
}
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[UIImage bd_imageNamed:@"btn_player_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLbl;
}
- (UIButton *)speedBtn {
    if (!_speedBtn) {
        _speedBtn = [[UIButton alloc] init];
        [_speedBtn setTitle:@"1.0X" forState:UIControlStateNormal];
        _speedBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_speedBtn addTarget:self action:@selector(speedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _speedBtn.hidden = [TWBDPlayerConfig sharedInstance].hideSpeedBtn;
    }
    return _speedBtn;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [[UIButton alloc] init];
        [_playBtn setImage:[UIImage bd_imageNamed:@"btn_player_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage bd_imageNamed:@"btn_player_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UILabel *)currentLbl {
    if (!_currentLbl) {
        _currentLbl = [[UILabel alloc] init];
        _currentLbl.textColor = [UIColor whiteColor];
        _currentLbl.font = [UIFont systemFontOfSize:10.0];
        _currentLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _currentLbl;
}
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumTrackTintColor = [TWBDPlayerConfig sharedInstance].themeColor;
        _slider.maximumTrackTintColor = HEXACOLOR(0xffffff, 0.5);
        [_slider setThumbImage:[UIImage bd_imageNamed:@"btn_player_slider_circle"] forState:UIControlStateNormal];
        _slider.value = 0;
        self.slider.minimumValue = 0.0;
        self.slider.maximumValue = 1.0;
        [_slider addTarget:self action:@selector(sliderFinishAction:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(sliderBeginAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _slider;
}
- (UILabel *)totalLbl {
    if (!_totalLbl) {
        _totalLbl = [[UILabel alloc] init];
        _totalLbl.textColor = [UIColor whiteColor];
        _totalLbl.font = [UIFont systemFontOfSize:10.0];
        _totalLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _totalLbl;
}
- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn =  [[UIButton alloc] init];
        [_fullScreenBtn setImage:[UIImage bd_imageNamed:@"btn_player_fullscreen"] forState:UIControlStateNormal];
        [_fullScreenBtn setImage:[UIImage bd_imageNamed:@"btn_player_smallscreen"] forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreenBtn.hidden = [TWBDPlayerConfig sharedInstance].hideFullScreenBtn;
    }
    return _fullScreenBtn;
}
    
- (NSTimer *)timer {
    if (self.isShowMenu == NO) {
        return nil;
    }
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

#pragma mark - Setter
- (void)setIsShowMenu:(BOOL)isShowMenu {
    _isShowMenu = isShowMenu;
    CGFloat fringeMargin = [TWUtil isHasFringe]? 10.0f : 0.0f;
    CGFloat edgeMargin = 10.0;

    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        if (isShowMenu) {
            [self.topContrainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
            }];
            [self.bottomContrainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self);
            }];
            [self.lockBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(fringeMargin + edgeMargin);
            }];
        } else {
            [self.topContrainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(- topHeight - fringeMargin);
            }];
            [self.bottomContrainerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(bottomHeight + fringeMargin);
            }];
            [self.lockBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(-50);
            }];
        }
        [self layoutIfNeeded];
    }];
}

- (void)setIsLocked:(BOOL)isLocked {
    _isLocked = isLocked;
    if (isLocked) {
        self.topContrainerView.hidden = YES;
        self.bottomContrainerView.hidden = YES;
    } else {
        self.topContrainerView.hidden = NO;
        self.bottomContrainerView.hidden = NO;
    }
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    _currentTime = currentTime;
    self.currentLbl.text = [self timeStrFormat:(NSInteger)currentTime];
    if (self.totalTime > 0.1f) {
        self.slider.value = (NSInteger)currentTime;// self.totalTime;
    }
}
- (void)setTotalTime:(NSTimeInterval)totalTime {
    _totalTime = totalTime;
    self.totalLbl.text = [self timeStrFormat:(NSInteger)totalTime];
    self.slider.maximumValue = (NSInteger)totalTime;
}

- (NSString *)timeStrFormat:(NSInteger)time {
    NSInteger t = time;
    NSInteger hours = t/60/60;
    NSInteger minutes = (t/60)%60;
    NSInteger seconds = t%60;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
}

- (void)setCurrentSpeedLevel:(NSInteger)currentSpeedLevel {
    _currentSpeedLevel = currentSpeedLevel;
    NSString *speedStr = [[TWBDPlayerConfig sharedInstance].speedArr objectAtIndex:currentSpeedLevel % 6];
    [self.speedBtn setTitle:speedStr forState:UIControlStateNormal];
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLbl.text = titleStr;
}

- (void)setIsFullScreen:(BOOL)isFullScreen {
    _isFullScreen = isFullScreen;
    self.fullScreenBtn.selected = isFullScreen;
}

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    self.playBtn.selected = isPlaying;
}

- (void)setIsReadyToPlay:(BOOL)isReadyToPlay {
    _isReadyToPlay = isReadyToPlay;
    self.bottomContrainerView.hidden = !isReadyToPlay;
    self.speedBtn.hidden = !isReadyToPlay;
    self.lockBtn.hidden = !isReadyToPlay;
}

@end
