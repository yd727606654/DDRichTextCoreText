//
//  DDCoreTextData.h
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"
@interface DDCoreTextData : NSObject
@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (strong, nonatomic) NSArray * imageArray;
@property (strong, nonatomic) NSArray * linkArray;
@property (strong, nonatomic) NSArray * phoneNumberArray;
@property (strong, nonatomic) NSAttributedString *content;
@property (copy, nonatomic) NSString *text;
@end
