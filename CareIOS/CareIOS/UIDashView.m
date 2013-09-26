//
//  UIDashVIew.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-8.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "UIDashView.h"

@implementation UIDashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 3.0);
    float dashPattern[] = {6,2,2,2};
    CGContextSetLineDash(context, 2, dashPattern, 2);
    
    CGContextMoveToPoint(context, 0,0); //start at this point
    
    CGContextAddLineToPoint(context, rect.size.width, 0); //draw to this point
    
    // and now draw the Path!
    CGContextStrokePath(context);}


@end
