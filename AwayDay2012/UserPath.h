//
//  UserPath.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPath : NSObject

@property(nonatomic, retain) NSString *pathID;
@property(nonatomic, retain) NSString *pathContent;
@property(nonatomic, retain) NSString *pathImage;
@property(nonatomic, retain) NSDate *pathCreateTime;

-(void)save;
+(NSMutableArray *)getAllUserPath;

@end
