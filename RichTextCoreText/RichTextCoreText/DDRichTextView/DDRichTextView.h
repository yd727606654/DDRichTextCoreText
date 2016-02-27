//
//  DDRichTextView.h
//  RichTextCoreText
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRichTextView : UIView
// 行间距
@property (nonatomic, assign) int lineSpacing;
@property (nonatomic, copy) NSString *oldString;
@end
