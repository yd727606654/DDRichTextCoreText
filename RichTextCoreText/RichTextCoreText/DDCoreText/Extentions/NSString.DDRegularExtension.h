//
//  NSString+DDRegularExtension.h
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DDRegularExtension)
- (NSString *)replaceCharactersInRanges:(NSArray *)ranges WithString:(NSString *)aString;
@end
