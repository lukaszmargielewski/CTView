//
//  CTStylesManager.m
//  FF
//
//  Created by Lukasz Margielewski on 8/26/12.
//
//

#import "CTStylesManager.h"
#import "UIColor-Expanded.h"

#define DEFAULT_FONT_SIZE 12.0


@implementation CTStylesManager{

    NSString *stylesFile;
    
    NSMutableDictionary *styles;
    CGFloat baseFontSize;
    
}


@synthesize bookDirectory;
@synthesize styles;

-(void)dealloc{

    [stylesFile release];
    [styles release];
	
    [bookDirectory  release];
    [super dealloc];
}
+(CTStylesManager *)defaultManager {
    
    static dispatch_once_t done;
    static CTStylesManager *shared = nil;
    
    dispatch_once(&done, ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ctstyles.plist" ofType:@"plist"];
        shared = [[CTStylesManager alloc] initFromSource:filePath];
        
    });
    return shared;
}

-(id)initFromSource:(NSString *)stylesSource{

    self = [super init];
    
    if (self) {
    
        stylesFile = [stylesSource copy];
        baseFontSize = DEFAULT_FONT_SIZE;
        
    }
    
    return self;
}



#pragma mark - Style retrieving:
-(CTStyle *)style:(NSString *)name{

    return [self styleForName:name optionalInitialValues:nil];
}

-(CTStyle *)styleForName:(NSString *)styleName optionalInitialValues:(NSDictionary *)initialDictionary{
    
	
	CTStyle *ctStyle = [self.styles objectForKey:styleName];
	
	if (!ctStyle) {
        
		if (initialDictionary) {
          
			ctStyle = [CTStyle styleWithDictionary:initialDictionary];
            [self.styles setObject:ctStyle forKey:styleName];
		}
		
	}
	
	
	return ctStyle;
    
	
}


#pragma mark - Styles initialization:

-(NSMutableDictionary *)styles{

    if (!styles) {
        [self initStyles];
    }
    return styles;
}
-(void)initStyles{
    
	
    NSString *pathPlist = [[NSBundle mainBundle] pathForResource:@"ctstyles" ofType:@"plist"];
    //NSLog(@"path: %@", pathPlist);
//    NSDictionary *sa = [NSDictionary dictionaryWithContentsOfFile:pathPlist];
	NSArray *sa = [NSArray arrayWithContentsOfFile:pathPlist];
	if (sa) {
		
		//NSLog(@"Styles initial: %@", sa);
//        NSArray *allKeys = [sa allKeys];
		int stylesCount = [sa count];
		
        [styles release];
        styles = [[NSMutableDictionary alloc] initWithCapacity:stylesCount];
        
       	// 1. Process styles array:
		for (NSDictionary *style in sa) {
			

            NSString *key = [style valueForKey:@"name"];
            
			CTStyle *ctstyle = [CTStyle styleWithDictionary:style];
            [self.styles setObject:ctstyle forKey:key];
    
			
			
		}
        

        //NSLog(@"Styles produced: %@", self.styles);

        //	////NSLog(@"=========== ANALYZE STYLES END =========");
        
	}
	
}



-(NSString *)bookDirectory {
         
         if (!bookDirectory) {
             
             bookDirectory = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] retain];
         }
         
         return bookDirectory;
     }

     
@end
