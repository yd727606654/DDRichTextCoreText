//
//  DDCoreTextImageData.h
//  RichTextCoreText
//
//  Created by mac on 16/2/26.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DDCoreTextImageData : NSObject
@property (strong, nonatomic) NSString * name;
// 位置（第几个字符站位）
@property (nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;
@end
