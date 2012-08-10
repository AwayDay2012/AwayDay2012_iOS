//
//  ReminderViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//  user uses the view to set a reminder

#import <UIKit/UIKit.h>
#import "Session.h"

@interface ReminderViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, retain) Session *session;
@property(nonatomic, retain) NSMutableArray *remindTimeKeyArray;
@property(nonatomic, retain) NSMutableDictionary *remindTimeList;
@property(nonatomic, retain) IBOutlet UILabel *remindTimeLabel;
@property(nonatomic, retain) IBOutlet UIPickerView *timePicker;
@property(nonatomic, retain) NSNumber *choosedTime;

-(IBAction)backButtonPressed:(id)sender;

/**
 prepare date for the reminder picker view
 */
-(void)initRemindTimeList;

/**
 cancel the scheduled local notification for the current session
 */
-(void)cancelScheduledNotificationForCurrentSession;

/**
 schedule a new local notification with the timer interval user choosed for the current session
 */
-(void)scheduleNotificationForCurrentSession;

@end
