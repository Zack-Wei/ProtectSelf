//
//  PSImageCache.h
//  ProtectSelf
//
//  Created by 魏大同 on 2019/2/23.
//  Copyright © 2019 魏大同. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PSImageCache : NSCache

- (instancetype)init;

- (UIImage *)loadImgWithPath:(NSString *)imgPath;
- (void) cacheNextImgWithPath:(NSString *)imgPath;

@end

NS_ASSUME_NONNULL_END
