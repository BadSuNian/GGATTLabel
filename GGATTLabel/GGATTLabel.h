//
//  GGATTLabel.h
//  GGATTLabel
//
//  Created by 高鹏 on 2017/8/16.
//  Copyright © 2017年 高鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGATTLabel : UILabel

- (void)setText:(NSString *)text stickerDic:(NSDictionary *)stickerDic stickerSize:(CGSize)stickerSize pattern:(NSString *)pattern;
@end