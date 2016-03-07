//
//  NSString+DDRegularExtension.m
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "NSString+DDRegularExtension.h"

@implementation NSString (DDRegularExtension)
- (NSString *)replaceCharactersInRanges:(NSArray *)ranges WithString:(NSString *)aString
{
    if (!ranges) return self;
    if (!aString) aString = @"";
    NSMutableString *mutableString = [self mutableCopy];
    for (int i = (int)ranges.count - 1; i >= 0; i--) {
        NSRange range = [[ranges objectAtIndex:i] rangeValue];
        [mutableString replaceCharactersInRange:range withString:aString];
    }
    return [mutableString copy];
}
@end
