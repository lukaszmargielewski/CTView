//
//  CTPage.m
//  iBook
//
//  Created by Lukasz Margielewski on 2/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTPage.h"
#import "CTItem.h"

@implementation CTPage


@synthesize frame;
@synthesize index, visibleTextRange;
@synthesize ctFrame;
@synthesize firstItemIndex;

-(void)dealloc{

	if(ctFrame)CFRelease(ctFrame);
	
	[super dealloc];
}

-(void)setCtFrame:(CTFrameRef)ctFrame_{

	if(ctFrame)CFRelease(ctFrame);
	ctFrame = ctFrame_;
	CFRetain(ctFrame);
}
@end
