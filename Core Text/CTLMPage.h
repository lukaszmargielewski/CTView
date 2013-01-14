//
//  CTPage.h
//  iBook
//
//  Created by Lukasz Margielewski on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"

@class CTLMItem;

@interface CTLMPage : NSObject{

	NSUInteger index;
	CGRect frame;
	
	CFRange visibleTextRange;
	
	CTFrameRef ctFrame;
	
	NSUInteger firstItemIndex;
	
	
}
@property (nonatomic) NSUInteger index;
@property (nonatomic) NSUInteger firstItemIndex;
@property (nonatomic) CGRect frame;

@property (nonatomic) CFRange visibleTextRange;

@property (nonatomic) CTFrameRef ctFrame;

@end
