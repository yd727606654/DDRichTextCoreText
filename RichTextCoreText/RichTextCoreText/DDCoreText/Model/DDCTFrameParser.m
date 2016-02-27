//
//  DDCTFrameParser.m
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "DDCTFrameParser.h"
#import "DDCTFrameParserConfig.h"
#import "DDRegularExpression.h"
#import "NSString+DDRegularExtension.h"
#import "DDCTRichTextView.h"
#import "DDCoreTextData.h"
#import "DDCoreTextImageData.h"
#import "CoreText/CoreText.h"
#import "DDCoreTextLinkData.h"
#import "DDCoreTextPhoneNumber.h"
@implementation DDCTFrameParser

+ (DDCoreTextData *)parserText:(DDCTRichTextView *)richText
{
   DDCTFrameParserConfig *config = [[DDCTFrameParserConfig alloc] init];
    NSString *patter = richText.pattern;
    NSString *text = richText.text;
   NSString *objectReplacementChar = @" ";
    NSArray *imageRanges = [DDRegularExpression getRangesWithPattern:patter inString:text];
    NSString *parsedText = [text replaceCharactersInRanges:imageRanges WithString:objectReplacementChar];
    // text
    NSMutableAttributedString *attributedString = [self parseAttributedWithContent:parsedText config:config];
    // image
    NSArray *imageNames = [DDRegularExpression getImageNamesWithPattern:patter inString:text];
    NSArray * newRanges = [DDRegularExpression getImageRangesWitholdRanges:imageRanges offsetRangesInArrayBy:[objectReplacementChar length]];
    NSMutableArray *imageDatas = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < imageNames.count; i++) {
       
            DDCoreTextImageData *imageData = [[DDCoreTextImageData alloc] init];
            imageData.name =[NSString stringWithFormat:@"f_static_%@.png",[imageNames objectAtIndex:i]] ;
            NSRange range = NSRangeFromString(newRanges[i]);
            imageData.position = (int)range.location;
            [imageDatas addObject:imageData];
           NSAttributedString *imageStr = [self parseImageDataFromconfig:config];
            [attributedString replaceCharactersInRange:range withAttributedString:imageStr];
        
    }
    // link
    DDCTFrameParserConfig *linkConfig = [[DDCTFrameParserConfig alloc] init];
    linkConfig.textColor = [UIColor blueColor];
   NSArray *links = [DDRegularExpression matchWebLinkString:parsedText];
    for (DDCoreTextLinkData *link in links) {
        NSString *linkString = [parsedText substringWithRange:link.range];
      NSAttributedString *linkAttributedString =  [self parseAttributedWithContent:linkString config:linkConfig];
        [attributedString replaceCharactersInRange:link.range withAttributedString:linkAttributedString];
    }
    
    NSArray *phoneNums = [DDRegularExpression matchMobileLink:parsedText];
    DDCTFrameParserConfig *phoneNumberConfig = [[DDCTFrameParserConfig alloc] init];
    phoneNumberConfig.textColor = [UIColor greenColor];
    for (DDCoreTextPhoneNumber *phoneNum in phoneNums) {
        NSString *phoneNumberString = [parsedText substringWithRange:phoneNum.range];
        NSAttributedString *phoneNumberAttributedString =  [self parseAttributedWithContent:phoneNumberString config:phoneNumberConfig];
        [attributedString replaceCharactersInRange:phoneNum.range withAttributedString:phoneNumberAttributedString];
    }
    
    
    DDCoreTextData *data = [self parseAttributedContent:attributedString config:config];
    data.imageArray = imageDatas;
    data.linkArray = links;
    data.phoneNumberArray = phoneNums;
//    NSAttributedString *str = [self getAttributedStringWithRanges:newRanges paresedText:_parsedText];
//    typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
//                                                        (str));
    return data;
}

#pragma mark - 属性解析
+ (NSMutableDictionary *)attributesWithConfig:(DDCTFrameParserConfig *)config
{
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSettings = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing }
    };
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    
    UIColor * textColor = config.textColor;
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    
    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}
#pragma mark - DDCoreTextData处理
+ (DDCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(DDCTFrameParserConfig*)config {
    // 创建 CTFramesetterRef 实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    // 生成 CTFrameRef 实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    // 将生成好的 CTFrameRef 实例和计算好的缓制高度保存到 CoreTextData 实例中，最后返回 CoreTextData 实例
    DDCoreTextData *data = [[DDCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.content = content;
    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}
+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(DDCTFrameParserConfig *)config
                                  height:(CGFloat)height {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}



#pragma mark - 文字处理
+ (NSMutableAttributedString *)parseAttributedWithContent:(NSString *)content
                                                        config:(DDCTFrameParserConfig*)config {
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    return [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
}


#pragma mark - 图片处理
+ (NSAttributedString *)parseImageDataFromconfig:(DDCTFrameParserConfig*)config {
    // CTRunDelegateCallbacks才是真正定义字形宽度、向上高度和向下高度的结构体
//    NSDictionary *dict = @{@"imageWidth":[NSNumber numberWithFloat:config.fontSize]};
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:config.fontSize],@"imageWidth", nil];
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    // 其实只是告诉Core Text 有一个地方需要占多大的位置，这样系统就会在指定的地方把空间腾出来，不绘制文字上去
    CFRelease(delegate);
    return space;
}

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"imageWidth"] floatValue] + 3;
    
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"imageWidth"] floatValue] + 3;
}






@end
