//
//  FTCoreTextStyle.m
//  FTCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "CTLMStyle.h"
#import "UIColor-Expanded.h"

#define FONT_SIZE_BASE 12.0

@implementation CTLMStyle
@synthesize name;
@synthesize parent, children;

@synthesize fontSize;

@synthesize lineHeightMin;
@synthesize lineHeightMax;
@synthesize lineLeading;
@synthesize firstLineIndent;

@synthesize margin;

@synthesize textAlignment;
@synthesize lineBreakMode;
@synthesize textTransform;


@synthesize dataSource;
@synthesize indexInDataSource;
@synthesize fontColorString, fontString;
@synthesize font, color;

-(void)dealloc{

    if (font != NULL)CFRelease(font);
    if (color != NULL)CFRelease(color);
    
    [fontColorString release];
    [fontString release];
	[parent release];
	[children release];
	
	[name release];
	[super dealloc];
	
}
-(void)setColor:(CGColorRef)color_{

    if (color != NULL)CFRelease(color);
    color = CGColorRetain(color_);
}
-(void)setFont:(CTFontRef)font_{

    if (font != NULL)CFRelease(font);
    font = CFRetain(font_);
}
-(void)setIndexInDataSource:(NSUInteger)indexInDataSource_{

	
	indexInDataSource = indexInDataSource_;
	
}
-(NSMutableArray *)children{

	
	if (!children) {
		children = [[NSMutableArray alloc] init];
	}
	
	return children;
}


- (id)init{
	self = [super init];
	if (self) {

    
		
		UIEdgeInsets mar = UIEdgeInsetsMake(0, 0, 0, 0);
		
		margin = mar;
				
		lineBreakMode = kCTLineBreakByWordWrapping;
		textAlignment = kCTLeftTextAlignment;
		textTransform = CTTextTransformNone;
		
		firstLineIndent = 0;
		lineHeightMin = 1.0;
		lineHeightMax = 1.0;
		lineLeading = 1.0;

		
	}
	return self;
}
+ (id)defaultStyle {
    CTLMStyle *style = [[CTLMStyle alloc] init];
    return [style autorelease];
}
+ (id)styleWithName:(NSString *)name {
    CTLMStyle *style = [[CTLMStyle alloc] init];
    [style setName:name];
    return [style autorelease];
}

#pragma GCC diagnostic warning "-Wdeprecated-declarations"

-(NSString * )description{
	
	NSString *tal;
	
	switch (textAlignment) {
		case kCTCenterTextAlignment:
			tal = @"kCTCenter";
			break;
		case kCTLeftTextAlignment:
			tal = @"kCTLeft";
			break;
		case kCTRightTextAlignment:
			tal = @"kCTRight";
			break;
		case kCTJustifiedTextAlignment:
			tal = @"kCTJustified";
			break;
		case kCTNaturalTextAlignment:
			tal = @"kCTNatural";
			break;
		default:
			tal = @"Unknown!";
			break;
	}
	
	NSString *lbm;
	/*
	 kCTLineBreakByWordWrapping = 0,
	 kCTLineBreakByCharWrapping = 1,
	 kCTLineBreakByClipping = 2,
	 kCTLineBreakByTruncatingHead = 3,
	 kCTLineBreakByTruncatingTail = 4,
	 kCTLineBreakByTruncatingMiddle = 5
	 */
	switch (lineBreakMode) {
		case kCTLineBreakByCharWrapping:
			lbm = @"CharWrapping";
			break;
		case kCTLineBreakByWordWrapping:
			lbm = @"WordWrapping";
			break;
		case kCTLineBreakByClipping:
			lbm = @"Clipping";
			break;
		case kCTLineBreakByTruncatingHead:
			lbm = @"TruncatingHead";
			break;
		case kCTLineBreakByTruncatingTail:
			lbm = @"TruncatingTail";
			break;
		case kCTLineBreakByTruncatingMiddle:
			lbm = @"TruncatingMiddle";
			break;
		default:
			lbm = @"Unknown!";
			break;
	}
	
	NSString *nameToPrint = (name) ? name : @"unnamed";
	
	return [NSString stringWithFormat:@"%@ | %@, %@, f: %@, lineh: %.2f, line: %.2f",nameToPrint, tal, lbm, NSStringFromUIEdgeInsets(margin), lineHeightMin, lineLeading];
	
}
+ (id)styleWithDictionary:(NSDictionary *)dictionary{


	////NSLog(@"styleWithDictionary: %@", dictionary);
	NSString *name  = [dictionary valueForKey:@"name"];
	
	CTLMStyle *style = [CTLMStyle styleWithName:name];
    
	style.fontString  = [dictionary valueForKey:@"font"];
	style.fontColorString = [dictionary valueForKey:@"fontColor"];
	
	
	int lbm = [[dictionary valueForKey:@"lineBreakMode"] intValue];
	int ta = [[dictionary valueForKey:@"textAlignment"] intValue];
	int tt = [[dictionary valueForKey:@"textTransform"] intValue];

	style.lineBreakMode = lbm;
    style.textAlignment = ta;
    style.textTransform = tt;
    
	NSNumber *lh = [dictionary valueForKey:@"lineHeight"];
	NSNumber *lhm = [dictionary valueForKey:@"lineHeightMax"];
	NSNumber *ls = [dictionary valueForKey:@"lineLeading"];
	
	////NSLog(@"lh: %@, lhm: %@, ls: %@", lh, lhm, ls);
	
	style.lineHeightMin = (lh != nil)? [lh floatValue] : style.lineHeightMin;
	style.lineHeightMax = (lhm != nil) ? [lhm floatValue] : style.lineHeightMax;
	style.lineLeading = (ls != nil)? [ls floatValue] : style.lineLeading;
	style.firstLineIndent = [[dictionary valueForKey:@"firstLineIndent"] floatValue];
		
	UIEdgeInsets margin;
	
	margin.top = [[dictionary valueForKey:@"marginTop"] floatValue];
	margin.left = [[dictionary valueForKey:@"marginLeft"] floatValue];
	margin.right = [[dictionary valueForKey:@"marginRight"] floatValue];
	margin.bottom = [[dictionary valueForKey:@"marginBottom"] floatValue];
	
	style.margin = margin;
	
    if (style.fontString) {
    
        
        NSArray *parts = [style.fontString componentsSeparatedByString:@"|"];
        
        
        NSString *fn = [parts objectAtIndex:0];
        NSString *sizen =  [ parts objectAtIndex:1];
        CGFloat size = [sizen floatValue] * FONT_SIZE_BASE;
        //NSLog(@"Style: %@ creating font name: %@ size: %f", style.name, fn, size);
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fn, size, NULL);
        
        style.fontSize = size;
        style.font = fontRef;
        
        CFRelease(fontRef);
    
        
    }
    
    if (style.fontColorString) {

        //[style.fontColorString stringByReplacingOccurrencesOfString:@"#" withString:@""]
        CGColorRef c = [UIColor colorWithString:style.fontColorString].CGColor;
        style.color = c;

    }
    
    
    
    
	
	/*
	CGRect frame;
	
	frame.origin.y		= [[dictionary valueForKey:@"frameOriginY"] floatValue];
	frame.origin.x		= [[dictionary valueForKey:@"frameOriginX"] floatValue];
	frame.size.width	= [[dictionary valueForKey:@"frameSizeWidth"] floatValue];
	frame.size.height	= [[dictionary valueForKey:@"frameSizeHeight"] floatValue];
	
	frame = frame;
	*/
	
	
	return style;
	
}
-(NSDictionary *)dictionaryRepresentation{

	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:16];
	
	[dictionary setValue:self.name forKey:@"name"];
	

	[dictionary setValue:self.fontString forKey:@"font"];
	[dictionary setValue:self.fontColorString forKey:@"fontColor"];
	

	[dictionary setValue:[NSNumber numberWithInt:lineBreakMode] forKey:@"lineBreakMode"];
	[dictionary setValue:[NSNumber numberWithInt:textAlignment] forKey:@"textAlignment"];
	[dictionary setValue:[NSNumber numberWithInt:textTransform] forKey:@"textTransform"];
	
	
	[dictionary setValue:[NSNumber numberWithFloat:lineHeightMin] forKey:@"lineHeight"];
	[dictionary setValue:[NSNumber numberWithFloat:lineHeightMax] forKey:@"lineHeightMax"];
	[dictionary setValue:[NSNumber numberWithFloat:lineLeading] forKey:@"lineLeading"];
	[dictionary setValue:[NSNumber numberWithFloat:firstLineIndent] forKey:@"firstLineIndent"];
	
	
	[dictionary setValue:[NSNumber numberWithFloat:margin.top] forKey:@"marginTop"];
	[dictionary setValue:[NSNumber numberWithFloat:margin.left] forKey:@"marginLeft"];
	[dictionary setValue:[NSNumber numberWithFloat:margin.right] forKey:@"marginRight"];
	[dictionary setValue:[NSNumber numberWithFloat:margin.bottom] forKey:@"marginBottom"];

	/*
	
	[dictionary setValue:[NSNumber numberWithInt:frame.origin.y] forKey:@"frameOriginY"];
	[dictionary setValue:[NSNumber numberWithInt:frame.origin.x] forKey:@"frameOriginX"];
	[dictionary setValue:[NSNumber numberWithInt:frame.size.width] forKey:@"frameSizeWidth"];
	[dictionary setValue:[NSNumber numberWithInt:frame.size.height] forKey:@"frameSizeHeight"];
	
	*/
	
	return dictionary;
	
}
@end
