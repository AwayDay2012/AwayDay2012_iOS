//
//  DBServiceTest.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBServiceTest.h"

@implementation DBServiceTest

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

@end
