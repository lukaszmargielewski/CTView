//
//  QuartzBook.m
//  iBook
//
//  Created by Lukasz Margielewski on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.

#import "CTLMRenderer.h"
#import "CTLMStylesManager.h"
#define CTDEBUG YES

@implementation CTLMRenderer{

    CGSize size;
    CGSize renderedSize;
    UIColor *backgroundColor;
    
    CTFramesetterRef framesetter;
	CTFrameRef ctFrame;
    CGImageRef renderedImage;
    
    dispatch_queue_t _renderQueue;
    
	__block NSMutableAttributedString *_attributedString;
    __block NSMutableString *_text;
    
	NSMutableArray *ctItems;
    
	__block NSTimeInterval calculationStart, calculationEnd;
	__block BOOL rendering, inititalizing, avoided;

    NSString *selector;
    
    id<CTLMRendererDelegate>delegate;
    id identityObject;
    
    CGFloat scale;
    
    CGMutablePathRef ctPath;
}


@synthesize ctItems;
@synthesize identityObject;
@synthesize delegate;
@synthesize selector;
@synthesize avoided;
@synthesize size;
@synthesize backgroundColor;
@synthesize renderedImage;
@synthesize scale;

#pragma mark - dealloc:


-(void)dealloc{

    [backgroundColor release];
	[_attributedString release];
	[_text release];
    [ctItems release];
	//dispatch_release(_renderQueue);
	if (framesetter != NULL)CFRelease(framesetter);
    if (renderedImage != NULL)CGImageRelease(renderedImage);
    if (ctPath != NULL)CFRelease(ctPath);
	[super dealloc];
}

#pragma mark - Initialization methods:

-(dispatch_queue_t)renderQueue{

    return [CTLMRenderer renderQueue];
    return _renderQueue;
}
+(dispatch_queue_t)renderQueue {
    
    return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    
    static dispatch_once_t pred;
    static dispatch_queue_t _writeQueue = nil;
    
    dispatch_once(&pred, ^{

        _writeQueue = dispatch_queue_create([@"CTLayer.render.queue" cStringUsingEncoding:NSUTF8StringEncoding], 0);
        
        
    });
    return _writeQueue;
}

-(void)initMe{

    self.backgroundColor = [UIColor whiteColor];
    
#if defined(DEBUG)
    //self.borderWidth = 1.0;
#endif
    ctItems = [[NSMutableArray alloc] init];
    _text = [[NSMutableString alloc] init];
    //_renderQueue = dispatch_queue_create([@"CTLayer.render.queue" cStringUsingEncoding:NSUTF8StringEncoding], 0);

}
-(id)initWithSize:(CGSize)size_{

    self = [super init];
    
    if (self) {
        
        [self initMe];
        size = size_;
    }
    
    return self;
}
-(id)init{

    self = [super init];
    
    if (self) {
        
        [self initMe];
    }
    
    return self;
}


#pragma mark - Setters overrides:

-(void)setCtPath:(CGMutablePathRef)ctPath_{

    @synchronized(self){
    
        if (ctPath != NULL)
            CFRelease(ctPath);
        
        ctPath = (ctPath_);
        CGPathRetain(ctPath);
    }
    
    
}
-(void)setSize:(CGSize)size_{

    if (size_.width == size.width && size_.height == size.height) {
        return;
    }

    @synchronized(self){
    
        size = size_;
        
        [selector release];
        selector = [@"setSize" retain];
        
    }
    
    
    
    CGFloat rw = CGImageGetWidth(renderedImage) / scale;
    CGFloat rh = CGImageGetHeight(renderedImage) / scale;
    
    //NSLog(@"setting size. rw: %.1f, rh: %.1f | size %@ | rendering: %i", rw, rh, NSStringFromCGSize(size), rendering);
    if ((!renderedImage || rw != size.width || rh != size.height)) {

            [self render];
    }

    
}


#pragma mark - Rendering and Calculations:


-(void)commit{

    [selector release];
    selector = [@"commit" retain];
    [self render];
}
-(void)render{
	
	//if (rendering)return;
	
	
    
   // dispatch_async([self renderQueue], ^{

        NSTimeInterval rt = 0;
        
        if (!_attributedString) {
            
            NSTimeInterval cs = [[NSDate date] timeIntervalSince1970];
            [self recreateAttributedString];
            NSTimeInterval ce = [[NSDate date] timeIntervalSince1970];
            rt = ce - cs;
            
        }
        
        rendering = YES;
        calculationStart = [[NSDate date] timeIntervalSince1970];
        [self renderGCD];
        calculationEnd = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval time = calculationEnd - calculationStart;
        rendering = NO;
    
    
    if (delegate && [delegate respondsToSelector:@selector(ctRenderer:finishedRenderingWithTime:attributedStringRecreationTime:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [delegate ctRenderer:self finishedRenderingWithTime:time attributedStringRecreationTime:rt];
        });
        
    }
   // });
	
}
-(void)renderGCD{

    CGSize pageSize = self.size;
    
    CGFloat H = pageSize.height;
    CGFloat W = pageSize.width;
    
    if (!_attributedString) {

        [self recreateAttributedString];
    }
    
    if (!_attributedString || _attributedString.length < 1 || W < 1.0 || H < 1.0) {
        avoided = YES;
        return;
    }
   
    avoided = NO;
    //NSLog(@"RenderGCD text: %@ (lenght: %i)", [_text substringToIndex:MIN(_text.length, 10)], _text.length);

    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, H);
    
    CGPathRef p = CGPathCreateCopyByTransformingPath(ctPath, &flipVertical);
    
    if (ctFrame != NULL)CFRelease(ctFrame);
    ctFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), p, NULL);
    
    
    //CFRange rangeVisible = CTFrameGetVisibleStringRange(ctFrame);
    
    
    (UIGraphicsBeginImageContextWithOptions!= NULL) ?
    UIGraphicsBeginImageContextWithOptions(pageSize,YES, 0.0) : UIGraphicsBeginImageContext(pageSize);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, CGContextGetClipBoundingBox(context));

    // Flip context
    //CGContextTranslateCTM(context, 0, H);
    //CGContextScaleCTM(context, 1.0, -1.0);
    CGContextConcatCTM(context, flipVertical);
	
	CGContextSaveGState(context);
    
      /*DEBUG
    CGContextAddPath(context, p);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.0 alpha:0.3].CGColor);
    CGContextStrokePath(context);
     */
    
	//
	CTFrameDraw(ctFrame, context);
	CGContextRestoreGState(context);

    CGPathRelease(p);
    
    
    if (renderedImage != NULL)CGImageRelease(renderedImage);
     renderedImage = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
}

-(void)reset{

    //dispatch_async([self renderQueue], ^{
    
    [selector release];
    selector = [@"reset" retain];
    
    [self.ctItems removeAllObjects];
    
    [_attributedString release], _attributedString = nil;
    [_text release], _text = [[NSMutableString alloc] init];
    if (renderedImage != NULL)CGImageRelease(renderedImage);
    renderedImage = NULL;
    
    
    if (delegate && [delegate respondsToSelector:@selector(ctRenderer:finishedRenderingWithTime:attributedStringRecreationTime:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [delegate ctRenderer:self finishedRenderingWithTime:0 attributedStringRecreationTime:0];
        });
        
    }

  //  });
    
    
    
}


#pragma mark - NSAttributedString creation:


-(void)recreateAttributedString{

    [_attributedString release];
    
    if (!_text || _text.length < 1) {
    
        _attributedString = nil;
        return;
    }
    
    _attributedString = [[NSMutableAttributedString alloc] initWithString:_text];
    
    // Style attributed string:
    {
        // Loop throught content descriptor:
        for (CTLMItem *item in self.ctItems) {
            
            CTLMStyle *style = item.style;
            
            
            {
                
                if (item.type == QuartzTypeLink || item.type == QuartzTypeText) {
                    
                    // Font:
                    [_attributedString addAttribute:(NSString*)kCTFontAttributeName value:(id)style.font range:item.range];
                    [_attributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)style.color range:item.range];
                    
                }
                
                
#define ParagraphStylesSupported 7
                // Paragraph styles
                
                
                CGFloat lineHeight = (item.type == QuartzTypeSpace) ? roundf(style.lineHeightMin) : roundf(style.lineHeightMin * style.fontSize);
                CGFloat lineHeightMax =  lineHeight;//(style.lineHeightMax * fontSizes[fontIndex]);
                CGFloat paragraphLeading = (item.type != QuartzTypeImage) ?  0 : roundf(style.lineLeading);
                CGFloat marginTop = style.margin.top;
                CGFloat marginBot = style.margin.bottom;
                //CGFloat lineSpacing = ((style.lineHeight - 1.0) * fontSizes[fontIndex]);
                CGFloat fli = style.firstLineIndent;
                CTTextAlignment tf = style.textAlignment;
                int sf = sizeof(CGFloat);
                
                // Another - nice way of doing this:
                CTParagraphStyleSetting settings[ParagraphStylesSupported] = {
                    { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &tf},
                    { kCTParagraphStyleSpecifierParagraphSpacing, sf, &marginBot},
                    { kCTParagraphStyleSpecifierMinimumLineHeight, sf, &lineHeight},
                    { kCTParagraphStyleSpecifierMaximumLineHeight, sf, &lineHeightMax},
                    {kCTParagraphStyleSpecifierLineSpacing, sf, &paragraphLeading},
                    { kCTParagraphStyleSpecifierFirstLineHeadIndent, sf, &fli},
                    { kCTParagraphStyleSpecifierParagraphSpacingBefore, sf, &marginTop},
                    
                    //{ kCTParagraphStyleSpecifierLineSpacing, sf, &lineSpacing},
                    //{ kCTParagraphStyleSpecifierTabStops, sizeof(CFArrayRef), &tabStops}//always at the end
                };
                
                CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, ParagraphStylesSupported);
                
                [_attributedString addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)paragraphStyle range:item.range];
                CFRelease(paragraphStyle);
                
            }
        }
        
        // 3. Creatin framesetter:
        
        if (framesetter != NULL)CFRelease(framesetter);
        framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedString);
    }
}


#pragma mark - Public CT Text styling methods:


-(void)addLineBreak{

    [self addCTitem:@"linebreak" text:nil styleName:nil ctStyle:nil];
}
-(void)addText:(NSString *)text withStyleName:(NSString *)styleName{

    [self addCTitem:@"text" text:text styleName:styleName ctStyle:nil];
}
-(void)addCTitem:(NSString *)elementName text:(NSString *)content styleName:(NSString *)styleName ctStyle:(NSDictionary *)extras{
	
    //NSLog(@"================== adding item =========  START  =======");
    
    
    
   // dispatch_async([self renderQueue], ^{
    
        __block NSString *ccc = content;
        __block NSString *sn = styleName;
        
    
        CTLMItem *prevItem = [self.ctItems lastObject];
        CTLMStyle *prevStyle = prevItem.style;
        
        
        BOOL is_page_break = [elementName isEqualToString:@"pagebreak"];
        BOOL is_line_break = [elementName isEqualToString:@"linebreak"];
        BOOL is_image = [elementName isEqualToString:@"img"];
        BOOL is_space = [elementName isEqualToString:@"space"];
        BOOL is_link = [elementName isEqualToString:@"a"];
        
        
        
        if(is_line_break){
            
            //content = [NSString stringWithFormat:@"%@\n", content];
            NSRange r =  prevItem.range;
            r.length++;
            prevItem.range = r;
            [_text appendString:@"\n"];
            return;
            
        }
        
        CTLMItem *item = [CTLMItem defaultItem];
        CTLMStyle *style = [[CTLMStylesManager defaultManager] styleForName:sn optionalInitialValues:extras];
        item.style = style;
        
        
        if (is_image) {
            
            ccc = @"\n";
            sn = @"img";
            NSString *url = [extras valueForKey:@"src"];
            item.url = url;
            
            UIImage *img = [UIImage imageNamed:url];
            style.lineLeading = img.size.height;
            
        }
        
        
        // Check and correct margins:
        if (prevItem) {
            
            float marginTop		= style.margin.top;
            float marginBottom	= prevStyle.margin.bottom;
            
            float margin_distance = MAX(marginTop, marginBottom);
            
            ////NSLog(@"MArgin: %.1f from top: %.1f and bottom: %.1f", margin, marginTop, marginBottom);
            
            if (margin_distance > 0) {
                
                // Override bottom margin of the previous items's style:
                
                
                UIEdgeInsets prevMargin = prevStyle.margin;
                
                prevMargin.bottom = margin_distance;
                prevStyle.margin = prevMargin;
                
                // Set top margin of the current item to 0 (Bottom margin of the previous take care of it)
                UIEdgeInsets thisMargin = style.margin;
                thisMargin.top = 0;
                style.margin = thisMargin;
                
            }
            
        }
        
        
        //content = [NSString stringWithFormat:@"\n%@", content];
        
        NSUInteger start = [_text length];
        NSUInteger lenght = [ccc length];
        
        item.range = NSMakeRange(start, lenght);
        
        NSAssert(_text !=nil, @"TEXT IS NILLL!!");
        [_text appendString:ccc];
        
        if (is_link) {
            
            item.type = QuartzTypeLink;
            
            NSString *url = [extras valueForKey:@"href"];
            item.url = url;
            
        }else if (is_image) {
            
            item.type = QuartzTypeImage;
            NSString *url = [extras valueForKey:@"src"];
            item.url = url;
            
            
        }else if (is_space) {
            
            item.type = QuartzTypeSpace;
            
        }else{
            
            item.type = QuartzTypeText;
        }
        
        [self.ctItems addObject:item];
        
   // });

	
	//NSLog(@"%i. %@",iii , item);
	//NSLog(@"with style: %@", item.style);
	//NSLog(@"================== added %i item =========  END  =======", iii);
	
    
    
}

@end
