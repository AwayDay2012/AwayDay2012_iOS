//
//  Session.h
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SessionAddress.h"

@interface Session : NSObject

@property(nonatomic, retain) NSString *sessionID;
@property(nonatomic, retain) NSString *sessionTitle;
@property(nonatomic, retain) NSString *sessionNote;
@property(nonatomic, retain) NSString *sessionSpeaker;
@property(nonatomic, retain) NSDate *sessionStartTime;
@property(nonatomic, retain) NSDate *sessionEndTime;
@property(nonatomic, retain) SessionAddress *sessionAddress;

@end
