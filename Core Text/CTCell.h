//
//  CTCell.h
//  FF
//
//  Created by Lukasz Margielewski on 8/26/12.
//
//

#import <UIKit/UIKit.h>
#import "CTRenderer.h"

@interface CTCell : UITableViewCell<CTRendererDelegate>

@property (nonatomic, readonly) CTRenderer *ctRenderer;

@end
