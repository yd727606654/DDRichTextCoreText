//
//  DDCTFrameParser.h
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDCoreTextData;
@class DDCTRichTextView;
@interface DDCTFrameParser : NSObject

+ (DDCoreTextData *)parserText:(DDCTRichTextView *)richText;

@end
