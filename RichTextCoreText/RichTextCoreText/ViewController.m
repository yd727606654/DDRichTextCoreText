//
//  ViewController.m
//  RichTextCoreText
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "ViewController.h"
#import "DDRichTextView.h"
#import "DDCTRichTextView.h"
#import "DDCTFrameParser.h"
#define kContentString @"12qqhttps://www.baidu.com我 18220862691ddddd 😀😀#[face/png/f_static_000.png]##[face/png/f_static_000.png]##[face/png/f_static_000.png]##[face/png/f_static_000.png]##[face/png/f_static_001.png]##[face/png/f_static_001.png]##[face/png/f_static_001.png]#😀😀😀18220862691"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDCTRichTextView *textV = [[DDCTRichTextView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    textV.text = kContentString;
    [self.view addSubview:textV];
    
//    NSString *s = @"😀😀1";
//  NSUInteger len =  [s length];
//    DDRichTextView *view = [[DDRichTextView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
//    view.oldString = kContentString;
//    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
