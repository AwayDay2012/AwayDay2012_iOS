//
//  DBServiceTest.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBServiceTest.h"
#import "AppHelper.h"
#import "Session.h"

@implementation DBServiceTest

-(void)testGetLocalAgendaList{
    NSMutableArray *list=[DBService getLocalAgendaList];
    STAssertNotNil(list, @"agenda list is nil");
    STAssertTrue(list.count>0, @"agenda list is empty");
    for(NSObject *obj in list){
        STAssertTrue([obj isKindOfClass:[Session class]], @"wrong element type");
    }
}

-(void)testSaveSessionList{
    [DBService saveSessionList:nil];
}

-(void)testGetSessionListBySessionIDList{
    NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:2];
    [list addObject:@"123"];
    [list addObject:@"456"];
    NSMutableArray *result=[DBService getSessionListBySessionIDList:list];
    [list release];
    STAssertNotNil(result,@"nil error");
}

-(void)testSaveUserReminder{
    [DBService saveUserReminder:@"test session" withMinutes:15];
}

-(void)testGetAllUserReminder{
    NSMutableArray *list=[DBService getAllUserReminder];
    STAssertNotNil(list, @"got nil when get all user reminder");
}

-(void)testDeleteUserReminder{
    [DBService deleteUserReminder:@"test session"];
}

-(void)testSaveUserPath{
    UserPath *path=[[UserPath alloc]init];
    [path setPathID:@"12345"];
    [path setPathContent:@"for test"];
    [path save];
    [path release];
}

-(void)testGetAllUserPath{
    NSMutableArray *list=[DBService getAllUserPath];
    STAssertNotNil(list, @"nil error");
}

-(void)testDeleteUserPath{
    UserPath *path=[[UserPath alloc]init];
    [path setPathID:@"12345"];
    [path setPathContent:@"for test"];
    [DBService deleteUserPath:path];
    [path release];
}

@end
