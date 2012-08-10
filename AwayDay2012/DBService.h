//
//  DBService.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBService : NSObject

+(void)saveSessionList:(NSArray *)sessionList;

@end
