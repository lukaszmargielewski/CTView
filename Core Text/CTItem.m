//
//  CTItem.m
//  iBook
//
//  Created by Lukasz Margielewski on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CTItem.h"

@implementation CTItem
@synthesize parent, previous, children;
@synthesize style;
@synthesize dataSource;
@synthesize typeName;
@synthesize url;
@synthesize pageBreakAfter;

@synthesize		type;
@synthesize		range;


BOOL pageBreakAfter;

-(void)dealloc{

	[url release];
	[typeName release];
	[previous release];
	[parent release];
	[children release];

	[style release];
	
	[super dealloc];
}

- (id)init{
	self = [super init];
	if (self) {
		
		type = QuartzTypeText;
		range = NSMakeRange(0, 0);
		pageBreakAfter = NO;
		
		
	}
	return self;
}
+ (id)defaultItem{
	
    CTItem *item = [[CTItem alloc] init];
	
    return [item autorelease];
}

-(NSMutableArray *)children{
	
	
	if (!children) {
		children = [[NSMutableArray alloc] init];
	}
	
	return children;
}
-(NSString *)typeName{

	NSString *types;
	
	switch (self.type) {
		case QuartzTypeText:
			types = @"text ";
			break;
		case QuartzTypeImage:
			types = @"image";
			break;
		case QuartzTypeLink:
			types = @"link ";
			break;
		case QuartzTypeSpace:
			types = @"space";
			break;
		case QuartzTypePageBreak:
			types = @"pagebreak";
			break;
		default:
			types = @"Unknown!";
			break;
	}
	
	return types;
}
-(NSString *)description{
	
	
	return [NSString stringWithFormat:@"%@ range: %@, pba: %i", self.typeName, NSStringFromRange(range), pageBreakAfter];
	
}



@end
