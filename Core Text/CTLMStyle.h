//
//  FTCoreTextStyle.h
//  FTCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoreText/CoreText.h"

enum{
	CTTextTransformNone = 0,
	CTTextTransformSmallCaps = 1,
	CTTextTransformCapitalized = 2,
	CTTextTransformUppercase = 3,
};
typedef uint8_t CTTextTransform;

@protocol CTLMStyleDataSource;

@interface CTLMStyle : NSObject{

	CTLMStyle *parent;
	NSMutableArray *children;
	
    CGFloat fontSize;
    CGFloat lineHeightMin;
	CGFloat lineHeightMax;
	CGFloat lineLeading;
	CGFloat firstLineIndent;
	
	UIEdgeInsets margin;
	
	CTTextAlignment textAlignment;
	CTLineBreakMode lineBreakMode;
	CTTextTransform textTransform;
    
    
    
	NSString *name;
	NSString *fontColorString, *fontString;
	NSUInteger indexInDataSource;
    
    CTFontRef font;
    CGColorRef color;
	
	id<CTLMStyleDataSource>dataSource;
	
}

@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat lineHeightMin;
@property (nonatomic) CGFloat lineHeightMax;
@property (nonatomic) CGFloat lineLeading;
@property (nonatomic) CGFloat firstLineIndent;

@property (nonatomic) UIEdgeInsets margin;

@property (nonatomic) CTTextAlignment textAlignment;
@property (nonatomic) CTLineBreakMode lineBreakMode;
@property (nonatomic) CTTextTransform textTransform;

@property (nonatomic) NSUInteger indexInDataSource;

@property (nonatomic) CTFontRef font;
@property (nonatomic) CGColorRef color;


@property (nonatomic, assign) id<CTLMStyleDataSource>dataSource;
@property (nonatomic, retain) NSString	*name;
@property (nonatomic, retain) NSString *fontColorString, *fontString;
@property (nonatomic, retain) CTLMStyle *parent;
@property (nonatomic, readonly) NSMutableArray *children;

+ (id)defaultStyle;

+ (id)styleWithName:(NSString *)name;
+ (id)styleWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)dictionaryRepresentation;

@end

@protocol CTLMStyleDataSource <NSObject>

-(NSUInteger)ctStyle:(CTLMStyle *)ctStyle indexForFontString:(NSString *)fontString;
-(NSUInteger)ctStyle:(CTLMStyle *)ctStyle indexForColorString:(NSString *)colorString;

@end
