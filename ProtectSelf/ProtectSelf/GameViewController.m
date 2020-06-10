//
//  GameViewController.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/10.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "GameViewController.h"
#import "ImageTools.h"
#import "AudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <SVProgressHUD.h>

#define PortraitFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)
#define LandscpaeFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width)
#define ViewW [[UIScreen mainScreen]bounds].size.width
#define ViewH [[UIScreen mainScreen]bounds].size.height
#define PlayBtnWH 40
#define NextBtnWH 140
#define InkWH 50
#define viewW self.view.bounds.size.width
#define viewH self.view.bounds.size.height

@interface GameViewController ()

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *homeBtn;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation GameViewController{
    int _currentPage;
    BOOL _answer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
     [self setUIData];
    
}

- (void)setUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:193.0/255.0 blue:207.0/255.0 alpha:1];
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    _mainImageView = [[UIImageView alloc]initWithFrame:PortraitFrame];
    [self.view addSubview:_mainImageView];
    
    
    _homeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _homeBtn.frame = CGRectMake(15, 10, 50, 50);
    [_homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_homeBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_homeBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rightBtn.frame = CGRectMake(ViewW*0.55, ViewH*0.82, NextBtnWH, NextBtnWH);
    [_rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_rightBtn];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _leftBtn.frame = CGRectMake(ViewW*0.23, ViewH*0.82, NextBtnWH, NextBtnWH);
    [_leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_leftBtn];
    
    
    
}


- (void)setUIData{
    
    _currentPage = 0;
    [self setBGImgVDataWithImgName:nil];
    
    [self playAudioWithName:nil];
    
    [SVProgressHUD dismiss];
    
}

- (void)setBGImgVDataWithImgName:(NSString *)imgN{
    
    
    NSString *imgName = [NSString string];
    NSString *imgName2 = [NSString string];
    
    if (imgN == nil) {
        imgName = [NSString stringWithFormat:@"game%d_1.jpg",_currentPage+1];
        imgName2 = [NSString stringWithFormat:@"game%d_2.jpg",_currentPage+1];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:nil]];
        UIImage *image2 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName2 ofType:nil]];
        
        NSArray *imgArr = @[[UIImage imageWithData:[ImageTools getImageDataWithImage:image]],[UIImage imageWithData:[ImageTools getImageDataWithImage:image2]]];
        
        _mainImageView.animationImages = imgArr;
        _mainImageView.animationDuration = 2.0f;
        _mainImageView.animationRepeatCount = 0;
        [_mainImageView startAnimating];
        
    }else{
        imgName = imgN;
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgName ofType:nil]];
        
        _mainImageView.image = [UIImage imageWithData:[ImageTools getImageDataWithImage:image]];
    }
    
    //_mainImageView.image = image;
    
}


#pragma mark 翻页及暂停

- (void)homeBtnClicked{
    
    self.reloadView();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dissmissWithoutAnimated{
    self.reloadView();
    [self.navigationController popViewControllerAnimated:NO];
    
}


- (void)leftBtnClicked{
    
    [_mainImageView stopAnimating];
    [self setBGImgVDataWithImgName:[NSString stringWithFormat:@"game%d_3.jpg",_currentPage+1]];
    [self performSelector:@selector(nextPage) withObject:nil afterDelay:2];
    
    [_audioPlayer stop];
}

- (void)rightBtnClicked{
    
    [_mainImageView stopAnimating];
    [self setBGImgVDataWithImgName:[NSString stringWithFormat:@"game%d_4.jpg",_currentPage+1]];
    [self performSelector:@selector(nextPage) withObject:nil afterDelay:2];
    
    [_audioPlayer stop];
}

- (void)nextPage{
    
    if(_currentPage == 9){
        
        
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 11; i>0; i--) {
            
            NSString *imgName = [NSString stringWithFormat:@"curtain%d.png",i];
            UIImage *img = [UIImage imageNamed:imgName];
            if (!img) {
                NSString *imgName = [NSString stringWithFormat:@"curtain%d.jpg",i];
                img = [UIImage imageNamed:imgName];
            }
            [imageArr addObject:img];
        }
        
        NSString *imgName = [NSString stringWithFormat:@"curtain1.jpg"];
        UIImage *img = [UIImage imageNamed:imgName];
        [imageArr addObject:img];
        
        for (int i = 1; i<11; i++) {
            
            NSString *imgName = [NSString stringWithFormat:@"curtain%d.png",i];
            UIImage *img = [UIImage imageNamed:imgName];
            if (!img) {
                NSString *imgName = [NSString stringWithFormat:@"curtain%d.jpg",i];
                img = [UIImage imageNamed:imgName];
            }
            [imageArr addObject:img];
        }
        
        UIImageView *curtainView = [[UIImageView alloc]init];
        curtainView.image = [UIImage animatedImageWithImages:[imageArr copy] duration:1.2];
        curtainView.frame = CGRectMake(0, 0, viewW, viewH);
        [self.view addSubview:curtainView];
        
        [self performSelector:@selector(homeBtnClicked) withObject:nil afterDelay:0.8];
        
        return;
    }
    _currentPage++;
    [self setBGImgVDataWithImgName:nil];
    [self playAudioWithName:nil];
}

#pragma mark audioPlayer

- (void)playAudioWithName:(NSString *)name{
    
    AudioPlayer *audioTools = [[AudioPlayer alloc]init];
    
    if(name == nil){
        
        _audioPlayer = [audioTools audioPlayerWithAudioPath:[NSString stringWithFormat:@"game%d",_currentPage+1]];
        
        
    }else{
        _audioPlayer = [audioTools audioPlayerWithAudioPath:name];
    }
}



@end
