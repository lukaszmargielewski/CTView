//
//  QuartzBook.h
//  iBook
//
//  Created by Lukasz Margielewski on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CTLMItem.h"
#import "CTLMStylesManager.h"

#import <QuartzCore/QuartzCore.h>

@class CTLMRenderer;

@protocol CTLMRendererDelegate <NSObject>

-(void)ctRenderer:(CTLMRenderer *)renderer finishedRenderingWithTime:(NSTimeInterval)time attributedStringRecreationTime:(NSTimeInterval)recreationTime;

@end
@interface CTLMRenderer : NSObject

@property (atomic) CGSize size;
@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, readonly) CGImageRef renderedImage;

@property (nonatomic, readonly) NSMutableArray *ctItems;
@property (atomic, retain) id identityObject;
@property (nonatomic, assign) id<CTLMRendererDelegate>delegate;

@property (nonatomic, readonly) NSString *selector;
@property (nonatomic, readonly) BOOL avoided;
@property (nonatomic) CGFloat scale;
@property (atomic) CGMutablePathRef ctPath;

-(id)initWithSize:(CGSize)size;
-(void)reset;
-(void)commit;

-(void)addLineBreak;
-(void)addText:(NSString *)text withStyleName:(NSString *)styleName;
-(void)addCTitem:(NSString *)elementName text:(NSString *)content styleName:(NSString *)styleName ctStyle:(NSDictionary *)extras;

@end
