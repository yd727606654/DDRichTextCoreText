//
//  DDRegularExpression.h
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDRegularExpression : NSObject

+ (NSArray *)getRangesWithPattern:(NSString *)pattern inString:(NSString *)aString;
+ (NSArray<NSString *> *)getImageNamesWithPattern:(NSString *)pattern inString:(NSString *)aString;
+ (NSArray *)getImageRangesWitholdRanges:(NSArray *)ranges offsetRangesInArrayBy:(NSUInteger)offset;
+ (NSArray<NSDictionary *> *)matchWebLinkString:(NSString *)aString;
+ (NSArray *)matchMobileLink:(NSString *)aString;
@end
