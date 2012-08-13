//
//  DBService.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class Reminder;

@interface DBService : NSObject

+(void)saveSessionList:(NSArray *)sessionList;
+(void)deleteUserReminder:(NSString *)sessionID;
+(void)saveUserReminder:(NSString *)sessionID withMinutes:(int)min;
+(NSMutableArray *)getAllUserReminder;
+(Reminder *)getReminderBySessionID:(NSString *)sessionID;

@end
