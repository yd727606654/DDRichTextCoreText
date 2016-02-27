//
//  ViewController.m
//  RichTextCoreText
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "ViewController.h"
#import "DDCTRichTextView.h"
#define kContentString @"12qqhttps://www.baidu.com我 18220862691ddddd 😀😀#[face/png/f_static_000.png]##[face/png/f_static_000.png]##[face/png/f_static_000.png]##[face/png/f_static_000.png]##[face/png/f_static_001.png]##[face/png/f_static_001.png]##[face/png/f_static_001.png]#😀😀😀18220862691"
@interface ViewController ()<DDCTRichTextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDCTRichTextView *textV = [[DDCTRichTextView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    textV.text = kContentString;
    textV.delegate = self;
    [self.view addSubview:textV];
}
-(void)DDTouchTextViewModel:(DDTouchTextViewModel)model text:(NSString *)text
{
    NSLog(@"%d === %@",model,text);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
