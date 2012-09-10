//
//  CTCell.m
//  FF
//
//  Created by Lukasz Margielewski on 8/26/12.
//
//

#import "CTCell.h"

@implementation CTCell{

    CTRenderer *ctRenderer;
    CALayer *ctLayer;
    CAShapeLayer *shapeLayer;
    
    
}
@synthesize ctRenderer;
-(void)dealloc{

    [ctRenderer release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
        // Initialization code
        CGRect b = self.contentView.bounds;
        ctRenderer = [[CTRenderer alloc] initWithSize:b.size];
        ctRenderer.delegate = self;
        ctLayer = [CALayer layer];
        ctLayer.frame = b;
        ctLayer.opaque = YES;
        ctLayer.backgroundColor = [UIColor clearColor].CGColor;
        ctLayer.contentsScale = [[UIScreen mainScreen] scale];
        ctRenderer.scale = ctLayer.contentsScale;
        
        shapeLayer = [CAShapeLayer layer];
        shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.lineWidth = 1.0;
        shapeLayer.lineJoin = kCALineCapRound;
        shapeLayer.frame = b;
        //shapeLayer.borderWidth = 1.0;
//        shapeLayer.borderColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        
        [self.contentView.layer addSublayer:ctLayer];
        [self.contentView.layer addSublayer:shapeLayer];
        
        
        self.textLabel.font = [UIFont systemFontOfSize:10];
        self.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];

        self.detailTextLabel.font = [UIFont systemFontOfSize:10];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];

        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.detailTextLabel.textAlignment = UITextAlignmentRight;

        self.imageView.layer.shadowOffset = CGSizeMake(4.0, 4.0);
        //self.imageView.layer.borderWidth = 1.0;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 5.0;
        self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)ctRenderer:(CTRenderer *)renderer finishedRenderingWithTime:(NSTimeInterval)time attributedStringRecreationTime:(NSTimeInterval)recreationTime{

    ctLayer.contents = (id)renderer.renderedImage;
   // self.detailTextLabel.text = [NSString stringWithFormat:@"rtime: %.5f | attr_rt: %.5f | %@ | av: %i", time, recreationTime, renderer.selector, renderer.avoided];
    
    
}

-(void)layoutSubviews{

    [super layoutSubviews];

    CGRect b = self.contentView.bounds;
    CGFloat W = b.size.width;
    CGFloat H = b.size.height;
    
    
    
    //self.textLabel.backgroundColor = self.detailTextLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
    
    self.textLabel.frame = CGRectMake(5, b.size.height - 10, 60, 10);
    self.imageView.frame = CGRectMake(5, 5, 50, 50);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 60, 5);
    CGPathAddLineToPoint(path, NULL, W - 5, 5);
    CGPathAddLineToPoint(path, NULL, W - 5, H - 65);
    CGPathAddLineToPoint(path, NULL, W - 65, H - 5);
    
    CGPathAddLineToPoint(path, NULL, 5, H - 5);
    CGPathAddLineToPoint(path, NULL, 5, 60);
    CGPathAddLineToPoint(path, NULL, 60, 60);
    CGPathAddLineToPoint(path, NULL, 60, 5);
    
    ctRenderer.ctPath = path;
    CGPathRelease(path);
    
    
    path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, W - 60, H - 5);
    CGPathAddLineToPoint(path, NULL, W - 5, H - 60);
    CGPathAddLineToPoint(path, NULL, W - 5, H - 5);
    CGPathAddLineToPoint(path, NULL, W - 60, H - 5);
    
    
    shapeLayer.path = path;
    CGPathRelease(path);
    
    ctLayer.frame = b;
    shapeLayer.frame = b;
    ctRenderer.size = b.size;
    
    //self.detailTextLabel.frame = CGRectMake(65, b.size.height - 10, b.size.width - 70, 10);
    
}
@end
