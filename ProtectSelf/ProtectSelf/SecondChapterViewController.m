//
//  SecondChapterViewController.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/3/22.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "SecondChapterViewController.h"
#import "RootNavigationController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioPlayer.h"

#define PortraitFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)
#define LandscpaeFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width)
#define ViewW [[UIScreen mainScreen]bounds].size.width
#define ViewH [[UIScreen mainScreen]bounds].size.height
#define PlayBtnWH 40
#define NextBtnWH 70
#define InkWH 50
#define viewW self.view.bounds.size.width
#define viewH self.view.bounds.size.height

@interface SecondChapterViewController ()

@property (nonatomic, strong) UIImageView *mainImageView;

@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *previousBtn;
@property (nonatomic, strong) UIButton *homeBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *textLab;
@property (nonatomic, strong) NSMutableArray *bubbleArr;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation SecondChapterViewController{
    int _currentPage;
    BOOL _isPlay;
    BOOL _bubble;
    CGFloat _bubbleWH;
    BOOL _answer;
    
    UIButton *aBtn;
    UIButton *bBtn;
    UIButton *cBtn;
    UIButton *dBtn;
    UIButton *yesBtn;
    UIButton *noBtn;
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
    [self setBGImgVDataWithImgName:nil];
    
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
    _textLab.frame = CGRectMake(CGRectGetMaxX(_previousBtn.frame)+10, CGRectGetMinY(_previousBtn.frame)-10, CGRectGetMinX(_nextBtn.frame)-CGRectGetMaxX(_previousBtn.frame)-20, ViewH-CGRectGetMinY(_previousBtn.frame)+5);
    _textLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    _textLab.numberOfLines = 0;
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"妈妈把我们生下来时很辛苦的。我们要好好爱妈妈哦～":@"你好，我是小河马是你们的新朋友。";
    [self.view addSubview:_textLab];
    
    [self playAudioWithName:nil];
    
}

- (void)setBGImgVDataWithImgName:(NSString *)imgN{
    
    NSString *imgName = [NSString string];
    
    if (imgN == nil) {
        
        if([_chapterTag isEqualToString:@"C2"]){
            imgName = (_isBoy)?[NSString stringWithFormat:@"Boy_Reading_C2_%d.jpg",_currentPage]:[NSString stringWithFormat:@"Girl_Reading_C2_%d.jpg",_currentPage];
        }else{
            imgName = (_isBoy)?[NSString stringWithFormat:@"Boy_Reading_C3_%d.jpg",_currentPage]:[NSString stringWithFormat:@"Girl_Reading_C3_%d.jpg",_currentPage];
        }
    }else{
        imgName = imgN;
    }
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:nil]];

    _mainImageView.image = [UIImage imageWithData:[self getImageDataWithImage:image]];
    //_mainImageView.image = image;
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
            UIImage *image = [UIImage imageNamed:@"love.png"];
            imagView.image = image;
            [self.mainImageView addSubview:imagView];
            
            break;
        }
        case 1:{
            
            int padding = rand()%15;
            
            CGRect imgRect = CGRectMake(pos.x - 0.5*(InkWH+padding), pos.y - 0.5*(InkWH+padding), InkWH+padding, InkWH+padding);
            UIImageView *imagView = [[UIImageView alloc]initWithFrame:imgRect];
            UIImage *image = [UIImage imageNamed:@"star.png"];
            imagView.image = image;
            [self.mainImageView addSubview:imagView];
            
            break;
        }
        case 2:{
            
            break;
        }
        case 3:{
           
            break;
        }
        case 4:{
            int i = rand()%3;
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:imgRect];
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"RedStar%d.png",i]];
            imgV.image = img;
            [self.mainImageView addSubview:imgV];
            break;
        }
        case 5:{
            
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
    
   
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

#pragma mark 翻页及暂停

- (void)homeBtnClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextBtnClicked{
    
    int i = ([_chapterTag isEqualToString:@"C2"])?28:16;
    
    if(_currentPage < i){
        _currentPage++;
        
        for (UIImageView *iv in [self.mainImageView subviews]) {
            [iv removeFromSuperview];
        }
        
        [self setBGImgVDataWithImgName:nil];
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
        
        [self setBGImgVDataWithImgName:nil];
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
    
    int i = ([_chapterTag isEqualToString:@"C2"])?28:16;
    
    if(_currentPage == i){
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
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"妈妈把我们生下来时很辛苦的。我们要好好爱妈妈哦～":@"你好，我是小河马是你们的新朋友。";
            [self showBtns];
            break;
        }
        case 1:{
    
            if ([_chapterTag isEqualToString:@"C2"]) {
                _textLab.text = @"同时我们也要好好保护自己～不要让妈妈担心呦！";
            }else if ([_chapterTag isEqualToString:@"C3"]){
                _textLab.text = @"你知道我们是从哪里来的吗？";
                
                CGFloat btnW = 140;
                CGFloat btnH = 80;
                
                yesBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                yesBtn.frame = CGRectMake(0.135*viewW, viewH*0.362, btnW, btnH);
                UIImage *yesImg = [UIImage imageNamed:@"yes.png"];
                yesImg = [yesImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [yesBtn setImage:yesImg forState:UIControlStateNormal];
                [yesBtn addTarget:self action:@selector(konwBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:yesBtn];
                
                noBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                noBtn.frame = CGRectMake(0.415*viewW, yesBtn.frame.origin.y, btnW, btnH);
                UIImage *noImg = [UIImage imageNamed:@"no.png"];
                noImg = [noImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [noBtn setImage:noImg forState:UIControlStateNormal];
                [noBtn addTarget:self action:@selector(konwBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:noBtn];
                
                _nextBtn.hidden = YES;
                _previousBtn.hidden = YES;
                
            }
            
            break;
        }
        case 2:{
            
            if([_chapterTag isEqualToString:@"C2"]){
                _textLab.text = @"下面就让我们学习怎么分辨坏人吧！";
            }else if ([_chapterTag isEqualToString:@"C3"]){
                
                [self hiddenBtns];
                
                CGFloat btnW = 200;
                CGFloat btnH = 60;
                //CGFloat padding = 35;
                CGFloat padding = viewH * 0.08;
                
                aBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                aBtn.frame = CGRectMake(0.5*(viewW - btnW + padding), 30, btnW - padding, btnH);
                UIImage *aImg = [UIImage imageNamed:@"A.png"];
                aImg = [aImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [aBtn setImage:aImg forState:UIControlStateNormal];
                [aBtn addTarget:self action:@selector(wrongAnswer) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:aBtn];
                
                bBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                bBtn.frame = CGRectMake(0.5*(viewW - btnW), CGRectGetMaxY(aBtn.frame) +padding, btnW, btnH);
                UIImage *bImg = [UIImage imageNamed:@"B.png"];
                bImg = [bImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [bBtn setImage:bImg forState:UIControlStateNormal];
                [bBtn addTarget:self action:@selector(wrongAnswer) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:bBtn];
                
                cBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                cBtn.frame = CGRectMake(0.5*(viewW - btnW), CGRectGetMaxY(bBtn.frame) +padding, btnW, btnH);
                UIImage *cImg = [UIImage imageNamed:@"C.png"];
                cImg = [cImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [cBtn setImage:cImg forState:UIControlStateNormal];
                [cBtn addTarget:self action:@selector(rightAnswer) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:cBtn];
                
                dBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                dBtn.frame = CGRectMake(0.5*(viewW - 1.6*btnW), CGRectGetMaxY(cBtn.frame) +padding, 1.6*btnW, btnH);
                UIImage *dImg = [UIImage imageNamed:@"D.png"];
                dImg = [dImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [dBtn setImage:dImg forState:UIControlStateNormal];
                [dBtn addTarget:self action:@selector(wrongAnswer) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:dBtn];
                
                
            }
            
            break;
        }
        case 3:{
            if([_chapterTag isEqualToString:@"C2"]){
                _textLab.text = @"坏人有时候看起来跟其他人一样。";
            }else if([_chapterTag isEqualToString:@"C3"]){
                
                [self showBtns];
                if (_answer) {
                    _textLab.text = @"答对了，你真棒！";
                    (_isBoy)?[self setBGImgVDataWithImgName:@"Boy_Reading_C3_3R.jpg"]:[self setBGImgVDataWithImgName:@"Girl_Reading_C3_3R.jpg"];
                    
                    [self performSelector:@selector(playAudioWithName:) withObject:@"CH2_4Yes" afterDelay:0.1];
                    
                }else{
                    _textLab.text = @"这个选项是错误的哦。";
                    (_isBoy)?[self setBGImgVDataWithImgName:@"Boy_Reading_C3_3W.jpg"]:[self setBGImgVDataWithImgName:@"Girl_Reading_C3_3W.jpg"];
                    [self performSelector:@selector(playAudioWithName:) withObject:@"CH2_4_No" afterDelay:0.1];
                }
            }
            break;
        }
        case 4:{
            if([_chapterTag isEqualToString:@"C2"]){
                _textLab.text = @"他们可能是长得好看的人， 可能是对你微笑的人，也可能是炫酷的人。";
            }else if ([_chapterTag isEqualToString:@"C3"]){
                _textLab.text = @"让我们来更加清楚的看看我们是怎么出现的吧。";
                if(_answer){
                    (_isBoy)?[self setBGImgVDataWithImgName:@"Boy_Reading_C3_3R.jpg"]:[self setBGImgVDataWithImgName:@"Girl_Reading_C3_3R.jpg"];
                }else{
                    (_isBoy)?[self setBGImgVDataWithImgName:@"Boy_Reading_C3_3W.jpg"]:[self setBGImgVDataWithImgName:@"Girl_Reading_C3_3W.jpg"];
                }
                
            }
            break;
        }
        case 5:{
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"他们可能会给你美味的食物。 记住！外表不是判断坏人的唯一标准哦。":@"有一天，精子先生遇到了卵子小姐。";
            break;
        }
        case 6:{
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"下面， 我们来复习一下身体的隐私部位。":@"精子先生钻到了卵子小姐的肚子里。";
            break;
        }
        case 7:{
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"对男生而言，他们的生殖器官和屁股是隐私部位。":@"它们在妈妈的肚子里一点点长大。";
            break;
        }
        case 8:{
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"对女生而言，她们的乳房、生殖器官和屁股是隐私部位。":@"慢慢的，开始有了小孩的样子。";
            break;
        }
        case 9:{
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"这些部位之所以叫隐私部位，是因为这些地方不能被别人看到和接触，我们需要用衣服遮住这些地方。":@"妈妈为了我们能好好的长大，一直给我们输入丰富的营养和好听的音乐。";
            break;
        }
        case 10:{
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"如果有人想看你的隐私部位，或者让你们看别人的隐私部位。":@"这时我们也越来越大了，长得越来越好看了。";
            _textLab.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 11:{
            if([_chapterTag isEqualToString:@"C2"]){
                _textLab.text = @"          这就叫";
                _textLab.textAlignment = NSTextAlignmentLeft;
                UILabel *alertLab = [[UILabel alloc]init];
                alertLab.frame = CGRectMake(_textLab.frame.origin.x+100, _textLab.frame.origin.y, 200, 80);
                alertLab.text = @"“视觉警报” 。";
                alertLab.textColor = [UIColor redColor];
                alertLab.font = [UIFont systemFontOfSize:25 weight:UIFontWeightHeavy];
                [self.mainImageView addSubview:alertLab];
            }else if ([_chapterTag isEqualToString:@"C3"]){
                _textLab.text = @"调皮的我们也会有小脾气了，在妈妈肚子里乱动。";
            }
            break;
        }
        case 12:{
            _textLab.text = ([_chapterTag isEqualToString:@"C2"])?@"如果有人谈论隐私部位。":@"妈妈虽然很不舒服，还是很温柔的安抚我们。";
            _textLab.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 13:{
            if([_chapterTag isEqualToString:@"C2"]){
                _textLab.text = @"          这就叫 ";
                _textLab.textAlignment = NSTextAlignmentLeft;
                UILabel *alertLab = [[UILabel alloc]init];
                alertLab.frame = CGRectMake(_textLab.frame.origin.x+100, _textLab.frame.origin.y, 200, 80);
                alertLab.text = @"“言语警报” 。";
                alertLab.textColor = [UIColor redColor];
                alertLab.font = [UIFont systemFontOfSize:25 weight:UIFontWeightHeavy];
                [self.mainImageView addSubview:alertLab];
            }else if ([_chapterTag isEqualToString:@"C3"]){
                _textLab.text = @"在妈妈的悉心照顾下，我们长成了一个漂亮的模样。";
            }
            break;
        }
        case 14:{
            _textLab.text =([_chapterTag isEqualToString:@"C2"])? @"如果有人触碰你们的隐私部位， 或者要你们触碰他们的隐私部位。":@"等不及看到这个美丽的世界的我们又开始折腾妈妈了。";
            _textLab.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 15:{
            if([_chapterTag isEqualToString:@"C2"]){
                _textLab.text = @"          这就叫 ";
                _textLab.textAlignment = NSTextAlignmentLeft;
                UILabel *alertLab = [[UILabel alloc]init];
                alertLab.frame = CGRectMake(_textLab.frame.origin.x+100, _textLab.frame.origin.y, 200, 80);
                alertLab.text = @"“触碰警报” 。";
                alertLab.textColor = [UIColor redColor];
                alertLab.font = [UIFont systemFontOfSize:25 weight:UIFontWeightHeavy];
                [self.mainImageView addSubview:alertLab];
            }else if ([_chapterTag isEqualToString:@"C3"]){
                _textLab.text = @"在妈妈承受了很大的痛苦之后，我们来到了这个世界，见到了很多爱我们的人。";
            }
            break;
        }
        case 16:{
            if([_chapterTag isEqualToString:@"C2"]){
            _textLab.text = @"爸爸妈妈可以在帮你们清洗身体的时候、或者隐私部位受伤的时候， 触碰这些地方。";
            _textLab.textAlignment = NSTextAlignmentCenter;
            }else if ([_chapterTag isEqualToString:@"C3"]){
                [self hiddenBtns];
                
            }
            break;
        }
        case 17:{
            _textLab.text = @"请你的爸爸妈妈列一张可以看、谈论或是触碰你隐私部位的照顾者名单。";
            break;
        }
        case 18:{
            _textLab.text = @"这些人都只能在帮你们清洗身体或者是隐私部位受伤的时候才能看或者触碰你们的隐私部位。";
            break;
        }
        case 19:{
            _textLab.text = @"注意！除列表上的照顾者以外，其他人都不能看、谈论或是触碰你的隐私部位哦。";
            break;
        }
        case 20:{
            _textLab.text = @"坏人通常会在你独自一人的时候伤害你。";
            break;
        }
        case 21:{
            _textLab.text = @"千万不要接受陌生人给你的东西， 特别是在爸爸妈妈不在你身边的时候。";
            _textLab.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 22:{
            _textLab.text = @"单独与陌生人在一起就是";
            _textLab.textAlignment = NSTextAlignmentLeft;
            UILabel *alertLab = [[UILabel alloc]init];
            alertLab.frame = CGRectMake(_textLab.frame.origin.x+200, _textLab.frame.origin.y, 200, 80);
            alertLab.text = @"“独处警报” 。";
            alertLab.textColor = [UIColor redColor];
            alertLab.font = [UIFont systemFontOfSize:25 weight:UIFontWeightHeavy];
            [self.mainImageView addSubview:alertLab];
            break;
        }
        case 23:{
            _textLab.text = @"你要赶快去人群聚集的地方去。";
            _textLab.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 24:{
            _textLab.text = @"你可以和爸爸妈妈一起制作一张漂亮的“爱心圈”，列出可以拥抱、背或者亲吻你的人的名单。";
            break;
        }
        case 25:{
            _textLab.text = @"记住，爱心圈和照顾者是不一样的哦！";
            break;
        }
        case 26:{
            _textLab.text = @"除了爱心圈上的人，你不能允许其他任何人拥抱、背或者亲吻你门。";
            _textLab.textAlignment = NSTextAlignmentCenter;
            break;
        }
        case 27:{
            _textLab.text = @"      否则就叫";
            _textLab.textAlignment = NSTextAlignmentLeft;
            UILabel *alertLab = [[UILabel alloc]init];
            alertLab.frame = CGRectMake(_textLab.frame.origin.x+100, _textLab.frame.origin.y, 200, 80);
            alertLab.text = @"“约束警报” 。";
            alertLab.textColor = [UIColor redColor];
            alertLab.font = [UIFont systemFontOfSize:25 weight:UIFontWeightHeavy];
            [self.mainImageView addSubview:alertLab];
            break;
        }case 28:{
            
            [self hiddenBtns];
            
            CGFloat labW = 320;
            CGFloat labH = 200;
            
            UILabel *lab = [[UILabel alloc]init];
            lab.frame = CGRectMake(0.5*(viewW - labW), 35, labW, labH);
            lab.textColor = [UIColor whiteColor];
            lab.numberOfLines = 0;
            lab.font = [UIFont systemFontOfSize:25 weight:UIFontWeightBold];
            lab.text = @"真棒！\n你已经学习了所有内容。\n接下来去游戏章节，看看河马老师还准备了什么吧！";
            [self.mainImageView addSubview:lab];
            
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

- (void)showBtns{
    _nextBtn.hidden = NO;
    _previousBtn.hidden = NO;
    _playBtn.hidden = NO;
    _textLab.hidden = NO;
}

- (void)wrongAnswer{
    _answer = false;
    
    [aBtn removeFromSuperview];
    [bBtn removeFromSuperview];
    [cBtn removeFromSuperview];
    [dBtn removeFromSuperview];
    
    [self nextBtnClicked];
}

- (void)rightAnswer{
    _answer = true;
    
    [aBtn removeFromSuperview];
    [bBtn removeFromSuperview];
    [cBtn removeFromSuperview];
    [dBtn removeFromSuperview];
    
    [self nextBtnClicked];
}

- (void)konwBtnClicked{
    
    [yesBtn removeFromSuperview];
    [noBtn removeFromSuperview];
    
    [self nextBtnClicked];
    
}

- (void)unknowBtnClicked{
    [yesBtn removeFromSuperview];
    [noBtn removeFromSuperview];
    
    [self nextBtnClicked];
}

#pragma mark audioPlayer

- (void)playAudioWithName:(NSString *)name{
    
    AudioPlayer *audioTools = [[AudioPlayer alloc]init];
    
    if(name == nil){
    
        if([_chapterTag isEqualToString:@"C3"]){
            
            _audioPlayer = [audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"CH2_%d",_currentPage+1]];
        }else if ([_chapterTag isEqualToString:@"C2"]){
            
            _audioPlayer = (_isBoy)?[audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"BOY_CH3_%d",_currentPage+1]]:[audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"Girl_CH3_%d",_currentPage+1]];
        }else if([_chapterTag isEqualToString:@"C1"]){
            _audioPlayer = (_isBoy)?[audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"CH1_%d_BOY",_currentPage+1]]:[audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"Girl_CH1_%d",_currentPage]];
        }
    }else{
        _audioPlayer = [audioTools audioPlayerWithAudioPath:name];
    }
}


@end
