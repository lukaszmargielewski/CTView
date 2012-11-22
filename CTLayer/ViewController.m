//
//  ViewController.m
//  CTLayer
//
//  Created by Lukasz Margielewski on 9/2/12.
//  Copyright (c) 2012 Lukasz Margielewski. All rights reserved.
//

#import "ViewController.h"
#import "CTCell.h"

@interface ViewController ()

@end

@implementation ViewController{

    UITableView *table;
}
@synthesize table;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 130.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 100000;//100000;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cid = @"cid";
    
    CTCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    
    if (!cell) {
        cell = [[[CTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid] autorelease];
 //       cell.ctRenderer.delegate = self;
    }
    
    cell.ctRenderer.identityObject = indexPath;
    
    [cell.ctRenderer reset];
    NSString *title = [NSString stringWithFormat:@"%i. Lukasz Margielewski", indexPath.row];
    [cell.ctRenderer addText:title withStyleName:@"h2"];
    
    [cell.ctRenderer addLineBreak];
    //[cell.ctlayer addText:@"Lorem ipsum title" withStyleName:@"h2"];
    
    [cell.ctRenderer addText:@"Lorem Ipsum is simply dummy tex publishing software." withStyleName:@"p"];
    [cell.ctRenderer addLineBreak];
    [cell.ctRenderer addText:@"but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." withStyleName:@"p"];
    [cell.ctRenderer commit];
    
    UIImage *image = nil;
    
    switch (indexPath.row % 3) {
        case 0:
            image = [UIImage imageNamed:@"marta.jpg"];
            break;
        case 1:
            image = [UIImage imageNamed:@"btf.png"];
            break;
        case 2:
            image = [UIImage imageNamed:@"abstract.png"];
            break;
        default:
            break;
    }
    cell.imageView.image = image;
    //cell.textLabel.text = [NSString stringWithFormat:@"row: %i", indexPath.row];
    return cell;
}
@end
