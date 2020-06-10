//
//  RootNavigationController.h
//  ProdectSelf
//
//  Created by 魏大同 on 2018/3/6.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootNavigationController : UINavigationController

//旋转方向 默认竖屏
@property (nonatomic , assign) UIInterfaceOrientation interfaceOrientation;
@property (nonatomic , assign) UIInterfaceOrientationMask interfaceOrientationMask;

@end
