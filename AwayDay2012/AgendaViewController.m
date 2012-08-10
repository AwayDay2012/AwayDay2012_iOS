//
//  RootViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AgendaViewController.h"
#import "TopSessionClockView.h"
#import "AppHelper.h"
#import "AppDelegate.h"
#import "AppConstant.h"

#define tag_cell_view_start 1001
#define tag_cell_view_session_detail_view   10002

@implementation AgendaViewController
@synthesize agendaList=_agendaList;
@synthesize topSessionTitleLabel=_topSessionTitleLabel;
@synthesize topSessionDurationLabel=_topSessionDurationLabel;
@synthesize agendaTable=_agendaTable;
@synthesize selectedCell=_selectedCell;
@synthesize reminderViewController=_reminderViewController;
@synthesize clockView=_clockView;
@synthesize topSessionRestTimeLabel=_topSessionRestTimeLabel;
@synthesize refreshView=_refreshView;
@synthesize inputNameViewController=_inputNameViewController;
@synthesize postShareViewController=_postShareViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedCell=[NSIndexPath indexPathForRow:-1 inSection:-1];
    loading=NO;
    
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipe];
    [swipe release];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipe];
    [swipe release];
    
    if(self.refreshView==nil){
        EGORefreshTableHeaderView *view=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, -200, 320, 200)];
        self.refreshView=view;
        [view release];
    }
    [self.refreshView setDelegate:self];
    [self.agendaTable addSubview:self.refreshView];
    [self.refreshView refreshLastUpdatedDate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *userName=[appDelegate.userState objectForKey:kUserNameKey];
    if(userName==nil || userName.length==0){
        //1st lauch, ask for user's name
        if(self.inputNameViewController==nil){
            InputNameViewController *invc=[[InputNameViewController alloc]init];
            self.inputNameViewController=invc;
            [invc release];
        }
        [self presentModalViewController:self.inputNameViewController animated:NO];
    }
    
    [self.agendaTable setSeparatorColor:[UIColor colorWithRed:280/255.0 green:280/255.0 blue:280/255.0 alpha:1.0f]];
    if(self.agendaList==nil){
        NSMutableArray *array=[[NSMutableArray alloc]init];
        self.agendaList=array;
        [array release];
        
        [self loadAgendaList];
    }
    [self updateTopSession];
}

#pragma mark - util method
/**
 load the agenda list and their sessions
 */
-(void)loadAgendaList{
    //to load agenda from server, we mock some data for now
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm ZZZ"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
    
    //agenda day 1
    Agenda *agenda=[[Agenda alloc]init];
    [agenda setAgendaDate:[dateFormatter dateFromString:@"2012-9-22 23:59 +0800"]];
    
    NSMutableArray *sessions=[[NSMutableArray alloc]initWithCapacity:0];
    
    Session *session=[[Session alloc]init];
    [session setSessionID:@"201209220900"];
    [session setSessionTitle:@"Keynote for Away Day 2012"];
    [session setSessionNote:@"Keynote for Away Day 2012"];
    [session setSessionSpeaker:@"John Beck"];
    [session setSessionStartTime:[dateFormatter dateFromString:@"2012-9-22 09:00 +0800"]];
    [session setSessionEndTime:[dateFormatter dateFromString:@"2012-9-22 12:00 +0800"]];
    SessionAddress *add=[[SessionAddress alloc]init];
    [add setAddress:@"Beijing China"];
    [add setLatitude:[NSNumber numberWithFloat:104.29871874]];
    [add setLongitude:[NSNumber numberWithFloat:41.09891783]];
    [session setSessionAddress:add];
    [add release];
    [sessions addObject:session];
    [session release];
    
    session=[[Session alloc]init];
    [session setSessionID:@"201209221300"];
    [session setSessionTitle:@"A Better Way for Delivery Works"];
    [session setSessionNote:@"A Better Way for Delivery Works"];
    [session setSessionSpeaker:@"Micheal Jing"];
    [session setSessionStartTime:[dateFormatter dateFromString:@"2012-9-22 13:00 +0800"]];
    [session setSessionEndTime:[dateFormatter dateFromString:@"2012-9-22 15:00 +0800"]];
    add=[[SessionAddress alloc]init];
    [add setAddress:@"Beijing China"];
    [add setLatitude:[NSNumber numberWithFloat:104.29871874]];
    [add setLongitude:[NSNumber numberWithFloat:41.09891783]];
    [session setSessionAddress:add];
    [add release];
    [sessions addObject:session];
    [session release];
    
    [agenda setSessions:sessions];
    [sessions release];
    
    [self.agendaList addObject:agenda];
    [agenda release];
    
    //agenda day 2
    agenda=[[Agenda alloc]init];
    [agenda setAgendaDate:[dateFormatter dateFromString:@"2012-9-23 23:59 +0800"]];
    
    sessions=[[NSMutableArray alloc]initWithCapacity:0];
    
    session=[[Session alloc]init];
    [session setSessionID:@"201209230900"];
    [session setSessionTitle:@"Bird Watching"];
    [session setSessionNote:@"Bird Watchin"];
    [session setSessionSpeaker:@"Kevin Ma"];
    [session setSessionStartTime:[dateFormatter dateFromString:@"2012-9-23 09:00 +0800"]];
    [session setSessionEndTime:[dateFormatter dateFromString:@"2012-9-23 12:00 +0800"]];
    add=[[SessionAddress alloc]init];
    [add setAddress:@"Beijing China"];
    [add setLatitude:[NSNumber numberWithFloat:104.29871874]];
    [add setLongitude:[NSNumber numberWithFloat:41.09891783]];
    [session setSessionAddress:add];
    [add release];
    [sessions addObject:session];
    [session release];
    
    session=[[Session alloc]init];
    [session setSessionID:@"201209231300"];
    [session setSessionTitle:@"Moon Walker Project"];
    [session setSessionNote:@"A pratice for moon walker"];
    [session setSessionSpeaker:@"Lim Jiang"];
    [session setSessionStartTime:[dateFormatter dateFromString:@"2012-9-23 13:00 +0800"]];
    [session setSessionEndTime:[dateFormatter dateFromString:@"2012-9-23 15:00 +0800"]];
    add=[[SessionAddress alloc]init];
    [add setAddress:@"Beijing China"];
    [add setLatitude:[NSNumber numberWithFloat:104.29871874]];
    [add setLongitude:[NSNumber numberWithFloat:41.09891783]];
    [session setSessionAddress:add];
    [add release];
    [sessions addObject:session];
    [session release];
    
    [agenda setSessions:sessions];
    [sessions release];
    
    [self.agendaList addObject:agenda];
    [agenda release];
    
    [dateFormatter release];
    
    loading=NO;
}

/**
 update the top session area's UI
 */
-(void)updateTopSession{
    NSDate *today=[NSDate date];
    for(Agenda *agenda in self.agendaList){
        if([[today earlierDate:agenda.agendaDate] isEqualToDate:today]){
            for(Session *session in agenda.sessions){
                NSDate *sessionStartTime=session.sessionStartTime;
                if([[sessionStartTime earlierDate:today] isEqualToDate:today]){
                    NSIndexPath *path=[NSIndexPath indexPathForRow:[agenda.sessions indexOfObject:session] inSection:[self.agendaList indexOfObject:agenda]];
                    
                    [self.agendaTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    
                    [self.topSessionTitleLabel setText:session.sessionTitle];
                    
                    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"HH:mm"];
                    [self.topSessionDurationLabel setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:session.sessionStartTime], [dateFormatter stringFromDate:session.sessionEndTime]]];
                    [dateFormatter release];
                    
                    NSTimeInterval interval=[session.sessionStartTime timeIntervalSinceDate:today];
                    
                    [self.clockView setRestMinutes:[NSNumber numberWithFloat:interval]];
                    [self.clockView setNeedsDisplay];
                    
                    if(interval<12*60*60){
                        int hour=(int)(interval/3600);
                        int min=(int)(fmodf(interval, 3600)/60);
                        [self.topSessionRestTimeLabel setText:[NSString stringWithFormat:@"%d:%d", hour, min]];
                    }else{
                        [self.topSessionRestTimeLabel setText:@""];
                    }
                    
                    return;
                }
            }
        }
    }
}

/**
 build the common session cell of the table
 */
-(void)buildSessionCell:(UITableViewCell *)cell withSession:(Session *)session{
    UILabel *sessionTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 240,30)];
    [sessionTitle setTag:tag_cell_view_start];
    [sessionTitle setBackgroundColor:[UIColor clearColor]];
    [sessionTitle setTextColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f]];
    [sessionTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [sessionTitle setShadowColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:120/255.0]];
    [sessionTitle setShadowOffset:CGSizeMake(-0.2f, -0.2f)];
    [sessionTitle setText:session.sessionTitle];
    [cell addSubview:sessionTitle];
    [sessionTitle release];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    UILabel *sessionDuration=[[UILabel alloc]initWithFrame:CGRectMake(240, 10, 75, 30)];
    [sessionDuration setTag:tag_cell_view_start];
    [sessionDuration setBackgroundColor:[UIColor clearColor]];
    [sessionDuration setTextColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f]];
    [sessionDuration setFont:[UIFont systemFontOfSize:12.0f]];
    [sessionDuration setShadowColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:120/255.0]];
    [sessionDuration setShadowOffset:CGSizeMake(-0.1f, -0.1f)];
    [sessionDuration setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:session.sessionStartTime], [dateFormatter stringFromDate:session.sessionEndTime]]];
    [cell addSubview:sessionDuration];
    [sessionDuration release];
    [dateFormatter release];
}

/**
 build the selection effect of the choosed session
 */
-(void)buildSessionDetailView:(UITableViewCell *)cell withSession:(Session *)session{
    UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, 320, 110)];
    [detailView setBackgroundColor:[UIColor clearColor]];
    [detailView setTag:tag_cell_view_session_detail_view];
    
    UITextView *sessionNote=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [sessionNote setBackgroundColor:[UIColor clearColor]];
    [sessionNote setUserInteractionEnabled:NO];
    [sessionNote setText:session.sessionNote];
    [sessionNote setTextColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0f]];
    [detailView addSubview:sessionNote];
    [sessionNote release];
    
    UIButton *attend=[UIButton buttonWithType:UIButtonTypeCustom];
    [attend setFrame:CGRectMake(30, 65, 52, 32)];
    [attend setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
    [attend addTarget:self action:@selector(attendButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:attend];
    
    UIButton *remind=[UIButton buttonWithType:UIButtonTypeCustom];
    [remind setFrame:CGRectMake(134, 65, 52, 32)];
    [remind setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
    [remind addTarget:self action:@selector(remindButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:remind];
    
    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
    [share setFrame:CGRectMake(234, 65, 52, 32)];
    [share setImage:[UIImage imageNamed:@"share_button.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:share];
    
    CATransition *transition=[CATransition animation];
    transition.duration=0.15f;
    transition.type=kCATransitionMoveIn;
    transition.subtype=kCATransitionFromRight;
    [detailView.layer addAnimation:transition forKey:@"add"];
    
    [cell addSubview:detailView];
    [detailView release];
}

#pragma mark - UIAction method
-(IBAction)attendButtonPressed:(id)sender{
    
}
-(IBAction)remindButtonPressed:(id)sender{
    Agenda *agenda=[self.agendaList objectAtIndex:self.selectedCell.section];
    Session *session=[agenda.sessions objectAtIndex:self.selectedCell.row];
    
    if(self.reminderViewController==nil){
        ReminderViewController *rvc=[[ReminderViewController alloc]initWithNibName:@"ReminderViewController" bundle:nil];
        self.reminderViewController=rvc;
        [rvc release];
    }
    [self.reminderViewController setSession:session];
    [self.navigationController pushViewController:self.reminderViewController animated:YES];
}
-(IBAction)shareButtonPressed:(id)sender{
    if(self.postShareViewController==nil){
        PostShareViewController *psvc=[[PostShareViewController alloc]initWithNibName:@"PostShareViewController" bundle:nil];
        self.postShareViewController=psvc;
        [psvc release];
    }
    
    Agenda *agenda=[self.agendaList objectAtIndex:self.selectedCell.section];
    Session *session=[agenda.sessions objectAtIndex:self.selectedCell.row];
    [self.postShareViewController setSession:session];
    [self.navigationController pushViewController:self.postShareViewController animated:YES];
}

#pragma mark - UITableView method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.agendaList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    Agenda *agenda=[self.agendaList objectAtIndex:section];
    return agenda.sessions.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==self.selectedCell.section && indexPath.row==self.selectedCell.row){
        return 140.0f;
    }else{
        return 50.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [view autorelease];
    
    Agenda *agenda=[self.agendaList objectAtIndex:section];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 240, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithRed:29/255.0 green:207/255.0 blue:219/255.0 alpha:1.0f]];
    [label setFont:[UIFont systemFontOfSize:16.0f]];
    [label setText:[dateFormatter stringFromDate:agenda.agendaDate]];
    [view addSubview:label];
    [label release];
    
    [dateFormatter release];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    for(UIView *view in cell.subviews){
        if(view.tag>=tag_cell_view_start){
            [view removeFromSuperview];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.backgroundView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0f]];
    
    Agenda *agenda=[self.agendaList objectAtIndex:indexPath.section];
    Session *session=[agenda.sessions objectAtIndex:indexPath.row];
    
    [self buildSessionCell:cell withSession:session];
    
    if(indexPath.section==self.selectedCell.section && indexPath.row==self.selectedCell.row){
        [self buildSessionDetailView:cell withSession:session];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *lastSelectedCell=[self.agendaTable cellForRowAtIndexPath:self.selectedCell];
    if(lastSelectedCell!=nil){
        if([lastSelectedCell viewWithTag:tag_cell_view_session_detail_view]!=nil){
            CATransition *transition=[CATransition animation];
            transition.duration=0.15f;
            transition.type=kCATransitionMoveIn;
            transition.subtype=kCATransitionFromLeft;
            [[lastSelectedCell viewWithTag:tag_cell_view_session_detail_view].layer addAnimation:transition forKey:@"remove"];
            [[lastSelectedCell viewWithTag:tag_cell_view_session_detail_view] removeFromSuperview];
        }
    }
    if(self.selectedCell.section==indexPath.section && self.selectedCell.row==indexPath.row){
        self.selectedCell=[NSIndexPath indexPathForRow:-1 inSection:-1];
    }else{
        self.selectedCell=indexPath;
    }
    
    [self.agendaTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Pull Refresh delegate
- (void)reloadTableViewDataSource{
    loading= YES;
}
- (void)doneLoadingTableViewData{
    loading= NO;
    [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agendaTable];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.refreshView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    loading=YES;
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return loading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_agendaList release];
    [_topSessionTitleLabel release];
    [_topSessionDurationLabel release];
    [_agendaTable release];
    [_selectedCell release];
    [_reminderViewController release];
    [_clockView release];
    [_topSessionRestTimeLabel release];
    [_refreshView release];
    [_inputNameViewController release];
    [_postShareViewController release];
}

@end
