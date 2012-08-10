//
//  TopSessionClockView.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopSessionClockView.h"

@implementation TopSessionClockView
@synthesize restMinutes=_restMinutes;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.restMinutes=[NSNumber numberWithFloat:0.0f];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    float degree=self.restMinutes.floatValue / (720*60);
    degree=degree*2-0.5f;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextSetRGBFillColor(ctx, 17/255.0, 220/255.0, 234/255.0, 1.0);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, rect.size.width/2, rect.size.height/2);
    CGContextAddArc(ctx, rect.size.width/2, rect.size.height/2, rect.size.width/2, -90*M_PI/180.0, degree*M_PI, 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
}

-(void)dealloc{
    [super dealloc];
    [_restMinutes release];
}

@end
