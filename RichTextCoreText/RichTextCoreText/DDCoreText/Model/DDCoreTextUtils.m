//
//  DDCoreTextUtils.m
//  RichTextCoreText
//
//  Created by mac on 16/2/27.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "DDCoreTextUtils.h"

@implementation DDCoreTextUtils

// 检测点击位置是否在链接上
+ (DDCoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(DDCoreTextData *)data {
    CFIndex idx = [self touchContentOffsetInView:view atPoint:point data:data];
    
    if (idx == -1) {
        return nil;
    }
    DDCoreTextLinkData * foundLink = [self linkAtIndex:idx linkArray:data.linkArray];
    return foundLink;
}
+ (DDCoreTextPhoneNumber *)touchNumberInView:(UIView *)view atPoint:(CGPoint)point data:(DDCoreTextData *)data{
     CFIndex idx = [self touchContentOffsetInView:view atPoint:point data:data];
    if (idx == -1) {
        return nil;
    }
    DDCoreTextPhoneNumber * foundNumber = [self numberAtIndex:idx numberArray:data.phoneNumberArray];
    return foundNumber;
}
// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(DDCoreTextData *)data {
    
    CTFrameRef textFrame = data.ctFrame;
    // 获取多少行
    CFArrayRef lines = CTFrameGetLines(textFrame);
    // 如果无内容直接返回
    if (!lines) {
        return -1;
    }
    
    CFIndex count = CFArrayGetCount(lines);
    
    // 获得每一行的origin坐标
    
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line point:linePoint];
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, point)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x-CGRectGetMinX(rect),
                                                point.y-CGRectGetMinY(rect));
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
        }
    }
    return idx;
}

+ (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

+ (DDCoreTextLinkData *)linkAtIndex:(CFIndex)i linkArray:(NSArray *)linkArray {
    DDCoreTextLinkData *link = nil;
    for (DDCoreTextLinkData *data in linkArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}
+ (DDCoreTextPhoneNumber *)numberAtIndex:(CFIndex)i numberArray:(NSArray *)numberArray {
    DDCoreTextPhoneNumber *link = nil;
    for (DDCoreTextPhoneNumber *data in numberArray) {
        if (NSLocationInRange(i, data.range)) {
            link = data;
            break;
        }
    }
    return link;
}
@end
