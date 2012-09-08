//
//  ViewController.h
//  CTLayer
//
//  Created by Lukasz Margielewski on 9/2/12.
//  Copyright (c) 2012 Lukasz Margielewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRenderer.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CTRendererDelegate>
@property (nonatomic, assign) IBOutlet UITableView *table;

@end
