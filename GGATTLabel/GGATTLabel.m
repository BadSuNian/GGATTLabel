//
//  GGATTLabel.m
//  GGATTLabel
//
//  Created by 高鹏 on 2017/8/16.
//  Copyright © 2017年 高鹏. All rights reserved.
//

#import "GGATTLabel.h"
#import "UIImage+GGImage.h"

@interface GGATTLabel ()

@property (nonatomic, strong) NSMutableArray * linkRanges;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, strong) NSDictionary *selectedDic;
@property (nonatomic, assign) BOOL  isSelected;
@property (nonatomic, strong) NSMutableArray * blockArray;
@end

@implementation GGATTLabel


- (GGATTLabel *)stickerDic:(NSDictionary *)stickerDic stickerSize:(CGSize)stickerSize pattern:(NSString *)pattern
{
    [self removeGif];
    NSArray *stickerValuesArray = [stickerDic allValues];
    NSArray *stickerKeyArray = [stickerDic allKeys];
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"GGATTLabel err ==  %@", [error localizedDescription]);
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSArray *stickerResultArray = [re matchesInString:attributedString.string options:0 range:NSMakeRange(0, attributedString.string.length)];
    NSMutableArray *stickerLoctionArray = [NSMutableArray arrayWithCapacity:stickerResultArray.count];
    NSMutableArray * gifArray = [[NSMutableArray alloc] init];
    for(NSTextCheckingResult *match in stickerResultArray) {
        NSRange range = [match range];
        NSString *subStr = [attributedString.string substringWithRange:range];
        for (int i = 0; i < stickerValuesArray.count; i ++){
            if ([stickerValuesArray[i] isEqualToString:subStr])
            {
                NSTextAttachment *stickerAttachment = [[NSTextAttachment alloc] init];
                stickerAttachment.bounds = CGRectMake(stickerAttachment.bounds.origin.x, stickerAttachment.bounds.origin.y , stickerSize.width,stickerSize.height);
                                if ([UIImage isGif:stickerKeyArray[i]]) {
                                    [stickerAttachment setImage:[UIImage imageNamed:@""]];
                                    [gifArray addObject:@{@"stickerName":stickerKeyArray[i],@"range":[NSValue valueWithRange:range],@"type":@"gif"}];
                                }
                                else
                                {
                                    [stickerAttachment setImage:[UIImage GGAnimatedGIFNamed:stickerKeyArray[i]]];
                                    [gifArray addObject:@{@"stickerName":stickerKeyArray[i],@"range":[NSValue valueWithRange:range],@"type":@"png"}];
                                }
                [stickerLoctionArray addObject:@{@"sticker":[NSAttributedString attributedStringWithAttachment:stickerAttachment],@"range":[NSValue valueWithRange:range]}];
            }
        }
    }
    for (NSInteger i = stickerLoctionArray.count - 1; i >= 0; i--){
        NSRange range;
        [stickerLoctionArray[i][@"range"] getValue:&range];
        [attributedString replaceCharactersInRange:range withAttributedString:stickerLoctionArray[i][@"sticker"]];
    }
    
    self.attributedText = attributedString;
    [self addTextStorageContainerManger];
    
    NSMutableArray * attRangeNotRequiredArray = [[NSMutableArray alloc] init];
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        if ([attrs[@"NSAttachment"] isKindOfClass:[NSTextAttachment class]]) {
            [attRangeNotRequiredArray addObject:@{@"attrs":attrs,@"range":[NSValue valueWithRange:range]}];
        }
    }];
    
    for(NSInteger j = attRangeNotRequiredArray.count -1 ; j >= 0 ; j--){
        if ([gifArray[j][@"type"] isEqualToString:@"gif"]) {
            NSString * stickerName = gifArray[j][@"stickerName"];
            NSRange range;
            [attRangeNotRequiredArray[j][@"range"] getValue:&range];
            CGRect stickerRect = [self.layoutManager boundingRectForGlyphRange:range inTextContainer:self.textContainer];
            UIImageView * gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(stickerRect.origin.x ,stickerRect.origin.y, stickerSize.width, stickerSize.height)];

            @autoreleasepool {
                [gifImageView setImage:[UIImage GGAnimatedGIFNamed:stickerName]];
            }
            [self addSubview:gifImageView];

        }
    }
    return self;
}

- (GGATTLabel *)setText:(id)text{
    [self.blockArray removeAllObjects];
    if ([text isKindOfClass:[NSString class]]) {
        NSMutableAttributedString * attributedText= [[NSMutableAttributedString alloc] initWithString:(NSString *)text];
        self.attributedText = attributedText;
        [self addTextStorageContainerManger];

        return self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareTextSystem];
        self.textContainer.size = self.frame.size;
    }
    return self;
}

- (GGATTLabel *)addAttributeWithBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))block
{
    NSMutableAttributedString *mutableAttributedString = nil;

    if (block) {
      mutableAttributedString = block([[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText]);
    }
    self.attributedText = mutableAttributedString;

    return self;
}

- (GGATTLabel *)urlColor:(UIColor *)urlColor pattern:(NSString *)pattern tapBlock:(void (^)(NSString *, NSRange))block {
    
    if (!self.attributedText)
        return self;
    NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
            if (!re)
                NSLog(@"GGATTLabel err ==  %@", [error localizedDescription]);
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText] ;
            NSArray *stickerResultArray = [re matchesInString:attributedString.string options:0 range:NSMakeRange(0, attributedString.string.length)];
        for (NSTextCheckingResult *match in stickerResultArray) {
            [self addAttributeWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                [mutableAttributedString addAttribute:NSForegroundColorAttributeName
                                                value:urlColor
                                                range:match.range];
                return mutableAttributedString;
            }];
        }
    [self urlPattern:pattern];
    
    
    
    if (block) {
       void (^tapBlock)(NSString * str, NSRange range) = ^(NSString * str, NSRange range){
            block(str,range);
        };
        [self.blockArray addObject:@{pattern:tapBlock}];
    }
    return self;
}
#pragma mark --- 手势
#pragma mark - 点击交互
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isSelected = YES;
    
    CGPoint selectPoint = [[touches anyObject] locationInView:self];
    self.selectedDic = [self getSelectRange:selectPoint];
    if (!_selectedDic) {
        [super touchesBegan:touches withEvent:event];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!_selectedDic) {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    _isSelected = NO;
    [self setNeedsDisplay];
    NSValue * value = self.selectedDic.allValues[0] ;
    NSString *contentText = [self.textStorage.string substringWithRange:value.rangeValue];
    void (^tapBlock)(NSString * str, NSRange range);
    for (NSDictionary * dic in self.blockArray) {
        if ([[dic allKeys][0] isEqualToString:[self.selectedDic allKeys][0]]) {
            tapBlock = [dic allValues][0];
        }
    }
    tapBlock(contentText,value.rangeValue);
}

-(NSDictionary *)getSelectRange:(CGPoint)selectPoint{
    if (self.textStorage.length == 0) {
        return nil;
    }
    NSInteger index = [self.layoutManager glyphIndexForPoint:selectPoint inTextContainer:self.textContainer];
    for (NSDictionary * dic  in self.linkRanges) {
        NSValue *rangeValue = dic.allValues[0];
        NSRange range = rangeValue.rangeValue;
        if (index >= range.location && index <range.location + range.length) {
            [self setNeedsDisplay];
            return dic;
        }
    }
    return nil;
}


#pragma mark 点击网址相关的东西

- (void)layoutSubviews{
    self.textContainer.size = self.frame.size;
}
- (void)drawTextInRect:(CGRect)rect{
    
    if (_selectedDic) {
        UIColor *selectColor = _isSelected ? [UIColor colorWithWhite:0.6 alpha:0.2] : [UIColor clearColor];
        NSValue * value = self.selectedDic.allValues[0] ;
        [self.textStorage addAttribute:NSBackgroundColorAttributeName value:selectColor range:value.rangeValue];
        [self.layoutManager drawBackgroundForGlyphRange:value.rangeValue atPoint:CGPointMake(0, 0)];
    }
    NSRange range = NSMakeRange(0, self.textStorage.length);
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:CGPointZero];
}


- (void)prepareTextSystem {
    
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    self.userInteractionEnabled = YES;
    self.textContainer.lineFragmentPadding = 0;
}


- (void)urlPattern:(NSString *)pattern {
    
    NSAttributedString *attrString;
    if (self.attributedText)
        attrString = self.attributedText;
    else if (self.text)
        attrString = [[NSAttributedString alloc]initWithString:self.text];
    else
        attrString = [[NSAttributedString alloc]initWithString:@""];
    self.selectedDic = nil;
    NSMutableAttributedString *attrMString = [self getNewAttString:attrString];
    [self.textStorage setAttributedString:attrMString];
    
    [self.linkRanges addObjectsFromArray:[self getRanges:pattern]];
    [self setNeedsDisplay];
}

- (void)addTextStorageContainerManger {
    
    NSAttributedString *attrString;
    if (self.attributedText)
        attrString = self.attributedText;
    else if (self.text)
        attrString = [[NSAttributedString alloc]initWithString:self.text];
    else
        attrString = [[NSAttributedString alloc]initWithString:@""];
    self.selectedDic = nil;
    NSMutableAttributedString *attrMString = [self getNewAttString:attrString];
    [self.textStorage setAttributedString:attrMString];
    [self setNeedsDisplay];
}



- (NSMutableArray<NSValue *> *)getRanges:(NSString*)pattern{
    
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:self.textStorage.string options:NSMatchingReportCompletion range:NSMakeRange(0, self.textStorage.string.length)];
    NSMutableArray *ranges = [NSMutableArray array];
    for (NSTextCheckingResult *result in results) {
        NSValue *value = [NSValue valueWithRange:result.range];
        [ranges addObject:@{pattern:value}];
    }
    return ranges;
}


- (NSMutableAttributedString*)getNewAttString:(NSAttributedString *) attrString{
    NSMutableAttributedString *newAttString = [[NSMutableAttributedString alloc]initWithAttributedString:attrString];
    if (newAttString.length == 0)
        return newAttString;
    NSRange range = NSMakeRange(0, 0);
    NSMutableDictionary *dict = (NSMutableDictionary*)[newAttString attributesAtIndex:0 effectiveRange:&range];
    NSMutableParagraphStyle *paragraphStyle = [dict[NSParagraphStyleAttributeName] mutableCopy] ;
    if (paragraphStyle)
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    else {
        paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    }
    [newAttString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return newAttString;
}

- (void)removeGif{
    
    for(int i = 0;i < [self.subviews count];i++){
        [[self.subviews objectAtIndex:i] removeFromSuperview];
    }

}

#pragma mark - 懒加载
- (NSTextStorage*)textStorage{
    if (!_textStorage) {
        _textStorage = [[NSTextStorage alloc]init];
    }
    return _textStorage;
}

- (NSLayoutManager*)layoutManager{
    if (!_layoutManager) {
        _layoutManager = [[NSLayoutManager alloc]init];
    }
    return _layoutManager;
}
- (NSTextContainer*)textContainer{
    if (!_textContainer) {
        _textContainer = [[NSTextContainer alloc]init];
    }
    return _textContainer;
}

- (NSMutableArray * )linkRanges{
    if (!_linkRanges) {
        _linkRanges = [[NSMutableArray alloc] init];
    }
    return _linkRanges;
}

- (NSMutableArray * )blockArray{
    if (!_blockArray) {
        _blockArray = [[NSMutableArray alloc] init];
    }
    return _blockArray;
}

@end
