//
//  DBService.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DBService.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "Session.h"
#import "Reminder.h"

@implementation DBService

+(void)saveSessionList:(NSArray *)sessionList{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *del=@"delete from session_lis";
    sqlite3_stmt *stmt;
    sqlite3_exec(appDelegate.database, [del UTF8String], nil, &stmt, nil);
    
    for(NSDictionary *session in sessionList){
        NSString *save=[NSString stringWithFormat:@"insert into session_lis(session_id,session_title,session_description,session_speaker,session_start,session_end,session_location) values('%@','%@','%@','%@','%@','%@','%@')", [session objectForKey:kSessionIDKey], [session objectForKey:kSessionTitleKey], [session objectForKey:kSessionDescriptionKey],[session objectForKey:kSessionSpeakerKey], [session objectForKey:kSessionStartKey], [session objectForKey:kSessionEndKey], [session objectForKey:kSessionLocationKey]];
        
        sqlite3_exec(appDelegate.database, [save UTF8String], nil, &stmt, nil);
        sqlite3_reset(stmt);
    }
}

+(void)deleteUserReminder:(NSString *)sessionID{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *del=[NSString stringWithFormat:@"delete from user_reminder where session_id='%@'", sessionID];
    sqlite3_stmt *stmt;
    sqlite3_exec(appDelegate.database, [del UTF8String], nil, &stmt, nil);
}

+(void)saveUserReminder:(NSString *)sessionID withMinutes:(int)min{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *save=[NSString stringWithFormat:@"insert into user_reminder(session_id,reminder_min) values('%@',%d)", sessionID, min];
    sqlite3_stmt *stmt;
    
    char *errorMsg;
    if(sqlite3_exec(appDelegate.database, [save UTF8String], nil, &stmt, &errorMsg)!=SQLITE_OK){
        NSLog(@"%@", [NSString stringWithUTF8String:errorMsg]);
    }
}

+(NSMutableArray *)getAllUserReminder{
    NSMutableArray *result=[[NSMutableArray alloc]initWithCapacity:0];
    
    NSString *q=@"select * from user_reminder order by id";
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(appDelegate.database, [q UTF8String], -1, &stmt, NULL);
    while(sqlite3_step(stmt) == SQLITE_ROW){
        char *sessionID=(char *)sqlite3_column_text(stmt, 1);
        int reminderMin=sqlite3_column_int(stmt, 2);
        
        Reminder *reminder=[[Reminder alloc]init];
        [reminder setSessionID:[NSString stringWithUTF8String:sessionID]];
        [reminder setReminderMinute:[NSNumber numberWithInt:reminderMin]];
        [result addObject:reminder];
        [reminder release];
    }
    if(stmt)sqlite3_finalize(stmt);
    [result autorelease];
    return result;
}

+(Reminder *)getReminderBySessionID:(NSString *)sessionID{
    Reminder *result=nil;
    NSString *q=[NSString stringWithFormat:@"select * from user_reminder where session_id=%@", sessionID];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    sqlite3_stmt *stmt;
    sqlite3_prepare_v2(appDelegate.database, [q UTF8String], -1, &stmt, NULL);
    if(sqlite3_step(stmt) == SQLITE_ROW){
        char *sessionID=(char *)sqlite3_column_text(stmt, 1);
        int reminderMin=sqlite3_column_int(stmt, 2);
        
        result=[[Reminder alloc]init];
        [result autorelease];
        [result setSessionID:[NSString stringWithUTF8String:sessionID]];
        [result setReminderMinute:[NSNumber numberWithInt:reminderMin]];
    }
    
    if(stmt)sqlite3_finalize(stmt);
    return result;
}

@end
