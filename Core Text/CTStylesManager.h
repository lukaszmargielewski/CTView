//
//  CTStylesManager.h
//  FF
//
//  Created by Lukasz Margielewski on 8/26/12.
//
//

#import <Foundation/Foundation.h>
#import "CTConstants.h"
#import "CTStyle.h"

@interface CTStylesManager : NSObject{

}
@property (nonatomic, readonly) NSString *bookDirectory;
@property (nonatomic, readonly) NSMutableDictionary *styles;

+(CTStylesManager *)defaultManager;
-(id)initFromSource:(NSString *)stylesSource;

-(CTStyle *)style:(NSString *)name;
-(CTStyle *)styleForName:(NSString *)styleName optionalInitialValues:(NSDictionary *)initialDictionary;

@end

