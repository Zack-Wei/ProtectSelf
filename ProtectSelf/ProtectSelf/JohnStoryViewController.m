//
//  JohnStoryViewController.m
//  ProdectSelf
//
//  Created by 魏大同 on 2018/3/6.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "JohnStoryViewController.h"
#import "BatheViewController.h"
#import "RootNavigationController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"
#import "PSImageCache.h"

#define PortraitFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)
#define LandscpaeFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width)
#define ViewW [[UIScreen mainScreen]bounds].size.width
#define ViewH [[UIScreen mainScreen]bounds].size.height
#define PlayBtnWH 40
#define NextBtnWH 70
#define InkWH 50

@interface JohnStoryViewController ()

@property (nonatomic, strong) UIImageView *mainImageView;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *previousBtn;
@property (nonatomic, strong) UIButton *homeBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) NSMutableArray *bubbleArr;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation JohnStoryViewController{
    int _currentPage;
    BOOL _isPlay;
    BOOL _bubble;
    CGFloat _bubbleWH;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    // 表示本类支持旋转
    [UIViewController attemptRotationToDeviceOrientation];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
//    // 强制横屏
//    [self forceOrientationLandscape];
//
//    RootNavigationController *nav = (RootNavigationController *)self.navigationController;
//    nav.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
//    nav.interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
//
//    //强制翻转屏幕，Home键在右边。
//    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
//    //刷新
//    [UIViewController attemptRotationToDeviceOrientation];
    
    
}

//- (void)viewWillDisappear:(BOOL)animated{
//
//    //强制旋转竖屏
//    [self forceOrientationPortrait];
//    RootNavigationController *navi = (RootNavigationController *)self.navigationController;
//    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
//    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
//
//    //设置屏幕的转向为竖屏
//    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
//    //刷新
//    [UIViewController attemptRotationToDeviceOrientation];
//}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark setBackGroundImg

- (void)setUI{
    
    _mainImageView = [[UIImageView alloc]initWithFrame:PortraitFrame];
    [self.view addSubview:_mainImageView];
    _currentPage = 0;
    [self setBGImgVData];
    
    _homeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _homeBtn.frame = CGRectMake(15, 10, 50, 50);
    [_homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *homeImg = [UIImage imageNamed:@"home.png"];
    homeImg = [homeImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_homeBtn setImage:homeImg forState:UIControlStateNormal];
    [self.view addSubview:_homeBtn];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nextBtn.frame = CGRectMake(ViewW*0.85, ViewH*0.82, NextBtnWH, NextBtnWH);
    [_nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *nextImg = [UIImage imageNamed:@"boy_next"];
    nextImg = [nextImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_nextBtn setImage:nextImg forState:UIControlStateNormal];
    [self.view addSubview:_nextBtn];
    
    _previousBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _previousBtn.frame = CGRectMake(ViewW*0.23, ViewH*0.82, NextBtnWH, NextBtnWH);
    [_previousBtn addTarget:self action:@selector(previousBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *previousImg = [UIImage imageNamed:@"boy_previous"];
    previousImg = [previousImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_previousBtn setImage:previousImg forState:UIControlStateNormal];
    [self.view addSubview:_previousBtn];
    _previousBtn.hidden = YES;
    _previousBtn.enabled = NO;
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _playBtn.frame = (_isBoy)?CGRectMake(ViewW*0.065, ViewH*0.71, PlayBtnWH, PlayBtnWH):CGRectMake(ViewW*0.061, ViewH*0.715, PlayBtnWH, PlayBtnWH);
    [_playBtn addTarget:self action:@selector(playorStopBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIImage *stopImg = (_isBoy)?[UIImage imageNamed:@"boy_stop"]:[UIImage imageNamed:@"girl_stop"];
    stopImg = [stopImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_playBtn setImage:stopImg forState:UIControlStateNormal];
    _isPlay = YES;
    [self.view addSubview:_playBtn];
    
    _textLab = [[UILabel alloc]init];
    _textLab.frame = CGRectMake(CGRectGetMaxX(_previousBtn.frame)+5, CGRectGetMinY(_previousBtn.frame)-10, CGRectGetMinX(_nextBtn.frame)-CGRectGetMaxX(_previousBtn.frame)-10, ViewH-CGRectGetMinY(_previousBtn.frame)-20);
    _textLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    _textLab.numberOfLines = 0;
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.text = (_isBoy)?@"你好，我的名字叫约翰，我和你一样是个小男生。":@"你好，我的名字叫苏西，我和你一样是个小女生。";
    [self.view addSubview:_textLab];
    
    [self playAudioWithName:nil];
}

- (void)setBGImgVData{
    
    NSString *imgName = (_isBoy)?[NSString stringWithFormat:@"Boy_Reading_C1_%d.jpg",_currentPage]:[NSString stringWithFormat:@"Girl_Reading_C1-%d.jpg",_currentPage];
    NSString *nextImgName = (_isBoy)?[NSString stringWithFormat:@"Boy_Reading_C1_%d.jpg",_currentPage+1]:[NSString stringWithFormat:@"Girl_Reading_C1-%d.jpg",_currentPage+1];


    static PSImageCache *cache = nil;
    if (!cache) {
        cache = [[PSImageCache alloc]init];
    }

    UIImage *image = [cache loadImgWithPath:imgName];
    [cache cacheNextImgWithPath:nextImgName];

    if (image) {
        _mainImageView.image = image;
    }else{
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:nil]];
        _mainImageView.image = [UIImage imageWithData:[self getImageDataWithImage:image]];
    }
    
}

- (NSData *)getImageDataWithImage:(UIImage *)image{
    
    //实现等比例缩放
    double hfactor = image.size.width / ViewW;
    double vfactor = image.size.height / ViewH;
    double factor = fmax(hfactor, vfactor);

    //画布大小
    CGFloat newWith = image.size.width / factor;
    CGFloat newHeigth = image.size.height / factor;
    CGSize newSize = CGSizeMake(newWith, newHeigth);

    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, newWith, newHeigth);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //图像压缩
    NSData *newImageData = UIImageJPEGRepresentation(newImage, 1);
    
    return newImageData;
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

#pragma mark 点击效果

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:_mainImageView];
    CGRect imgRect = CGRectMake(pos.x - 0.5*InkWH, pos.y - 0.5*InkWH, InkWH, InkWH);
    
    switch (_currentPage) {
        case 0:{
            
            UIImageView *imagView = [[UIImageView alloc]initWithFrame:imgRect];
            int n = rand()%4;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"InkDot%d.png",n]];
            imagView.image = image;
            [self.mainImageView addSubview:imagView];
            
            break;
        }
        case 1:{
            
            int padding = rand()%20;
    
            CGRect imgRect = CGRectMake(pos.x - 0.5*(InkWH+padding), pos.y - 0.5*(InkWH+padding), InkWH+padding, InkWH+padding);
            UIImageView *imagView = [[UIImageView alloc]initWithFrame:imgRect];
            UIImage *image = [UIImage imageNamed:@"star.png"];
            imagView.image = image;
            [self.mainImageView addSubview:imagView];
            
            break;
        }
        case 2:{
            CGFloat padding = 10;
            CGRect imgRect = CGRectMake(pos.x - 0.5*(InkWH+padding), pos.y - 0.5*(InkWH+padding), InkWH+padding, InkWH+padding);
            UIImageView *imagView = [[UIImageView alloc]initWithFrame:imgRect];
            int n = rand()%5;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble_%d.png",n]];
            imagView.image = image;
            [self.mainImageView addSubview:imagView];
            
            break;
        }
        case 3:{
            CGFloat padding = 20;
            CGRect imgRect = CGRectMake(pos.x - 0.5*(InkWH+padding), pos.y - 0.5*(InkWH+padding), InkWH+padding, InkWH+padding);
            UIImageView *imagView = [[UIImageView alloc]initWithFrame:imgRect];
            int n = rand()%5;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble_%d.png",n]];
            imagView.image = image;
            [self.mainImageView addSubview:imagView];
            
            break;
        }
        case 4:{
            CGFloat padding = 30;
            CGRect imgRect = CGRectMake(pos.x - 0.5*(InkWH+padding), pos.y - 0.5*(InkWH+padding), InkWH+padding, InkWH+padding);
            UIImageView *imagView = [[UIImageView alloc]initWithFrame:imgRect];
            int n = rand()%5;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble_%d.png",n]];
            imagView.image = image;
            [self.mainImageView addSubview:imagView];
            
            break;
        }
        case 5:{
            
            CGRect bubbleBGRect = (_isBoy)?CGRectMake(30, 160, 210, 140):CGRectMake(450, 220, 210, 140);
            BOOL posXin = bubbleBGRect.origin.x < pos.x && pos.x < bubbleBGRect.origin.x+bubbleBGRect.size.width;
            BOOL posYin = bubbleBGRect.origin.y < pos.y && pos.y < bubbleBGRect.origin.y+bubbleBGRect.size.height;
            
            if(posXin && posYin){
                
                UIImageView *bubbleV = [[UIImageView alloc]init];
                bubbleV.frame = CGRectMake(pos.x - 0.5*_bubbleWH, pos.y - 0.5*_bubbleWH, _bubbleWH, _bubbleWH);
                
                int n = rand()%5;
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bubble_%d.png",n]];
                bubbleV.image = image;
                
                [self.mainImageView addSubview:bubbleV];
                [_bubbleArr addObject:bubbleV];
            }
            
            break;
        }
        case 6:{
            
            break;
        }
        default:
            break;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:_mainImageView];
    
    if (_currentPage == 5) {
        
        UIImageView *bubbleV = [_bubbleArr lastObject];
        bubbleV.frame = CGRectMake(pos.x - 0.5*_bubbleWH, pos.y - 0.5*_bubbleWH, _bubbleWH, _bubbleWH);
        
    }else{
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

#pragma mark 翻页及暂停

- (void)homeBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtnClicked{
    if(_currentPage < 7){
        _currentPage++;
        
        for (UIImageView *iv in [self.mainImageView subviews]) {
            [iv removeFromSuperview];
        }
        
        [self setBGImgVData];
        [self hiddenNextOrPreviousBtn];
        [self layoutUIAndSetText];
        [self playAudioWithName:nil];
    }else{
    }
}

- (void)previousBtnClicked{
    if(_currentPage > 0){
        _currentPage--;
        
        for (UIImageView *iv in [self.mainImageView subviews]) {
            [iv removeFromSuperview];
        }
        
        [self setBGImgVData];
        [self hiddenNextOrPreviousBtn];
        [self layoutUIAndSetText];
        [self playAudioWithName:nil];
    }else{
    }
    
}

- (void)playorStopBtnClicked{
    
    if (_isPlay) {
        _isPlay = NO;
        UIImage *stopImg = (_isBoy)?[UIImage imageNamed:@"boy_paly.png"]:[UIImage imageNamed:@"girl_paly.png"];
        stopImg = [stopImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_playBtn setImage:stopImg forState:UIControlStateNormal];
        [_audioPlayer pause];
    }else if (!_isPlay){
        _isPlay = YES;
        UIImage *stopImg = (_isBoy)?[UIImage imageNamed:@"boy_stop.png"]:[UIImage imageNamed:@"girl_stop.png"];
        stopImg = [stopImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_playBtn setImage:stopImg forState:UIControlStateNormal];
        [_audioPlayer play];
    }
    
}

- (void)hiddenNextOrPreviousBtn{
    if(_currentPage == 7){
        _nextBtn.hidden = YES;
        _nextBtn.enabled = NO;
    }else{
        _nextBtn.hidden = NO;
        _nextBtn.enabled = YES;
    }
    if(_currentPage == 0){
        _previousBtn.hidden = YES;
        _previousBtn.enabled = NO;
    }else{
        _previousBtn.hidden = NO;
        _previousBtn.enabled = YES;
    }
}

- (void)layoutUIAndSetText{
    switch (_currentPage) {
        case 0:{
            _playBtn.frame = (_isBoy)?CGRectMake(ViewW*0.065, ViewH*0.71, PlayBtnWH, PlayBtnWH):CGRectMake(ViewW*0.061, ViewH*0.715, PlayBtnWH, PlayBtnWH);
            _textLab.text = (_isBoy)?@"你好，我的名字叫约翰，我和你一样是个小男生。":@"你好，我的名字叫苏西，我和你一样是个小女生。";
            break;
        }
        case 1:{
            _playBtn.frame = (_isBoy)?CGRectMake(ViewW*0.065, ViewH*0.72, PlayBtnWH, PlayBtnWH):CGRectMake(ViewW*0.06, ViewH*0.725, PlayBtnWH, PlayBtnWH);
            _textLab.text = @"一天很快的过去，太阳公公要休息了，月亮婆婆来上班啦。";
            break;
        }
        case 2:{
            _playBtn.frame = (_isBoy)?CGRectMake(ViewW*0.063, ViewH*0.705, PlayBtnWH, PlayBtnWH):CGRectMake(ViewW*0.061, ViewH*0.715, PlayBtnWH, PlayBtnWH);
            _textLab.text = (_isBoy)?@"约翰准备洗澡睡觉了。":@"苏西准备洗澡睡觉了";
            break;
        }
        case 3:{
            _playBtn.frame = (_isBoy)?CGRectMake(ViewW*0.063, ViewH*0.71, PlayBtnWH, PlayBtnWH):CGRectMake(ViewW*0.061, ViewH*0.712, PlayBtnWH, PlayBtnWH);
            _textLab.text = (_isBoy)?@"约翰洗澡的时候看到镜子里的自己慢慢的看不到了，觉得很奇怪，另一个自己去哪里了呢 ?":@"苏西洗澡的时候看到镜子里的自己慢慢的看不到了，觉得很奇怪，另一个自己去哪里了呢 ?";
            break;
        }
        case 4:{
            _playBtn.frame = (_isBoy)?CGRectMake(ViewW*0.063, ViewH*0.71, PlayBtnWH, PlayBtnWH):CGRectMake(ViewW*0.061, ViewH*0.712, PlayBtnWH, PlayBtnWH);
            _textLab.text = (_isBoy)?@"约翰洗澡的时候看到镜子里的自己慢慢的看不到了，觉得很奇怪，另一个自己去哪里了呢 ?":@"苏西洗澡的时候看到镜子里的自己慢慢的看不到了，觉得很奇怪，另一个自己去哪里了呢 ?";
            _textLab.frame = CGRectMake(CGRectGetMaxX(_previousBtn.frame)+5, CGRectGetMinY(_previousBtn.frame)-10, CGRectGetMinX(_nextBtn.frame)-CGRectGetMaxX(_previousBtn.frame)-10, ViewH-CGRectGetMinY(_previousBtn.frame)-20);
            _textLab.hidden = NO;
            break;
        }
        case 5:{
            
            _playBtn.frame = CGRectMake(ViewW*0.042, ViewH*0.74, PlayBtnWH, PlayBtnWH);
            _bubble = YES;
            [self setArrowWithAnimation];
            [self setBubble];
            _textLab.hidden = YES;
            
            if(_isBoy){
                UILabel *label = [[UILabel alloc]init];
                label.text = @"      这是阴茎，它的外号是小鸡鸡，这是我们男生和女生不一样的地方哦！它是我们身体很重要的一部分，是隐私部位，不能让别人看到和接触的！快用泡泡帮我遮起来吧。";
                label.frame = CGRectMake(ViewW*0.6, ViewH*0.2, ViewW*0.345, ViewH*0.4);
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
                [self.mainImageView addSubview:label];
               
            }else if (!_isBoy){
                UILabel *label = [[UILabel alloc]init];
                label.text = @"     这是乳房，随着我们的成长，乳房也会慢慢长大。\n        它属于我们的隐私部位，是不可以让别人看到和触碰的，快用泡泡帮我遮住吧。";
                label.frame = CGRectMake(ViewW*0.62, 15, ViewW*0.345, ViewH*0.3);
                label.numberOfLines = 0;
                label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
                [self.mainImageView addSubview:label];
                
                UILabel *lab = [[UILabel alloc]init];
                lab.frame = CGRectMake(ViewW*0.07, ViewH*0.155, ViewW*0.345, ViewH*0.35);
                lab.numberOfLines = 0;
                lab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
                lab.text = @"       这里是阴部，他是我们的生殖器官，记得要好好保护与清洗。\n       阴部也属于隐私部位，是不能让别人看到和吃碰的。快用泡泡帮我遮住吧！";
                [self.mainImageView addSubview:lab];

    
            }else{
            }
            
            break;
        }
            case 6:{
                _playBtn.frame = (_isBoy)?CGRectMake(ViewW*0.062, ViewH*0.71, PlayBtnWH, PlayBtnWH):CGRectMake(ViewW*0.062, ViewH*0.72, PlayBtnWH, PlayBtnWH);
                _textLab.text = (_isBoy)?@"洗香香的约翰在床上慢慢进入梦乡，美好的一天结束了。":@"洗香香的苏西在床上慢慢进入梦乡，美好的一天结束了。";
                _textLab.frame = CGRectMake(CGRectGetMaxX(_previousBtn.frame)+5, CGRectGetMinY(_previousBtn.frame)-10, CGRectGetMinX(_nextBtn.frame)-CGRectGetMaxX(_previousBtn.frame)-10, ViewH-CGRectGetMinY(_previousBtn.frame)-20);
                _textLab.hidden = NO;
            break;
            }case 7:{
                
                [self hiddenBtns];
                
                break;
            }
        default:
            break;
    }
}

- (void)hiddenBtns{
    _nextBtn.hidden = YES;
    _previousBtn.hidden = YES;
    _playBtn.hidden = YES;
    _textLab.hidden = YES;
}

#pragma mark 箭头动画效果&初始化泡泡

- (void)setArrowWithAnimation{
    
    UIImageView *arrowImageView = [[UIImageView alloc]init];
    arrowImageView.frame = (_isBoy)?CGRectMake(118, 50, 40, 80):CGRectMake(535, 120, 40, 80);
    [self.mainImageView addSubview:arrowImageView];
    
    arrowImageView.image = (_isBoy)?[UIImage imageNamed:@"Boy_Reading_C1_Arrow.png"]:[UIImage imageNamed:@"Girl_Reading_C1_Arrow.png"];

    CGRect newArrowRect = arrowImageView.frame;
    newArrowRect.origin.y += 40;
    
    [UIView animateWithDuration:0.8 animations:^{
        arrowImageView.frame = newArrowRect;
    } completion:^(BOOL succeed){
        if (succeed) {
            CGRect newArrowRect = arrowImageView.frame;
            newArrowRect.origin.y -= 40;
            
            [UIView animateWithDuration:0.8 animations:^{
                arrowImageView.frame = newArrowRect;
            } completion:^(BOOL succeed){
                if (succeed) {
                    [arrowImageView removeFromSuperview];
                    [self setArrowWithAnimation];
                }
            }];
        }
    }];
    
}

- (void)setBubble{
    
    UIImageView *imgView = [[UIImageView alloc]init];
    _bubbleArr = [NSMutableArray array];
    _bubbleWH = 70;
    
    if(_isBoy){
        imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Boy_BubbleBG.png" ofType:nil]];
        imgView.frame = CGRectMake(30, 160, 210, 140);
    }else{
        imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Girl_BubbleBG.png" ofType:nil]];
        imgView.frame = CGRectMake(450, 220, 210, 140);
    }
    
    [self.mainImageView addSubview:imgView];
}

#pragma mark audioPlayer

- (void)playAudioWithName:(NSString *)name{
    
    AudioPlayer *audioTools = [[AudioPlayer alloc]init];
   
    if(name == nil){
    _audioPlayer = (_isBoy)?[audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"CH1_%d_BOY",_currentPage+1]]:[audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"Girl_C1_%d",_currentPage]];
    }else{
        _audioPlayer = [audioTools audioPlayerWithAudioPath:name];
    }
    
}

@end
