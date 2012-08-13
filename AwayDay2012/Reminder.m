//
//  Reminder.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Reminder.h"
#import "DBService.h"

@implementation Reminder
@synthesize sessionID=_sessionID;
@synthesize reminderMinute=_reminderMinute;

-(void)save{
    [DBService saveUserReminder:self.sessionID withMinutes:self.reminderMinute.intValue];
}
-(void)drop{
    [DBService deleteUserReminder:self.sessionID];
}

+(NSMutableArray *)getAllReminder{
    return [DBService getAllUserReminder];
}

+(Reminder *)getReminderBySessionID:(NSString *)sid{
    return [DBService getReminderBySessionID:sid];
}

-(void)dealloc{
    [_sessionID release];
    [_reminderMinute release];
    [super dealloc];
}

@end
