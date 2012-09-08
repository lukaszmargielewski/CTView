//
//  CTImageRenderingLookup.h
//  CTLayer
//
//  Created by Lukasz Margielewski on 9/8/12.
//  Copyright (c) 2012 Lukasz Margielewski. All rights reserved.
//


/*  Image positoin lookup ad drawing:
 
 for (CTItem *item in self.ctItems) {
 
 CTStyle *style = item.style;
 // Ad immage to page if type is image:
 
 UIImage *img = nil;
 
 
 if (item.type == QuartzTypeImage) {
 
 NSString *image_url = item.url;
 
 img = [UIImage imageWithContentsOfFile:image_url];
 
 // Image position lookup:
 if (img) {
 
 ////NSLog(@"Need to draw image%@", image_url);
 
 NSArray *lines = (NSArray *)CTFrameGetLines(ctFrame);
 NSInteger lineCount = [lines count];
 CGPoint origins[lineCount];
 
 CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
 
 for (int i = 0; i < lineCount; i++) {
 
 CGPoint baselineOrigin = origins[i];
 CTLineRef line = (CTLineRef)[lines objectAtIndex:i];
 CFRange cfrange = CTLineGetStringRange(line);
 
 if (cfrange.location >= item.range.location) {
 
 CGFloat ascent, descent;
 CGFloat lineWidth = CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
 ////NSLog(@"Image descent: %f, ascent: %f", descent, ascent);
 CGRect lineFrame = CGRectMake(baselineOrigin.x, baselineOrigin.y, lineWidth, ascent + descent);
 
 
 {
 
 
 CTTextAlignment alignment = style.textAlignment;
 
 int x = 0;
 if (alignment == kCTLeftTextAlignment) x = style.margin.left;
 else if (alignment == kCTRightTextAlignment) x = (W - img.size.width - style.margin.right);
 else if (alignment == kCTCenterTextAlignment) x = ((W - img.size.width) / 2);
 
 CGRect frame = CGRectMake(x, lineFrame.origin.y, img.size.width, img.size.height);
 frame.origin.y -= (img.size.height - ascent - descent);
 
 // adjusting frame
 
 CGContextDrawImage(context, frame, img.CGImage);
 
 }
 
 break;
 }
 }
 
 }
 
 }
 
 
 }
 
 */