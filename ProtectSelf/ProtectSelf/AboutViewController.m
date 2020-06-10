//
//  AboutViewController.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/10.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "AboutViewController.h"
#import "ImageTools.h"
#import <SVProgressHUD.h>

#define viewW self.view.bounds.size.width
#define viewH self.view.bounds.size.height

@interface AboutViewController ()

@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *infoImgView;
@property (nonatomic, strong) UIImageView *infoTextView;
@property (nonatomic, strong) UIImageView *teamImgView;
@property (nonatomic, strong) UIImageView *teamTextView;
@property (nonatomic, strong) UIButton *homeBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *teamBtn;
@property (nonatomic, strong) UIButton *infoBtn;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:226/255.0 blue:212/255.0 alpha:1];

}

- (void) viewDidAppear:(BOOL)animated{
    
    [self setUI];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    
    _bgImgView = [[UIImageView alloc]init];
    _bgImgView.frame = CGRectMake(0, 0, viewW, viewH);
    UIImage *bgImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"aboutBGV" ofType:@"jpg"]];
    _bgImgView.image = [UIImage imageWithData:[ImageTools getImageDataWithImage:bgImage]];
    
    //_bgImgView.image = bgImage;
    
    //NSData *bgImgData = UIImageJPEGRepresentation(bgImage, 0.5);
    //_bgImgView.image = [UIImage imageWithData:bgImgData];
    
    [self.view addSubview:_bgImgView];
    
    _homeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _homeBtn.frame = CGRectMake(10, 10, 80, 80);
    [_homeBtn setBackgroundColor:[UIColor clearColor]];
    [_homeBtn addTarget:self action:@selector(homeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_homeBtn];
    
    _infoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_infoBtn setBackgroundColor:[UIColor clearColor]];
    _infoBtn.frame = CGRectMake(100, 255, 280, 100);
    [_infoBtn addTarget:self action:@selector(infoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_infoBtn];
    
    _teamBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _teamBtn.frame = CGRectMake(400, 255, 280, 100);
    [_teamBtn setBackgroundColor:[UIColor clearColor]];
    [_teamBtn addTarget:self action:@selector(teamBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_teamBtn];
    
    _infoImgView = [[UIImageView alloc]init];
    _infoImgView.frame = CGRectMake(viewW, 0, viewW, viewH);
    UIImage *infoImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"about_infoBGV" ofType:@"jpg"]];
    _infoImgView.image = [UIImage imageWithData:[ImageTools getImageDataWithImage:infoImg]];
    [self.view addSubview:_infoImgView];
    
    _teamImgView = [[UIImageView alloc]init];
    _teamImgView.frame = CGRectMake(viewW, 0, viewW, viewH);
    UIImage *teamImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"about_teamBGV" ofType:@"jpg"]];
    _teamImgView.image = [UIImage imageWithData:[ImageTools getImageDataWithImage:teamImg]];
    [self.view addSubview:_teamImgView];
    
    CGFloat headerHeight = viewH*0.14;
    
    _infoTextView = [[UIImageView alloc]init];
    _infoTextView.frame = CGRectMake(0, headerHeight, viewW,viewH - headerHeight);
    UIImage *infoTextImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"aboutInfoText" ofType:@"jpg"]];
    _infoTextView.image = [UIImage imageWithData:[ImageTools getImageDataWithImage:infoTextImg]];
    //_infoTextView.image = infoTextImg;
    [self.infoImgView addSubview:_infoTextView];
    
    _teamTextView = [[UIImageView alloc]init];
    _teamTextView.frame = CGRectMake(0, headerHeight, viewW,viewH - headerHeight);
    UIImage *teamTextImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"aboutTeamText" ofType:@"jpeg"]];
    _teamTextView.image = [UIImage imageWithData:[ImageTools getImageDataWithImage:teamTextImg]];
    //_teamImgView.image = teamTextImg;
    [self.teamImgView addSubview:_teamTextView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backBtn.frame = CGRectMake(10, 10, 80, 80);
    [_backBtn setBackgroundColor:[UIColor clearColor]];
    [_backBtn addTarget:self action:@selector(backBtnClickedWithButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    _backBtn.hidden = YES;
    
}

- (void)homeBtnClicked{
    
    self.reloadView();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backBtnClickedWithButton:(UIButton *)btn{
    
    _homeBtn.hidden = NO;
    _backBtn.hidden = YES;
    
    if (btn.tag == 1) {

        CGRect newInfoFrame = _teamImgView.frame;
        newInfoFrame.origin.x += viewW;
        
        [UIView animateWithDuration:0.4 animations:^(){
            
            _teamImgView.frame = newInfoFrame;
            
        }];
        
    }else if(btn.tag == 2){
        CGRect newInfoFrame = _infoImgView.frame;
        newInfoFrame.origin.x += viewW;
        
        [UIView animateWithDuration:0.4 animations:^(){
            
            _infoImgView.frame = newInfoFrame;
            
        }];
    }else{
    }
    
    
    
}

- (void)teamBtnClicked{
    
    _homeBtn.hidden = YES;
    _backBtn.hidden = NO;
    _backBtn.tag = 1;
    
    CGRect newInfoFrame = _teamImgView.frame;
    
    newInfoFrame.origin.x -= viewW;
    
    [UIView animateWithDuration:0.4 animations:^(){
        
        _teamImgView.frame = newInfoFrame;
        
    }];
    
}

- (void)infoBtnClicked{
    
    _homeBtn.hidden = YES;
    _backBtn.hidden = NO;
    _backBtn.tag = 2;
    
    CGRect newInfoFrame = _infoImgView.frame;
    
    newInfoFrame.origin.x -= viewW;
    
    [UIView animateWithDuration:0.4 animations:^(){
        
        _infoImgView.frame = newInfoFrame;
        
    }];
}

@end
