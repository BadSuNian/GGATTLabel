//
//  GGATTLabel.m
//  GGATTLabel
//
//  Created by 高鹏 on 2017/8/16.
//  Copyright © 2017年 高鹏. All rights reserved.
//

#import "GGATTLabel.h"

@implementation GGATTLabel

- (void)setText:(NSString *)text stickerDic:(NSDictionary *)stickerDic stickerSize:(CGSize)stickerSize pattern:(NSString *)pattern{
    
    NSArray *stickerValuesArray = [stickerDic allValues];
    NSArray *stickerKeyArray = [stickerDic allKeys];
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"GGATTLabel err ==  %@", [error localizedDescription]);
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSArray *stickerResultArray = [re matchesInString:attributedString.string options:0 range:NSMakeRange(0, attributedString.string.length)];
    NSMutableArray *stickerLoctionArray = [NSMutableArray arrayWithCapacity:stickerResultArray.count];
    for(NSTextCheckingResult *match in stickerResultArray) {
        NSRange range = [match range];
        NSString *subStr = [attributedString.string substringWithRange:range];
        for (int i = 0; i < stickerValuesArray.count; i ++)
        {
            if ([stickerValuesArray[i] isEqualToString:subStr])
            {
                NSTextAttachment *stickerAttachment = [[NSTextAttachment alloc] init];
                stickerAttachment.bounds = CGRectMake(stickerAttachment.bounds.origin.x, stickerAttachment.bounds.origin.y , stickerSize.width,stickerSize.height);
                stickerAttachment.image = [UIImage imageNamed:stickerKeyArray[i]];
                [stickerLoctionArray addObject:@{@"sticker":[NSAttributedString attributedStringWithAttachment:stickerAttachment],@"range":[NSValue valueWithRange:range]}];
            }
        }
    }
    for (NSInteger i = stickerLoctionArray.count - 1; i >= 0; i--)
    {
        NSRange range;
        [stickerLoctionArray[i][@"range"] getValue:&range];
        [attributedString replaceCharactersInRange:range withAttributedString:stickerLoctionArray[i][@"sticker"]];
    }
    self.attributedText = attributedString;
}

@end
