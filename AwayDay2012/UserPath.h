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
@property(nonatomic, retain) NSDate *pathCreateTime;
@property(nonatomic, retain) UIImage *pathImage;
@property(nonatomic, retain) NSNumber *hasImage;

-(void)save;
-(void)drop;
+(NSMutableArray *)getAllUserPath;
-(UIImage *)loadLocalPathImage;

@end
