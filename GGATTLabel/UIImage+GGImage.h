//
//  UIImage+GGImage.h
//  GGATTLabel
//
//  Created by 高鹏 on 2017/8/24.
//  Copyright © 2017年 高鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GGImage)

+ (UIImage *)GGAnimatedGIFNamed:(NSString *)name;

+ (BOOL)isGif:(NSString *)name;
@end
