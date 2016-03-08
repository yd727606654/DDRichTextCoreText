//
//  DDCTFrameParserConfig.h
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface DDCTFrameParserConfig : NSObject
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat textSize;
@property (nonatomic, assign) CGFloat lineSpace;
// default is darkGrayColor
@property (nonatomic, strong) UIColor *textColor;
// default is blue
@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) UIColor *numberColor;

// 图片正则式
@property (nonatomic, copy) NSString *pattern;


@end
