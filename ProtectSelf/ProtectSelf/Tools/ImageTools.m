//
//  ImageTools.m
//  ProtectSelf
//
//  Created by 魏大同 on 2018/4/10.
//  Copyright © 2018年 魏大同. All rights reserved.
//

#import "ImageTools.h"


@implementation ImageTools


+ (NSData *)getImageDataWithImage:(UIImage *)image{

    
    CGFloat viewW = [[UIScreen mainScreen]bounds].size.width  * 1.5;
    CGFloat viewH = [[UIScreen mainScreen]bounds].size.height * 1.5;
    
    //实现等比例缩放
    double hfactor = image.size.width / viewW;
    double vfactor = image.size.height / viewH;
    //double factor = fmax(hfactor, vfactor);

    //画布大小
    CGFloat newWith = image.size.width / hfactor;
    CGFloat newHeigth = image.size.height / vfactor;
    CGSize newSize = CGSizeMake(newWith, newHeigth);

    UIGraphicsBeginImageContext(newSize);
    CGRect rect = CGRectMake(0, 0, newWith, newHeigth);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //图像压缩
    NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.5);
    
    return newImageData;
    
}

@end
