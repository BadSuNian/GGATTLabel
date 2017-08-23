//
//  GGATTLabel.m
//  GGATTLabel
//
//  Created by 高鹏 on 2017/8/16.
//  Copyright © 2017年 高鹏. All rights reserved.
//

#import "GGATTLabel.h"

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
{
    NSMutableAttributedString * GGText_;
}
- (GGATTLabel *)setText:(NSString *)text stickerDic:(NSDictionary *)stickerDic stickerSize:(CGSize)stickerSize pattern:(NSString *)pattern{
    
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
        for (int i = 0; i < stickerValuesArray.count; i ++){
            if ([stickerValuesArray[i] isEqualToString:subStr])
            {
                NSTextAttachment *stickerAttachment = [[NSTextAttachment alloc] init];
                stickerAttachment.bounds = CGRectMake(stickerAttachment.bounds.origin.x, stickerAttachment.bounds.origin.y , stickerSize.width,stickerSize.height);
                stickerAttachment.image = [UIImage imageNamed:stickerKeyArray[i]];
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
    self->GGText_ = attributedString;
    return self;
}
- (GGATTLabel *)stickerDic:(NSDictionary *)stickerDic stickerSize:(CGSize)stickerSize pattern:(NSString *)pattern
{

    NSArray *stickerValuesArray = [stickerDic allValues];
    NSArray *stickerKeyArray = [stickerDic allKeys];
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"GGATTLabel err ==  %@", [error localizedDescription]);
    }
    NSMutableAttributedString *attributedString = self->GGText_;
    NSArray *stickerResultArray = [re matchesInString:attributedString.string options:0 range:NSMakeRange(0, attributedString.string.length)];
    NSMutableArray *stickerLoctionArray = [NSMutableArray arrayWithCapacity:stickerResultArray.count];
    for(NSTextCheckingResult *match in stickerResultArray) {
        NSRange range = [match range];
        NSString *subStr = [attributedString.string substringWithRange:range];
        for (int i = 0; i < stickerValuesArray.count; i ++){
            if ([stickerValuesArray[i] isEqualToString:subStr])
            {
                NSTextAttachment *stickerAttachment = [[NSTextAttachment alloc] init];
                stickerAttachment.bounds = CGRectMake(stickerAttachment.bounds.origin.x, stickerAttachment.bounds.origin.y , stickerSize.width,stickerSize.height);
                stickerAttachment.image = [UIImage imageNamed:stickerKeyArray[i]];
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
    self->GGText_ = attributedString;
    return self;
}

- (GGATTLabel *)setText:(id)text{
    if ([text isKindOfClass:[NSString class]]) {
        NSMutableAttributedString * attributedText= [[NSMutableAttributedString alloc] initWithString:(NSString *)text];
        self->GGText_ = attributedText;
        self.attributedText = attributedText;
        return self;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareTextSystem];
    }
    return self;
}

- (GGATTLabel *)addAttributeWithBlock:(NSMutableAttributedString *(^)(NSMutableAttributedString *mutableAttributedString))block
{
    NSMutableAttributedString *mutableAttributedString = nil;

    if (block) {
      mutableAttributedString = block(self->GGText_);
    }
    self.attributedText = mutableAttributedString;
    
    return self;
}

- (GGATTLabel *)urlColor:(UIColor *)urlColor pattern:(NSString *)pattern tapBlock:(void (^)(NSString *, NSRange))block {
    
    if (!self->GGText_)
        return self;
    NSError *error = nil;
        NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
            if (!re)
                NSLog(@"GGATTLabel err ==  %@", [error localizedDescription]);
            NSMutableAttributedString *attributedString = self->GGText_;
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
