//
//  BatheViewController.m
//  ProdectSelf
//
//  Created by 魏大同 on 2018/3/6.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "BatheViewController.h"
#import "RootNavigationController.h"
#import "AppDelegate.h"

#define PortraitFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)
#define LandscpaeFrame CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.height, [[UIScreen mainScreen]bounds].size.width)
#define RECTWH 30

@interface BatheViewController ()

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation BatheViewController{
    
    int _currentPage;
    CGPoint _previousPoint;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBGImgV];
    
    [self createFogMask];
    
    // 表示本类支持旋转
    [UIViewController attemptRotationToDeviceOrientation];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
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
}

- (void)viewWillDisappear:(BOOL)animated{
    
    //强制旋转竖屏
    [self forceOrientationPortrait];
    RootNavigationController *navi = (RootNavigationController *)self.navigationController;
    navi.interfaceOrientation = UIInterfaceOrientationPortrait;
    navi.interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark setBackGroundImg&Mask

- (void)setBGImgV{
    
    _mainImageView = [[UIImageView alloc]initWithFrame:LandscpaeFrame];
    [self.view addSubview:_mainImageView];
    _currentPage = 0;
    [self setBGImgVData];
    
}

- (void)setBGImgVData{
    
    NSString *imgName = [NSString stringWithFormat:@"bathe%d.jpg",_currentPage];
    _mainImageView.image = [UIImage imageNamed:imgName];
    
}

- (void)createFogMask{
    
    _maskView = [[UIView alloc]initWithFrame:LandscpaeFrame];
    _maskView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_maskView];
    
}

#pragma mark 设置tabBar设置控制器可旋转

/// 选择的当前控制器是否可以旋转
-(BOOL)shouldAutorotate{
    
    return [self.tabBarCon.selectedViewController shouldAutorotate];
}

/// 选择的当前控制器是支持的旋转的方向
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

#pragma mark 实现刮刮乐效果

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    CGPoint startPoint = [touch locationInView:_maskView];
    _previousPoint = startPoint;
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 触摸任意位置
    UITouch *touch = touches.anyObject;

    // 默认是去创建一个透明的视图
    UIGraphicsBeginImageContextWithOptions(_maskView.bounds.size, NO, 0);
    // 获取上下文(画板)
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 把imageView的layer映射到上下文中
    [_maskView.layer renderInContext:ref];

    if([event coalescedTouchesForTouch:touch]){
        NSArray *coalescedTouches = [NSArray arrayWithArray: [event coalescedTouchesForTouch:touch]];

        for (UITouch *coalescedTouch in coalescedTouches) {

            CGPoint locationInView = [coalescedTouch locationInView:self.maskView];
            locationInView = CGPointMake(locationInView.x, locationInView.y);

            // 设置清除点的大小
            CGRect  rect = CGRectMake(locationInView.x-RECTWH/2, locationInView.y-RECTWH/2, RECTWH, RECTWH);
//            CGContextAddEllipseInRect(ref, rect);
//            CGContextClip(ref);
            // 清除划过的区域
            CGContextClearRect(ref, rect);
            
            //清除前一个点到此时点之间的N个点
            CGPoint midPoint = [self getMidPointWithStartPoint:_previousPoint andEndPoint:locationInView];
            CGRect midRect = CGRectMake(midPoint.x-RECTWH/2, midPoint.y-RECTWH/2, RECTWH, RECTWH);
            CGContextClearRect(ref, midRect);
            
            _previousPoint = locationInView;
            
        }
    }

    // 获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图片的画板, (意味着图片在上下文中消失)
    UIGraphicsEndImageContext();

    _maskView.backgroundColor = [UIColor colorWithPatternImage:image];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

}

//算中间点
- (CGPoint)getMidPointWithStartPoint:(CGPoint )startPoint andEndPoint:(CGPoint )endPoint{
    
    CGPoint midPoint;
    midPoint.x = (startPoint.x + endPoint.x)/2.0;
    midPoint.y = (startPoint.y + endPoint.y)/2.0;
    
    return midPoint;
}




@end
