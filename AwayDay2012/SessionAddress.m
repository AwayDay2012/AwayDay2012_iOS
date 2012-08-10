//
//  SessionAddress.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionAddress.h"

@implementation SessionAddress

@synthesize address=_address;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;

-(void)dealloc{
    [super dealloc];
    [_address release];
    [_latitude release];
    [_longitude release];
}

@end
