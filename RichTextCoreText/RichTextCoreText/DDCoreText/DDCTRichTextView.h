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

typedef NS_OPTIONS(NSUInteger, DDCTRichTextViewAbleClickModel){
    DDCTRichTextViewImageAble = 1 << 0,
    DDCTRichTextViewLinkAble = 1 << 1,
    DDCTRichTextViewPhoneNumAble = 1 << 2
};

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
// default is all
@property (nonatomic, assign) DDCTRichTextViewAbleClickModel clickModel;

@property (nonatomic, strong)  DDCoreTextData *data;

@property (nonatomic, readonly, assign) CGSize size;
@property (nonatomic, copy, readonly) NSString *text;

@end
