//
//  DDCTFrameParserConfig.m
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "DDCTFrameParserConfig.h"

@implementation DDCTFrameParserConfig

-(instancetype)init
{
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 14.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor darkGrayColor];
    }
    return self;
}
@end
