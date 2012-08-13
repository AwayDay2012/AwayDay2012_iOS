//
//  Reminder.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property(nonatomic, retain) NSString *sessionID;
@property(nonatomic, retain) NSNumber *reminderMinute;

-(void)save;
-(void)drop;
+(NSMutableArray *)getAllReminder;
+(Reminder *)getReminderBySessionID:(NSString *)sid;

@end
