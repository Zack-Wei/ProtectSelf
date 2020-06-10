//
//  HomeViewController.h
//  ProtectSelf
//
//  Created by 魏大同 on 2018/3/18.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reloadView)(void);

@interface HomeViewController : UIViewController

@property (nonatomic, assign) BOOL isBoy;

@property (nonatomic, copy) reloadView reloadView;

@end
