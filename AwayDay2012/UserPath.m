//
//  UserPath.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPath.h"
#import "DBService.h"

@implementation UserPath
@synthesize pathID=_pathID;
@synthesize pathImage=_pathImage;
@synthesize pathContent=_pathContent;
@synthesize pathCreateTime=_pathCreateTime;

-(id)init{
    self=[super init];
    if(self){
        _pathID=nil;
        _pathImage=nil;
        _pathContent=nil;
        _pathCreateTime=nil;
    }
    return self;
}

-(void)save{
    [DBService saveUserPath:self];
}
+(NSMutableArray *)getAllUserPath{
    return [DBService getAllUserPath];
}

-(void)dealloc{
    [_pathID release];
    [_pathImage release];
    [_pathContent release];
    [_pathCreateTime release];
    [super dealloc];
}

@end
