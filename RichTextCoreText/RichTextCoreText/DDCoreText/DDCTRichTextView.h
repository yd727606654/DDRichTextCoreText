//
//  DDCTRichTextView.h
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCTFrameParserConfig.h"
#import "DDCoreTextData.h"
@interface DDCTRichTextView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic,assign) CGFloat fontSize;
@property (nonatomic, strong) UIColor *textColor;
//@property (nonatomic, strong) DDCTFrameParserConfig *textConfig;
//@property (nonatomic, strong) DDCTFrameParserConfig *imageConfig;
@property (nonatomic, strong)  DDCoreTextData *data;
// 图片正则式
@property (nonatomic, copy) NSString *pattern;
@property (nonatomic, readonly, assign) CGFloat height;

@end
