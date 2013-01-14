//
//  ViewController.h
//  CTLayer
//
//  Created by Lukasz Margielewski on 9/2/12.
//  Copyright (c) 2012 Lukasz Margielewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTLMRenderer.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CTLMRendererDelegate>
@property (nonatomic, assign) IBOutlet UITableView *table;

@end
