//
//  SettingViewController.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/11.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "SettingViewController.h"
#import "ImageTools.h"

#define viewW self.view.bounds.size.width
#define viewH self.view.bounds.size.height

@interface SettingViewController ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bgView = [[UIImageView alloc]init];
    _bgView.frame = CGRectMake(0, 0, viewW, viewH);
    UIImage *settingImg = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"settingBG" ofType:@"jpg"]];
    NSData *imgdata = [ImageTools getImageDataWithImage:settingImg];
    _bgView.image = [UIImage imageWithData:imgdata];
    [self.view addSubview:_bgView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _backBtn.frame = CGRectMake(10, 10, 80, 80);
    UIImage *img = [UIImage imageNamed:@"settingBack.png"];
    img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_backBtn setImage:img forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}

-(void)backBtnClicked{
    
    self.reloadView();
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
