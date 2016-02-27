//
//  DDCoreTextUtils.h
//  RichTextCoreText
//
//  Created by mac on 16/2/27.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDCoreTextLinkData.h"
#import "DDCoreTextData.h"
#import <UIKit/UIKit.h>
@interface DDCoreTextUtils : NSObject
/**
 *  检测点击位置是否在链接上，如果是返回CoreTextLinkData，不是返回nil
 *
 *  @param view  视图
 *  @param point 点击位置
 *  @param data  CoreTextData
 *
 *  @return CoreTextLinkData
 */
+ (DDCoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(DDCoreTextData *)data;
// 将点击的位置转换成字符串的偏移量，如果没有找到，则返回-1
+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(DDCoreTextData *)data;
@end
