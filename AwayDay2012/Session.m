//
//  Session.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Session.h"

@implementation Session
@synthesize sessionID=_sessionID;
@synthesize sessionTitle=_sessionTitle;
@synthesize sessionStartTime=_sessionStartTime;
@synthesize sessionEndTime=_sessionEndTime;
@synthesize sessionNote=_sessionNote;
@synthesize sessionSpeaker=_sessionSpeaker;
@synthesize sessionAddress=_sessionAddress;

-(void)dealloc{
    [super dealloc];
    [_sessionID release];
    [_sessionNote release];
    [_sessionSpeaker release];
    [_sessionStartTime release];
    [_sessionEndTime release];
    [_sessionTitle release];
    [_sessionAddress release];
}

@end
