//
//  DDCTRichTextView.m
//  RichTextCoreText
//
//  Created by mac on 16/2/25.
//  Copyright © 2016年 dongdong. All rights reserved.
//

#import "DDCTRichTextView.h"

#import "DDCoreTextImageData.h"
#import "DDCTFrameParser.h"
#import "DDCoreTextLinkData.h"
#import "DDCoreTextUtils.h"
#import "DDCoreTextPhoneNumber.h"

typedef NS_ENUM(NSUInteger, DDCTRichTextViewState) {
    DDCTRichTextViewNormal,
    DDCTRichTextViewSelecting
};


@interface DDCTRichTextView()

@property (nonatomic, assign) DDCTRichTextViewState state;

@end

NSString *const patternString = @"#\\[face/png/f_static_(\\d+).png\\]#";

@implementation DDCTRichTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clickModel = DDCTRichTextViewImageAble | DDCTRichTextViewLinkAble | DDCTRichTextViewPhoneNumAble;
        [self parseGestureRecognizer];
    }
    return self;
}

- (void)parseGestureRecognizer
{
    // 点击事件，点击链接，图片处理
    UIGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
    // 文本处理手势
    UIGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userLongPressedGuestureDetected:)];
    [self addGestureRecognizer:longPressRecognizer];
    
    self.userInteractionEnabled = YES;

}

- (void)userLongPressedGuestureDetected:(UILongPressGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self longClickDDCoreTextView];
    }
}
- (void)longClickDDCoreTextView{
    self.state = DDCTRichTextViewSelecting;
    UIView *myselfSelected = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    myselfSelected.tag = 199102;
    [self insertSubview:myselfSelected belowSubview:self];
    myselfSelected.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        //!!!:添加复制功能
        [self becomeFirstResponder];
        UIMenuController *menuVC = [UIMenuController sharedMenuController];
        [menuVC setTargetRect:self.frame inView:self.superview];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(customCopy:)];
        menuVC.menuItems =  @[item1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerHider) name:UIMenuControllerDidHideMenuNotification object:nil];
        [menuVC setMenuVisible:YES animated:YES];

}
- (void)customCopy:(id)sender
{
    NSString *contentString = _text;
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = contentString;
    
}
- (void)menuControllerHider
{
    self.state = DDCTRichTextViewNormal;
    [self removeLongClickArea];
}
- (void)removeLongClickArea{
    
    if ([self viewWithTag:199102]) {
        [[self viewWithTag:199102] removeFromSuperview];
    }
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer
{
    if (self.state == DDCTRichTextViewSelecting) {
        self.state = DDCTRichTextViewNormal;
        [self removeLongClickArea];
         UIMenuController *menuVC = [UIMenuController sharedMenuController];
        if (menuVC.menuVisible) {
            [menuVC setMenuVisible:NO animated:YES];
        }
        return;
    }
    
    CGPoint point = [recognizer locationInView:self];
    if ((self.clickModel & 1) == DDCTRichTextViewImageAble) {
        // 检测是否图片
        for (DDCoreTextImageData * imageData in self.data.imageArray) {
            // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
            CGRect imageRect = imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
            // 检测点击位置 Point 是否在rect之内
            if (CGRectContainsPoint(rect, point)) {
                NSLog(@"hint image imageName = %@, imageposition = %d", imageData.name, imageData.position);
                if ([self.delegate respondsToSelector:@selector(DDTouchTextViewModel:text:)]) {
                    [self.delegate DDTouchTextViewModel:DDTouchImageModel text:imageData.name];
                }
                return;
            }
        }
    }
    if ((self.clickModel & 1<<1) == DDCTRichTextViewLinkAble) {
        // 检测是否链接
        DDCoreTextLinkData *linkData = [DDCoreTextUtils touchLinkInView:self atPoint:point data:self.data];
        if (linkData) {
            NSLog(@"%@ === hint link!",linkData.url);
            if ([self.delegate respondsToSelector:@selector(DDTouchTextViewModel:text:)]) {
                [self.delegate DDTouchTextViewModel:DDTouchLinkModel text:linkData.url];
            }
            return;
        }

    }
        if ((self.clickModel & 1<<2) == DDCTRichTextViewPhoneNumAble) {
            // 检测是否电话
            DDCoreTextPhoneNumber *numberData = [DDCoreTextUtils touchNumberInView:self atPoint:point data:self.data];
            if (numberData) {
                NSLog(@"%@ === hint number!",numberData.phoneNumber);
                if ([self.delegate respondsToSelector:@selector(DDTouchTextViewModel:text:)]) {
                    [self.delegate DDTouchTextViewModel:DDTouchPhoneNumber text:numberData.phoneNumber];
                }
                return;
            }
        }
    
}

-(void)setText:(NSString *)text
{
    _text = text;
    if (!_pattern) {
        _pattern = patternString;
    }
 
    _data = [DDCTFrameParser parserText:self];
    CGRect frame = self.frame;
    frame.size.height = _data.height;
    self.frame = frame;
    
}

-(CGFloat)height
{
   return _data.height;
 
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.data == nil) {
        return;
    }
    
    // CGContextRef CG CoreGraphics Ref 引用
    // 目前的上下文都跟UIGraphics有关，以后想直接获取上下文，直接敲一个UIGraphics
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    //用来为每一个显示的字形单独设置变形矩阵
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    //CGContextTranslateCTM的作用变换坐标系中的原点
    // 该方法相当于把原来位于 (0, 0) 位置的坐标原点平移到 (tx, ty) 点。在平移后的坐标系统上绘制图形时，所有坐标点的 X 坐标都相当于增加了 tx，所有点的 Y 坐标都相当于增加了 ty
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    // CGContextScaleCTM 改变用户坐标系统的规模比例
    // 该方法控制坐标系统水平方向上缩放 sx，垂直方向上缩放 sy。在缩放后的坐标系统上绘制图形时，所有点的 X 坐标都相当于乘以 sx 因子，所有点的 Y 坐标都相当于乘以 sy 因子。
    CGContextScaleCTM(context, 1.0, -1.0);

    CTFrameDraw(self.data.ctFrame, context);
    
    for (DDCoreTextImageData * imageData in self.data.imageArray) {
        UIImage *image = [UIImage imageNamed:imageData.name];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }

}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
