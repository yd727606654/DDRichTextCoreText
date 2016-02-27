//
//  DDRegularExpression.m
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "DDRegularExpression.h"
#import "DDCoreTextLinkData.h"
#import "DDCoreTextPhoneNumber.h"
@implementation DDRegularExpression

+ (NSArray *)getRangesWithPattern:(NSString *)pattern inString:(NSString *)aString
{
    if (!pattern) return nil;
    if (!aString) return nil;
    NSError *error = nil;
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    NSArray *result = [regularExpression matchesInString:aString options:NSMatchingReportCompletion range:NSMakeRange(0, [aString length])];
    NSUInteger count = [result count];
    if (0 == count) {
        return nil;
    }
    NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < count; i++) {
        NSRange range = [[result objectAtIndex:i] range];
        [ranges addObject:[NSValue valueWithRange:range]];
    }
        return [ranges copy];
    
}

+ (NSArray<NSString *> *)getImageNamesWithPattern:(NSString *)pattern inString:(NSString *)aString
{
    if (!pattern) return nil;
    if (!aString) return nil;
    NSError *error = nil;
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:1];
    [regularExpression enumerateMatchesInString:aString options:0 range:NSMakeRange(0, aString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange groupRange =  [result rangeAtIndex:1];
        NSString *match = [aString substringWithRange:groupRange];
        [results addObject:match];
    }];
    return [results copy];
}

+ (NSArray *)getImageRangesWitholdRanges:(NSArray *)ranges offsetRangesInArrayBy:(NSUInteger)offset;
{
    NSUInteger aOffset = 0;
    NSUInteger prevLength = 0;
    
    
    NSMutableArray *tempRanges = [[NSMutableArray alloc] initWithCapacity:[ranges count]];
    for(NSInteger i = 0; i < [ranges count]; i++)
    {
        @autoreleasepool {
            NSRange range = [[ranges objectAtIndex:i] rangeValue];
            prevLength    = range.length;
            
            range.location -= aOffset;
            range.length    = offset;
            [tempRanges addObject:NSStringFromRange(range)];
            
            aOffset = aOffset + prevLength - offset;
        }
    }
    
    return [tempRanges copy];
}
+ (NSArray *)matchMobileLink:(NSString *)aString{
    
    NSMutableArray *linkArr = [NSMutableArray arrayWithCapacity:0];
    NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"(\\(86\\))?(13[0-9]|15[0-35-9]|18[0125-9])\\d{8}" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray* array=[regular matchesInString:aString options:0 range:NSMakeRange(0, [aString length])];
    
    for( NSTextCheckingResult * result in array){
        @autoreleasepool {
            DDCoreTextPhoneNumber *phoneNumber = [[DDCoreTextPhoneNumber alloc] init];
            phoneNumber.phoneNumber = [aString substringWithRange:result.range];
            phoneNumber.range = result.range;
//            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:string,NSStringFromRange(result.range), nil];
            [linkArr addObject:phoneNumber];
        }
    }
    
    return [linkArr copy];
}
+ (NSArray<DDCoreTextLinkData *> *)matchWebLinkString:(NSString *)aString
{
    if (!aString) {
        return nil;
    }
    NSMutableArray *links = [NSMutableArray arrayWithCapacity:1];
      NSRegularExpression*regular=[[NSRegularExpression alloc]initWithPattern:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)" options:NSRegularExpressionDotMatchesLineSeparators|NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results=[regular matchesInString:aString options:0 range:NSMakeRange(0, [aString length])];
    for( NSTextCheckingResult * result in results){
        @autoreleasepool {
            DDCoreTextLinkData *link = [[DDCoreTextLinkData alloc] init];
            link.url = [aString substringWithRange:result.range];
            link.range = result.range;
            [links addObject:link];
        }
        
    }
    return [links copy];
}
@end











