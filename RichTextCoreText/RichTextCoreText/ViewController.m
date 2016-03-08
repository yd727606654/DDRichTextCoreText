//
//  ViewController.m
//  RichTextCoreText
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "ViewController.h"
#import "DDCTRichTextView.h"
#import "DDCTFrameParser.h"
#define kContentString @"12qqwww.baidu.comwerwerw18220862691"
@interface ViewController ()<DDCTRichTextViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DDCTFrameParserConfig *config = [[DDCTFrameParserConfig alloc] init];
    DDCoreTextData *data = [DDCTFrameParser parserText:config text:kContentString];
    DDCTRichTextView *textV = [[DDCTRichTextView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    textV.data = data;
    textV.delegate = self;
   
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
