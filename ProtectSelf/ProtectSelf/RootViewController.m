//
//  RootViewController.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/9.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "RootViewController.h"
#import "RootNavigationController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "AboutViewController.h"
#import "GameViewController.h"
#import "SettingViewController.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()

@property (nonatomic, strong) AVPlayer *player;     //播放器
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *readingBtn;
@property (nonatomic, strong) UIButton *gameBtn;
@property (nonatomic, strong) UIButton *aboutBtn;
@property (nonatomic, strong) UIButton *settingBtn;

@end

@implementation RootViewController

#pragma mark - 懒加载AVPlayer
- (AVPlayer *)player
{
    if (!_player) {
        
        //获取本地视频文件路径
        NSString *path = [[NSBundle mainBundle]pathForResource:@"register_guide_video" ofType:@"mp4"];
        
        NSURL *url = [NSURL fileURLWithPath:path];
        
        //创建一个播放的item
        AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:url];
        
        //播放设置
        _player = [AVPlayer playerWithPlayerItem:playItem];
        //永不暂停
        _player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
        
        //设置播放器
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0, 0, kScreenW, kScreenH);
        
        //KVO播放结束回掉
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification   object:self.player.currentItem];
        
        // 将播放器至于底层，不然UI部分会被视频遮挡
        [self.view.layer insertSublayer:_playerLayer atIndex:0];
        
    }
    return _player;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 表示本类支持旋转
    [UIViewController attemptRotationToDeviceOrientation];
    
    
}

#pragma mark - 视图即将出现的时候就播放视频，会显着比较流畅
- (void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    // 强制横屏
    [self forceOrientationLandscape];
    
    RootNavigationController *nav = (RootNavigationController *)self.navigationController;
    nav.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    nav.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    
    //播放视频
    if(_isLaunching){
        [self.player play];
    }else{
        //[self setUI];
    }
    
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark 设置tabBar设置控制器可旋转

/// 选择的当前控制器是否可以旋转
-(BOOL)shouldAutorotate{
    
    return [self.tabBarCon.selectedViewController shouldAutorotate];
}

// 选择的当前控制器是支持的旋转的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return  [self.tabBarCon.selectedViewController supportedInterfaceOrientations];
}

///
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return  [self.tabBarCon.selectedViewController preferredInterfaceOrientationForPresentation];
}

#pragma  mark 横屏设置
//强制横屏
- (void)forceOrientationLandscape{
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    appdelegate.isForcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}

//强制竖屏
- (void)forceOrientationPortrait{
    
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForcePortrait=YES;
    appdelegate.isForceLandscape=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark AVPlayerDelegate

- (void)playbackFinished:(NSNotification *)noti{
    
    [_playerLayer removeFromSuperlayer];
    _player = nil;
    _playerLayer = nil;
    
    [self setUI];
}

#pragma mark setUI

-(void)setUI{
    
    CGFloat btnW = 140;
    CGFloat btnH = 140;
    CGFloat viewW = self.view.bounds.size.width;
    CGFloat viewH = self.view.bounds.size.height;
    
    _bgView = [[UIImageView alloc]init];
    _bgView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    [_bgView setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"mainView" ofType:@".jpg"]]];
    [self.view addSubview:_bgView];
    
    _readingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _readingBtn.frame = CGRectMake(0.3*viewW, 0.14*viewH, btnW, btnH);
    UIImage *readingImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"reading0" ofType:@".png"]];
    readingImg = [readingImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_readingBtn setImage:readingImg forState:UIControlStateNormal];
    [_readingBtn addTarget:self action:@selector(readingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_readingBtn];
    
    _gameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _gameBtn.frame = CGRectMake(0.502*viewW, 0.314*viewH, btnW, btnH);
    UIImage *gameImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"game0" ofType:@".png"]];
    gameImg = [gameImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_gameBtn setImage:gameImg forState:UIControlStateNormal];
    [_gameBtn addTarget:self action:@selector(gameBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gameBtn];
    
    _aboutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _aboutBtn.frame = CGRectMake(0.23*viewW, 0.458*viewH, btnW, btnH);
    UIImage *aboutImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"about0" ofType:@".png"]];
    aboutImg = [aboutImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_aboutBtn setImage:aboutImg forState:UIControlStateNormal];
    [_aboutBtn addTarget:self action:@selector(aboutBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aboutBtn];
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _settingBtn.frame = CGRectMake(20, 20, 40, 40);
    UIImage *settingImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"setting" ofType:@".png"]];
    settingImg = [settingImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_settingBtn setImage:settingImg forState:UIControlStateNormal];
    [_settingBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingBtn];
    
}

#pragma mark ButtonClicked

- (void)readingBtnClicked{
    
    
    HomeViewController *vc = [[HomeViewController alloc]init];

    __weak typeof(self) weakSelf = self;
    vc.reloadView = ^(){
        weakSelf.isLaunching = NO;
    };
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)gameBtnClicked{
    
    GameViewController *vc = [[GameViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    vc.reloadView = ^(){
        weakSelf.isLaunching = NO;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)aboutBtnClicked{
    
    AboutViewController *vc = [[AboutViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    vc.reloadView = ^(){
        weakSelf.isLaunching = NO;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
   
    
}

- (void)settingBtnClicked{
    
    SettingViewController *vc = [[SettingViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    vc.reloadView = ^(){
        weakSelf.isLaunching = NO;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
