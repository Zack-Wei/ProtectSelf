//
//  PSImageCache.m
//  ProtectSelf
//
//  Created by 魏大同 on 2019/2/23.
//  Copyright © 2019 魏大同. All rights reserved.
//

#import "PSImageCache.h"

@implementation PSImageCache

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.countLimit = 3;
        
    }
    return self;
}

- (UIImage *)loadImgWithPath:(NSString *)imgPath{
    
    UIImage *img = [self objectForKey:imgPath];
    
    //如果已经缓存，那么立马返回
    if (img) {
        return [img isKindOfClass:[NSNull class]]?nil:img;
    }
    
    //防止多次缓存，先制空
    [self setObject:[NSNull null] forKey:imgPath];
    
    //异步将图片加入缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //加载图片
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgPath ofType:nil]];
        [self setObject:img forKey:imgPath];
        
    });
    
    return nil;
}

- (void) cacheNextImgWithPath:(NSString *)imgPath{
    
    UIImage *img = [self objectForKey:imgPath];
    
    //如果已经缓存，那么推出
    if (img) {
        return;
    }
    
    //防止多次缓存，先制空
    [self setObject:[NSNull null] forKey:imgPath];
    
    //异步将图片加入缓存
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //将图片存入缓存
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imgPath ofType:nil]];
        [self setObject:img forKey:imgPath];
        
    });
    
}
@end
