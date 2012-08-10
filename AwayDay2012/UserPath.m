//
//  UserPath.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPath.h"

@implementation UserPath
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
    [_sessions release];
}

@end
