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

typedef NS_ENUM(NSInteger, DDTouchTextViewModel) {
    DDTouchImageModel,
    DDTouchLinkModel,
    DDTouchPhoneNumber
};

@protocol DDCTRichTextViewDelegate <NSObject>

@optional
- (void)DDTouchTextViewModel:(DDTouchTextViewModel)model text:(NSString *)text;

@end

@interface DDCTRichTextView : UIView

@property (nonatomic, weak) id <DDCTRichTextViewDelegate> delegate;

@property (nonatomic, copy) NSString *text;
// 图片正则式
@property (nonatomic, copy) NSString *pattern;
//optional
// default is 14
@property (nonatomic,assign) CGFloat fontSize;
// default is darkGrayColor
@property (nonatomic, strong) UIColor *textColor;
// default is blue
@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) UIColor *numberColor;
@property (nonatomic, strong)  DDCoreTextData *data;
@property (nonatomic, readonly, assign) CGFloat height;

@end
