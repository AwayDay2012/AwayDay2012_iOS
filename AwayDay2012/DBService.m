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
    sqlite3_finalize(stmt);
}

@end
