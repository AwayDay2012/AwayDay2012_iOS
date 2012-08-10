//
//  Agenda.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Agenda.h"

@implementation Agenda
@synthesize agendaDate=_agendaDate;
@synthesize sessions=_sessions;

-(id)init{
    self=[super init];
    if(self){
        if(self.sessions==nil){
            NSMutableArray *array=[[NSMutableArray alloc]init];
            self.sessions=array;
            [array release];
        }
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [_agendaDate release];
    [_sessions release];
}

@end
