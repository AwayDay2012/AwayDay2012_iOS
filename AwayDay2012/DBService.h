//
//  DBService.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "UserPath.h"
@class Reminder;

@interface DBService : NSObject

+(NSMutableArray *)getLocalAgendaList;
+(void)deleteAllSessions;
+(void)saveSessionList:(NSArray *)sessionList;
+(NSMutableArray *)getSessionListBySessionIDList:(NSMutableArray *)list;

+(void)deleteUserReminder:(NSString *)sessionID;
+(void)saveUserReminder:(NSString *)sessionID withMinutes:(int)min;
+(NSMutableArray *)getAllUserReminder;
+(Reminder *)getReminderBySessionID:(NSString *)sessionID;

+(void)saveUserPath:(UserPath *)path;
+(NSMutableArray *)getAllUserPath;
+(void)deleteUserPath:(UserPath *)path;

@end
