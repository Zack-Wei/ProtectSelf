//
//  RootNavigationController.m
//  ProdectSelf
//
//  Created by 魏大同 on 2018/3/6.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (id)init{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}

- (void)setup{
    //其他设置
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/// 当前的导航控制器是否可以旋转
-(BOOL)shouldAutorotate{
    
    return YES;
}

//设置支持的屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return self.interfaceOrientationMask;
}

//设置presentation方式展示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return self.interfaceOrientation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
