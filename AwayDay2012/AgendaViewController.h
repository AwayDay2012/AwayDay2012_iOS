//
//  RootViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

//  the view to list the agenda

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AgendaViewController.h"
#import "Agenda.h"
#import "Session.h"
#import "ReminderViewController.h"
#import "TopSessionClockView.h"
#import "EGORefreshTableHeaderView.h"
#import "InputNameViewController.h"
#import "PostShareViewController.h"
#import "SBJson.h"
#import "Reminder.h"

@interface AgendaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EGORefreshTableHeaderDelegate>{
    BOOL loading;
}

@property(nonatomic, retain) NSMutableArray *agendaList;
@property(nonatomic, retain) NSMutableArray *reminderList;
@property(nonatomic, retain) IBOutlet UILabel *topSessionTitleLabel;
@property(nonatomic, retain) IBOutlet UILabel *topSessionDurationLabel;
@property(nonatomic, retain) IBOutlet UITableView *agendaTable;
@property(nonatomic, retain) NSIndexPath *selectedCell;
@property(nonatomic, retain) ReminderViewController *reminderViewController;
@property(nonatomic, retain) IBOutlet TopSessionClockView *clockView;
@property(nonatomic, retain) IBOutlet UILabel *topSessionRestTimeLabel;
@property(nonatomic, retain) EGORefreshTableHeaderView *refreshView;
@property(nonatomic, retain) InputNameViewController *inputNameViewController;
@property(nonatomic, retain) PostShareViewController *postShareViewController;

/**
 load the agenda list and their sessions
 */
-(void)loadAgendaList;

/**
 update the top session area's UI
 */
-(void)updateTopSession;

/**
 build the common session cell of the table
 */
-(void)buildSessionCell:(UITableViewCell *)cell withSession:(Session *)session;

/**
 build the selection effect of the choosed session
 */
-(void)buildSessionDetailView:(UITableViewCell *)cell withSession:(Session *)session;

-(NSMutableArray *)checkSessionJoinConflict:(Session *)session;

-(IBAction)joinButtonPressed:(id)sender;
-(IBAction)remindButtonPressed:(id)sender;
-(IBAction)shareButtonPressed:(id)sender;

@end
