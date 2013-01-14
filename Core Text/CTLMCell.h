//
//  CTCell.h
//  FF
//
//  Created by Lukasz Margielewski on 8/26/12.
//
//

#import <UIKit/UIKit.h>
#import "CTLMRenderer.h"

@interface CTLMCell : UITableViewCell<CTLMRendererDelegate>

@property (nonatomic, readonly) CTLMRenderer *ctRenderer;

@end
