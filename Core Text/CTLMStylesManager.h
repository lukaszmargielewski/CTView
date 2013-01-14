//
//  CTStylesManager.h
//  FF
//
//  Created by Lukasz Margielewski on 8/26/12.
//
//

#import <Foundation/Foundation.h>
#import "CTLMStyle.h"

@interface CTLMStylesManager : NSObject{

}
@property (nonatomic, readonly) NSString *bookDirectory;
@property (nonatomic, readonly) NSMutableDictionary *styles;

+(CTLMStylesManager *)defaultManager;
-(id)initFromSource:(NSString *)stylesSource;

-(CTLMStyle *)style:(NSString *)name;
-(CTLMStyle *)styleForName:(NSString *)styleName optionalInitialValues:(NSDictionary *)initialDictionary;

@end

