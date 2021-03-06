//
//  GGATTLabel.h
//  GGATTLabel
//
//  Created by 高鹏 on 2017/8/16.
//  Copyright © 2017年 高鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGATTLabel : UILabel

- (GGATTLabel *)setText:(id)text;
- (GGATTLabel *)addAttributeWithBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))block;
- (GGATTLabel *)stickerDic:(NSDictionary *)stickerDic stickerSize:(CGSize)stickerSize pattern:(NSString *)pattern;
- (GGATTLabel *)urlColor:(UIColor *)urlColor pattern:(NSString *)pattern tapBlock:(void (^)(NSString *selectStr, NSRange range))block;
@end
