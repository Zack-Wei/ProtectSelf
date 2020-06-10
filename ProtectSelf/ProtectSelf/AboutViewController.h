//
//  AboutViewController.h
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/10.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^reloadView)(void);

@interface AboutViewController : UIViewController

@property (nonatomic, copy) reloadView reloadView;

@end
