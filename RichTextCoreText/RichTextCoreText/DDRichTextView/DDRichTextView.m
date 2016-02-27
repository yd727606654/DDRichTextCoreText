//
//  DDRichTextView.m
//  RichTextCoreText
//
//  Created by mac on 16/2/23.
//  Copyright © 2016年 dongdong. All rights reserved.
//
#import "ILRegularExpressionManager.h"
#import "DDRichTextView.h"
#import "NSString+NSString_ILExtension.h"
#import "NSArray+NSArray_ILExtension.h"
#import "coreText/coreText.h"
#define FontHeight                  14.0
#define ImageLeftPadding            0.0
#define ImageTopPadding             0.0
#define FontSize                    FontHeight
//#define LineSpacing                 8.0
#define EmotionImageWidth           FontSize
#define EmotionItemPattern @"#\\[face/png/f_static_(\\d+).png\\]#"
#define PlaceHolder @" "
#define AttributedImageNameKey      @"ImageName"
#define limitline 3
@interface DDRichTextView ()

{
    CTTypesetterRef typesetter;
}
//@property (nonatomic, strong) NSMutableArray *selectionViews;
//@property (nonatomic, assign) BOOL isFold;
//@property (nonatomic, assign) BOOL canClickAll;
@property (nonatomic,strong) UIColor *defaultColor;
@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic, copy) NSString *myNewString;
// 表情数组
@property (nonatomic,strong) NSArray *emotionNames;
// 根据调整后的字符串，生成绘图时使用的 attribute string
@property (nonatomic,strong) NSAttributedString *attrEmotionString;
@property (nonatomic,assign) CFIndex limitCharIndex;//限制行的最后一个char的index
@end

@implementation DDRichTextView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.lineSpacing = 8;
        self.defaultColor = [UIColor blackColor];
        self.backgroundColor = [UIColor lightGrayColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMySelf:)];
        [self addGestureRecognizer:tap];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMySelf:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    if (!typesetter)   return;
    
    CGFloat w = CGRectGetWidth(self.frame);
    // 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    // 翻转坐标系
    Flip_Context(context, FontHeight);
    
    CGFloat y = 0;
    CFIndex start = 0;
    NSInteger length = [_attrEmotionString length];
    int tempK = 0;
    while (start < length)
    {
        CFIndex count = CTTypesetterSuggestClusterBreak(typesetter, start, w);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
        CGContextSetTextPosition(context, 0, y);
        
        // 画字
        CTLineDraw(line, context);
        
        // 画表情
        Draw_Emoji_For_Line(context, line, self, CGPointMake(0, y));
        
        start += count;
        y -= FontSize + self.lineSpacing;
        CFRelease(line);
        
        tempK ++;
        if (tempK == limitline) {
            
            _limitCharIndex = start;
            //  NSLog(@"limitCharIndex = %ld",self.limitCharIndex);
        }
        
    }
    
    UIGraphicsPopContext();
    
    
    
}
// 绘制每行中的表情
void Draw_Emoji_For_Line(CGContextRef context, CTLineRef line, id owner, CGPoint lineOrigin)
{
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    // 统计有多少个run
    NSUInteger count = CFArrayGetCount(runs);
    
    // 遍历查找表情run
    for(NSInteger i = 0; i < count; i++){
        
        CTRunRef aRun = CFArrayGetValueAtIndex(runs, i);
        CFDictionaryRef attributes = CTRunGetAttributes(aRun);
        NSString *emojiName = (NSString *)CFDictionaryGetValue(attributes, AttributedImageNameKey);
        if (emojiName){
            // 画表情
            CGRect imageRect = CGRectZero;
            imageRect.origin = Emoji_Origin_For_Line(line, lineOrigin, aRun);
            imageRect.size = CGSizeMake(EmotionImageWidth+5, EmotionImageWidth+5);
            CGImageRef img = [[owner getEmotionForKey:emojiName] CGImage];
            CGContextDrawImage(context, imageRect, img);
        }
    }
}
// 通过表情名获得表情的图片
- (UIImage *)getEmotionForKey:(NSString *)key{
    
    NSString *nameStr = [NSString stringWithFormat:@"f_static_%@",key];
    return [UIImage imageNamed:nameStr];
}
// 生成每个表情的 frame 坐标
static inline
CGPoint Emoji_Origin_For_Line(CTLineRef line, CGPoint lineOrigin, CTRunRef run)
{
    CGFloat x = lineOrigin.x + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL) + ImageLeftPadding;
    CGFloat y = lineOrigin.y - ImageTopPadding-5;
    return CGPointMake(x, y);
}
// 翻转坐标系
static inline
void Flip_Context(CGContextRef context, CGFloat offset) // offset为字体的高度
{
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -offset);
}

#pragma mark - 内容处理
- (void)setOldString:(NSString *)oldString
{
    _oldString = oldString;
    // 获取所有图片位置
   
    [self cookEmotionString];
}

- (void)cookEmotionString
{
//    NSArray *itemIndexs = [ILRegularExpressionManager itemIndexesWithPattern:EmotionItemPattern inString:_oldString];
    // 使用正则表达式查找特殊字符的位置
    NSArray *itemIndexes = [ILRegularExpressionManager itemIndexesWithPattern:
                            EmotionItemPattern inString:_oldString];
    //用PlaceHolder 替换掉图片信息
    _myNewString = [_oldString replaceCharactersAtIndexes:itemIndexes
                                              withString:PlaceHolder];
    
    NSArray *names = nil;
    
    NSArray *newRanges = nil;
    // 获取所有图片名字
    names = [_oldString itemsForPattern:EmotionItemPattern captureGroupIndex:1];
    // 新的图片占位符所在的位置
    newRanges = [itemIndexes offsetRangesInArrayBy:[PlaceHolder length]];
    _emotionNames = names;
    _attrEmotionString = [self createAttributedEmotionStringWithRanges:newRanges
                                                             forString:_myNewString];
    typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)
                                                        (_attrEmotionString));
}
/**
 *  根据调整后的字符串，生成绘图时使用的 attribute string
 *
 *  @param ranges  占位符的位置数组
 *  @param aString 替换过含有如[em:02:]的字符串
 *
 *  @return 富文本String
 */
- (NSAttributedString *)createAttributedEmotionStringWithRanges:(NSArray *)ranges
                                                      forString:(NSString*)aString{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:aString];
    // 为所有文字添加文字属性
  CTFontRef helvetica = CTFontCreateWithName(CFSTR("Helvetica"),FontSize, NULL);
    [attrString addAttribute:(id)kCTFontAttributeName value: (id)CFBridgingRelease(helvetica) range:NSMakeRange(0,[attrString.string length])];
    
    if( _defaultColor == nil )
    {
        _defaultColor = [UIColor blackColor];
    }
    
    [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(_defaultColor.CGColor) range:NSMakeRange(0,[attrString length])];
    
    if (_textColor == nil) {
        _textColor = [UIColor blueColor];
    }
    
//    for (int i = 0; i < _attributedData.count; i ++) {
//        
//        NSString *str = [[[_attributedData objectAtIndex:i] allKeys] objectAtIndex:0];
//        
//        [attrString addAttribute:(id)kCTForegroundColorAttributeName value:(id)(_textColor.CGColor) range:NSRangeFromString(str)];
//        
//    }
    // 为每个表情添加属性
    for(NSInteger i = 0; i < [ranges count]; i++){
        
        NSRange range = NSRangeFromString([ranges objectAtIndex:i]);
        NSString *emotionName = [self.emotionNames objectAtIndex:i];
        [attrString addAttribute:AttributedImageNameKey value:emotionName range:range];
        [attrString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)newEmotionRunDelegate() range:range];
    }
    
    return attrString;
}
CTRunDelegateRef newEmotionRunDelegate(){
    
    static NSString *emotionRunName = @"emotionRunName";
    
    CTRunDelegateCallbacks imageCallbacks;
    imageCallbacks.version = kCTRunDelegateVersion1;
    imageCallbacks.dealloc = WFRunDelegateDeallocCallback;
    imageCallbacks.getAscent = WFRunDelegateGetAscentCallback;
    imageCallbacks.getDescent = WFRunDelegateGetDescentCallback;
    imageCallbacks.getWidth = WFRunDelegateGetWidthCallback;
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallbacks,
                                                       (__bridge void *)(emotionRunName));
    
    return runDelegate;
}
#pragma mark - Run delegate
void WFRunDelegateDeallocCallback( void* refCon ){
    // CFRelease(refCon);
}

CGFloat WFRunDelegateGetAscentCallback( void *refCon ){
    return FontHeight;
}

CGFloat WFRunDelegateGetDescentCallback(void *refCon){
    return 0.0;
}

CGFloat WFRunDelegateGetWidthCallback(void *refCon){
    // EmotionImageWidth + 2 * ImageLeftPadding
    return  19.0;
}

- (void)tapMySelf:(UITapGestureRecognizer *)tap
{
    
}
- (void)longPressMySelf:(UILongPressGestureRecognizer *)longPress
{
    
}












@end
