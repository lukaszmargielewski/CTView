//
//  CTItem.h
//  iBook
//
//  Created by Lukasz Margielewski on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum QuartzItemType{
	
	QuartzTypeText = 0,
	QuartzTypeImage,
	QuartzTypeLink,
	QuartzTypeSpace,
	QuartzTypePageBreak
	
}QuartzItemType;




#import "CTLMStyle.h"

@protocol CTLMItemDatasource;


@interface CTLMItem : NSObject{

	
	CTLMItem          *parent;
	CTLMItem          *previous;
    
	NSMutableArray *children;
	
	CTLMStyle *style;
	
	QuartzItemType		type;
	NSRange             range;
	
	
	BOOL pageBreakAfter;

	id<CTLMItemDatasource>dataSource;
	
	NSString *url;
}

@property (nonatomic, readonly) NSString *typeName;
@property (nonatomic, retain) NSString *url;

@property (nonatomic, assign) id<CTLMItemDatasource>dataSource;
@property (nonatomic, retain) CTLMItem *parent;
@property (nonatomic, retain) CTLMItem *previous;
@property (nonatomic, readonly) NSMutableArray *children;

@property (nonatomic, retain) CTLMStyle *style;

@property (nonatomic) QuartzItemType type;
@property (nonatomic) NSRange		range;
@property (nonatomic) BOOL pageBreakAfter;

+(id)defaultItem;
@end


@protocol CTLMItemDataSource <NSObject>

-(NSUInteger)ctItem:(CTLMItem *)ctItem indexForCTStyle:(CTLMStyle *)ctStyle;


@end
