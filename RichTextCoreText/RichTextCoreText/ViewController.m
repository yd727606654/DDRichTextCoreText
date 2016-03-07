//
//  ViewController.m
//  RichTextCoreText
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "ViewController.h"
#import "DDCTRichTextView.h"
#define kContentString @"12qq"
@interface ViewController ()<DDCTRichTextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDCTRichTextView *textV = [[DDCTRichTextView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    textV.text = kContentString;
    textV.delegate = self;
    textV.clickModel = DDCTRichTextViewLinkAble ;
    [self.view addSubview:textV];
}
-(void)DDTouchTextViewModel:(DDTouchTextViewModel)model text:(NSString *)text
{
    NSLog(@"%ld === %@",(long)model,text);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
