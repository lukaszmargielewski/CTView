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




#import "CTStyle.h"

@protocol CTItemDatasource;


@interface CTItem : NSObject{

	
	CTItem          *parent;
	CTItem          *previous;
    
	NSMutableArray *children;
	
	CTStyle *style;
	
	QuartzItemType		type;
	NSRange             range;
	
	
	BOOL pageBreakAfter;

	id<CTItemDatasource>dataSource;
	
	NSString *url;
}

@property (nonatomic, readonly) NSString *typeName;
@property (nonatomic, retain) NSString *url;

@property (nonatomic, assign) id<CTItemDatasource>dataSource;
@property (nonatomic, retain) CTItem *parent;
@property (nonatomic, retain) CTItem *previous;
@property (nonatomic, readonly) NSMutableArray *children;

@property (nonatomic, retain) CTStyle *style;

@property (nonatomic) QuartzItemType type;
@property (nonatomic) NSRange		range;
@property (nonatomic) BOOL pageBreakAfter;

+(id)defaultItem;
@end


@protocol CTItemDataSource <NSObject>

-(NSUInteger)ctItem:(CTItem *)ctItem indexForCTStyle:(CTStyle *)ctStyle;


@end
