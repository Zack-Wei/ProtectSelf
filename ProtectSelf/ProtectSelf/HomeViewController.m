//
//  HomeViewController.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/3/18.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "HomeViewController.h"
#import "JohnStoryViewController.h"
#import "SecondChapterViewController.h"

#define viewW self.view.bounds.size.width
#define viewH self.view.bounds.size.height
#define chapterBtnW 380
#define chapterBtnH 360
#define padding 100

@interface HomeViewController ()

@property (nonatomic, strong) UIButton *boyBtn;
@property (nonatomic, strong) UIButton *girlBtn;
@property (nonatomic, strong) UIButton *g2Btn;
@property (nonatomic, strong) UIButton *b2Btn;
@property (nonatomic, strong) UIButton *g3Btn;
@property (nonatomic, strong) UIButton *b3Btn;

@property (nonatomic, strong) UIImageView *bgIV;
@property (nonatomic, strong) UIButton *ch1Btn;
@property (nonatomic, strong) UIButton *ch2Btn;
@property (nonatomic, strong) UIButton *ch3Btn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *homeBtn;

@property (nonatomic, strong) UIView *sexView;

@end

@implementation HomeViewController{
    int _chTag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左右滑手势
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    rightRecognizer.numberOfTouchesRequired = 1;
    [rightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:rightRecognizer];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    leftRecognizer.numberOfTouchesRequired = 1;
    [leftRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:leftRecognizer];
    
    [self setBGView];
    [self setSexView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark 背景图

- (void)setBGView{
    
    CGFloat btnY = 30;
    
    _bgIV = [[UIImageView alloc]init];
    _bgIV.frame = CGRectMake(0, 0, viewW, viewH);
    [_bgIV setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"HomeBGView" ofType:@".jpg"]]];
    [self.view addSubview:_bgIV];
    
    _ch1Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ch1Btn.frame = CGRectMake(0.5*(viewW - chapterBtnW), btnY, chapterBtnW, chapterBtnH);
    UIImage *ch1BtnImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"HomeCh1" ofType:@".png"]];
    ch1BtnImg = [ch1BtnImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ch1Btn setImage:ch1BtnImg forState:UIControlStateNormal];
    [_ch1Btn addTarget:self action:@selector(ch1BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ch1Btn];
    
    _ch2Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ch2Btn.frame = CGRectMake(CGRectGetMaxX(_ch1Btn.frame)+padding, btnY, chapterBtnW, chapterBtnH);
    UIImage *ch2BtnImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"HomeCh2" ofType:@".png"]];
    ch2BtnImg = [ch2BtnImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ch2Btn setImage:ch2BtnImg forState:UIControlStateNormal];
    [_ch2Btn addTarget:self action:@selector(ch2BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ch2Btn];
    
    _ch3Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ch3Btn.frame = CGRectMake(CGRectGetMaxX(_ch2Btn.frame)+padding, btnY, chapterBtnW, chapterBtnH);
    UIImage *ch3BtnImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"HomeCh3" ofType:@".png"]];
    ch3BtnImg = [ch3BtnImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_ch3Btn setImage:ch3BtnImg forState:UIControlStateNormal];
    [_ch3Btn addTarget:self action:@selector(ch3BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ch3Btn];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _leftBtn.frame = CGRectMake(CGRectGetMinX(_ch1Btn.frame)-padding*0.4 - 40, viewH/2 - 40, 20, 50);
    UIImage *leftBtnImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"HomeLeftArrow" ofType:@".png"]];
    leftBtnImg = [leftBtnImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_leftBtn setImage:leftBtnImg forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    _leftBtn.hidden = YES;
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rightBtn.frame = CGRectMake(CGRectGetMaxX(_ch1Btn.frame)+padding*0.4, viewH/2 - 40, 20, 50);
    UIImage *rightBtnImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"HomeRightArrow" ofType:@".png"]];
    rightBtnImg = [rightBtnImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_rightBtn setImage:rightBtnImg forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
    _homeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _homeBtn.frame = CGRectMake(10, 10, 50, 50);
    [_homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *homeImg = [UIImage imageNamed:@"home.png"];
    homeImg = [homeImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_homeBtn setImage:homeImg forState:UIControlStateNormal];
    [self.view addSubview:_homeBtn];
    
    _chTag = 0;
}

- (void)setSexView{
    
    _sexView = [[UIView alloc]init];
    _sexView.frame = CGRectMake(0, 0, viewW, viewH);
    _sexView.backgroundColor = [UIColor colorWithRed:101/255 green:83/255 blue:66/255 alpha:0.4];
    [self.view addSubview:_sexView];
    
    CGFloat btnW = 220;
    CGFloat btnH = 280;
    CGFloat pad = 20;
    
    UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    boyBtn.frame = CGRectMake(0.5*(viewW - 2*btnW - padding), 0.5*(viewH - btnH), btnW, btnH);
    UIImage *boyBtnImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"boyTag" ofType:@".png"]];
    boyBtnImg = [boyBtnImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [boyBtn setImage:boyBtnImg forState:UIControlStateNormal];
    [boyBtn addTarget:self action:@selector(boyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sexView addSubview:boyBtn];
    
    UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    girlBtn.frame = CGRectMake(CGRectGetMaxX(boyBtn.frame)+padding, 0.5*(viewH - btnH) + 0.5*pad, btnW, btnH - pad);
    UIImage *girlBtnImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"girlTag" ofType:@".png"]];
    girlBtnImg = [girlBtnImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [girlBtn setImage:girlBtnImg forState:UIControlStateNormal];
    [girlBtn addTarget:self action:@selector(girlBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_sexView addSubview:girlBtn];
    
}

- (void)boyBtnClicked{
    _isBoy = YES;
    [_sexView removeFromSuperview];
}

- (void)girlBtnClicked{
    _isBoy = NO;
    [_sexView removeFromSuperview];
}

#pragma mark pan   平移手势事件 & 画线过程的子方法

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self rightBtnClicked];
        
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self leftBtnClicked];
        
    }
}

#pragma mark 按钮

- (void)ch1BtnClicked{
    JohnStoryViewController *vc = [[JohnStoryViewController alloc]init];
    vc.isBoy = _isBoy;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ch2BtnClicked{
    SecondChapterViewController *vc = [[SecondChapterViewController alloc]init];
    vc.isBoy = _isBoy;
    vc.chapterTag = @"C3";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ch3BtnClicked{
    SecondChapterViewController *vc = [[SecondChapterViewController alloc]init];
    vc.isBoy = _isBoy;
    vc.chapterTag = @"C2";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftBtnClicked{
    
    if(_leftBtn.hidden)
        return;
    
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    
    CGRect ch1NewFrame = _ch1Btn.frame;
    CGRect ch2NewFrame = _ch2Btn.frame;
    CGRect ch3NewFrame = _ch3Btn.frame;
    
    ch1NewFrame.origin.x += chapterBtnW+padding;
    ch2NewFrame.origin.x += chapterBtnW+padding;
    ch3NewFrame.origin.x += chapterBtnW+padding;
    
    [UIView animateWithDuration:0.8 animations:^(){
        
        _ch1Btn.frame = ch1NewFrame;
        _ch2Btn.frame = ch2NewFrame;
        _ch3Btn.frame = ch3NewFrame;
        
    }completion:^(BOOL success){
        _chTag--;
        [self adjustArrowBtn];
    }];
}

- (void)rightBtnClicked{
    
    if(_rightBtn.hidden)
        return;
    
    _leftBtn.hidden = YES;
    _rightBtn.hidden = YES;
    
    CGRect ch1NewFrame = _ch1Btn.frame;
    CGRect ch2NewFrame = _ch2Btn.frame;
    CGRect ch3NewFrame = _ch3Btn.frame;
    
    ch1NewFrame.origin.x -= chapterBtnW+padding;
    ch2NewFrame.origin.x -= chapterBtnW+padding;
    ch3NewFrame.origin.x -= chapterBtnW+padding;
    
    [UIView animateWithDuration:0.8 animations:^(){
        
        _ch1Btn.frame = ch1NewFrame;
        _ch2Btn.frame = ch2NewFrame;
        _ch3Btn.frame = ch3NewFrame;
        
    }completion:^(BOOL success){
        _chTag++;
        [self adjustArrowBtn];
    }];
}

- (void)adjustArrowBtn{
    
    if (_chTag%3 == 0) {
        _leftBtn.hidden = YES;
        _rightBtn.hidden = NO;
    }else if (_chTag%3 == 1){
        _leftBtn.hidden = NO;
        _rightBtn.hidden = NO;
    }else{
        _leftBtn.hidden = NO;
        _rightBtn.hidden = YES;
    }
}

- (void)homeBtnClicked{
    
    self.reloadView();

    [_ch1Btn removeFromSuperview];
    [_ch2Btn removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
