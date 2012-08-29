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
#import "UserPath.h"
#import "ASIHttpRequest.h"
#import "SBJson.h"
#import "DBService.h"

#define tag_cell_view_start 1001
#define tag_cell_session_title_view tag_cell_view_start+1
#define tag_cell_session_time_view  tag_cell_view_start+2
#define tag_cell_session_detail_title_view 2001
#define tag_cell_view_session_detail_view   10002
#define tag_req_load_session_list   10003

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
@synthesize reminderList=_reminderList;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedCell=[NSIndexPath indexPathForRow:-1 inSection:-1];
    loading=NO;
    
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
    
    if(self.reminderList!=nil){
        [self.reminderList removeAllObjects];
    }
    self.reminderList=[Reminder getAllReminder];
    
    [self updateTopSession];
}

#pragma mark - util method
-(void)removeInfoView{
    [AppHelper removeInfoView:self.view];
}
/**
 load the agenda list and their sessions
 */
-(void)loadAgendaList{
    NSMutableArray *allSessions=[DBService getLocalAgendaList];
    
    NSMutableDictionary *tempAgendaMapping=[[NSMutableDictionary alloc]initWithCapacity:0];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    for(Session *session in allSessions){
        NSString *sessionDateStr=[dateFormatter stringFromDate:session.sessionStartTime];
        Agenda *agenda=[tempAgendaMapping objectForKey:sessionDateStr];
        if(agenda==nil){
            agenda=[[Agenda alloc]init];
            [agenda autorelease];
            [agenda setAgendaDate:session.sessionStartTime];
            
            NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:0];
            [agenda setSessions:list];
            [list release];
        }
        [agenda.sessions addObject:session];
        [tempAgendaMapping setObject:agenda forKey:sessionDateStr];
    }
    
    [dateFormatter release];
    
    [self.agendaList addObjectsFromArray:tempAgendaMapping.allValues];
    [tempAgendaMapping release];
    
    [self getAgendaListFromServer:(NSString *)kServiceLoadSessionList showLoading:YES];
}

-(void)getAgendaListFromServer:(NSString *) urlString showLoading:(BOOL)showLoading{
    loading=YES;
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setTimeOutSeconds:10.0f];
    [request setTag:tag_req_load_session_list];
    [request startAsynchronous];
    
    if(showLoading){
        [AppHelper showInfoView:self.view withText:@"Loading..." withLoading:YES];
    }
}

-(NSMutableArray *)checkSessionJoinConflict:(Session *)session{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *userJoinList=(NSMutableArray *)[appDelegate.userState objectForKey:kUserJoinListKey];
    NSMutableArray *joinedSessionList=[DBService getSessionListBySessionIDList:userJoinList];
    if(joinedSessionList==nil || joinedSessionList.count==0) return nil;
    
    
    NSMutableArray *result=[[NSMutableArray alloc]initWithCapacity:0];
    for(Session *joinedSession in joinedSessionList){
        NSDate *joinedSessionStart=joinedSession.sessionStartTime;
        NSDate *joinedSessionEnd=joinedSession.sessionEndTime;
        
        if([[joinedSessionStart laterDate:session.sessionEndTime] isEqualToDate:session.sessionEndTime] || 
           [[joinedSessionEnd earlierDate:session.sessionStartTime] isEqualToDate:joinedSessionEnd]){
            [result addObject:joinedSession];
        }
    }
    
    [result autorelease];
    return result;
}

/**
 update the top session area's UI
 */
-(void)updateTopSession{
    if(self.agendaList.count==0) return;
    NSDate *today=[NSDate date];
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *todayString=[df stringFromDate:today];
    
    int topAgendaIndex=0;
    int topSessionIndex=0;
    
    for(int i=0;i<self.agendaList.count;i++){
        Agenda *agenda=[self.agendaList objectAtIndex:i];
        NSString *agendaDateString=[df stringFromDate:agenda.agendaDate];
        if([todayString isEqualToString:agendaDateString]){
            for(int k=0;k<agenda.sessions.count;k++){
                Session *session=[agenda.sessions objectAtIndex:k];
                NSDate *sessionStartTime=session.sessionStartTime;
                if([[sessionStartTime earlierDate:today] isEqualToDate:today]){
                    topSessionIndex=k;
                    topAgendaIndex=i;
                    break;
                }
            }
        }
    }
    [df release];
    
    Agenda *agenda=[self.agendaList objectAtIndex:topAgendaIndex];
    Session *session=[agenda.sessions objectAtIndex:topSessionIndex];
    NSIndexPath *path=[NSIndexPath indexPathForRow:topSessionIndex inSection:topAgendaIndex];
    
    [self.agendaTable scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    [self.topSessionTitleLabel setText:session.sessionTitle];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [self.topSessionDurationLabel setText:[NSString stringWithFormat:@"%@ ~ %@", [dateFormatter stringFromDate:session.sessionStartTime], [dateFormatter stringFromDate:session.sessionEndTime]]];
    [dateFormatter release];
    
    NSTimeInterval interval=[session.sessionStartTime timeIntervalSinceDate:today];
    
    if(interval>0){
        [self.clockView setRestMinutes:[NSNumber numberWithFloat:interval]];
        [self.clockView setNeedsDisplay];
        
        int hour=(int)(interval/3600);
        int min=(int)(fmodf(interval, 3600)/60);
        [self.topSessionRestTimeLabel setText:[NSString stringWithFormat:@"%d:%d", hour, min]];
    }
}

/**
 build the common session cell of the table
 */
-(void)buildSessionCell:(UITableViewCell *)cell withSession:(Session *)session{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *userJoinList=[appDelegate.userState objectForKey:kUserJoinListKey];
    
    UILabel *sessionTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 230,30)];
    [sessionTitle setTag:tag_cell_session_title_view];
    [sessionTitle setBackgroundColor:[UIColor clearColor]];
    [sessionTitle setTextColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f]];
    
    if([userJoinList containsObject:session.sessionID]){
        [sessionTitle setTextColor:[UIColor colorWithRed:214/255.0 green:95/255.0 blue:54/255.0 alpha:1.0f]];
    }
    
    [sessionTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [sessionTitle setText:session.sessionTitle];    
    [cell addSubview:sessionTitle];
    [sessionTitle release];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    UILabel *sessionDuration=[[UILabel alloc]initWithFrame:CGRectMake(240, 10, 75, 30)];
    [sessionDuration setTag:tag_cell_session_time_view];
    [sessionDuration setBackgroundColor:[UIColor clearColor]];
    [sessionDuration setTextColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f]];
    
    if([userJoinList containsObject:session.sessionID]){
        [sessionDuration setTextColor:[UIColor colorWithRed:214/255.0 green:95/255.0 blue:54/255.0 alpha:1.0f]];
    }
    
    NSDate *today=[NSDate date];
    if([[today earlierDate:session.sessionEndTime] isEqualToDate:session.sessionEndTime]){
        [sessionTitle setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0f]];
        [sessionDuration setTextColor:[UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0f]];
    }
    
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
    CGSize size=[session.sessionNote sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(320, 100) lineBreakMode:UILineBreakModeWordWrap];
    CGSize titleSize=[session.sessionTitle sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(310, 100)];
    float height=105+titleSize.height+size.height;
    
    UIView *detailView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
    [detailView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back.png"]]];
    [detailView setTag:tag_cell_view_session_detail_view];
    
    int y=8;
    UILabel *view=(UILabel *)[cell viewWithTag:tag_cell_session_title_view];
    UITextView *sessionTitle=[[UITextView alloc]initWithFrame:CGRectMake(2, y, 310, titleSize.height+10)];
    [sessionTitle setTag:tag_cell_session_detail_title_view];
    [sessionTitle setBackgroundColor:[UIColor clearColor]];
    [sessionTitle setText:session.sessionTitle];
    [sessionTitle setTextColor:view.textColor];
    [sessionTitle setFont:[UIFont systemFontOfSize:14.0f]];
    [sessionTitle setUserInteractionEnabled:NO];
    [detailView addSubview:sessionTitle];
    y+=sessionTitle.frame.size.height;
    [sessionTitle release];
    
    UILabel *sessionSpeaker=[[UILabel alloc]initWithFrame:CGRectMake(8, y, 320, 16)];
    [sessionSpeaker setBackgroundColor:[UIColor clearColor]];
    [sessionSpeaker setFont:[UIFont systemFontOfSize:12.0f]];
    [sessionSpeaker setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0f]];
    [sessionSpeaker setText:[NSString stringWithFormat:@"Speaker: %@", session.sessionSpeaker]];
    [detailView addSubview:sessionSpeaker];
    y+=sessionSpeaker.frame.size.height;
    [sessionSpeaker release];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    UILabel *sessionTime=[[UILabel alloc]initWithFrame:CGRectMake(8, y, 110, 16)];
    [sessionTime setBackgroundColor:[UIColor clearColor]];
    [sessionTime setFont:[UIFont systemFontOfSize:12.0f]];
    [sessionTime setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0f]];
    [sessionTime setText:[NSString stringWithFormat:@"Time: %@ ~ %@", [formatter stringFromDate:session.sessionStartTime],[formatter stringFromDate:session.sessionEndTime]]];
    [detailView addSubview:sessionTime];
    [sessionTime release];
    [formatter release];
    
    UILabel *sessionLocation=[[UILabel alloc] initWithFrame:CGRectMake(125, y, 290, 16)];
    [sessionLocation setBackgroundColor:[UIColor clearColor]];
    [sessionLocation setFont:[UIFont systemFontOfSize:12.0f]];
    [sessionLocation setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0f]];
    [sessionLocation setText:[NSString stringWithFormat:@"Room: %@", session.sessionAddress]];
    [detailView addSubview:sessionLocation];
    y+=sessionLocation.frame.size.height;
    [sessionLocation release];
    
    UITextView *sessionNote=[[UITextView alloc]initWithFrame:CGRectMake(0, y, 320, 100)];
    [sessionNote setBackgroundColor:[UIColor clearColor]];
    [sessionNote setUserInteractionEnabled:NO];
    [sessionNote setFrame:CGRectMake(0, y, 320, size.height+14)];
    [sessionNote setText:session.sessionNote];
    [sessionNote setFont:[UIFont systemFontOfSize:13.0f]];
    [sessionNote setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0f]];
    [sessionNote sizeToFit];
    y+=sessionNote.frame.size.height;
    [detailView addSubview:sessionNote];
    [sessionNote release];
    
    UIButton *attend=[UIButton buttonWithType:UIButtonTypeCustom];
    [attend setFrame:CGRectMake(30, y, 52, 32)];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *userJoinList=[appDelegate.userState objectForKey:kUserJoinListKey];
    if(userJoinList!=nil && [userJoinList containsObject:session.sessionID]){
        [attend setImage:[UIImage imageNamed:@"unjoin_button.png"] forState:UIControlStateNormal];
    }else{
        [attend setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
    }
    [attend addTarget:self action:@selector(joinButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:attend];
    
    UIButton *remind=[UIButton buttonWithType:UIButtonTypeCustom];
    [remind setFrame:CGRectMake(134, y, 52, 32)];
    
    [remind setImage:[UIImage imageNamed:@"reminder_button.png"] forState:UIControlStateNormal];
    
    [remind addTarget:self action:@selector(remindButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:remind];
    
    UIButton *share=[UIButton buttonWithType:UIButtonTypeCustom];
    [share setFrame:CGRectMake(234, y, 52, 32)];
    [share setImage:[UIImage imageNamed:@"share_button.png"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [detailView addSubview:share];
    
    CATransition *transition=[CATransition animation];
    transition.duration=0.15f;
    [detailView.layer addAnimation:transition forKey:@"add"];
    [cell addSubview:detailView];
    [detailView release];
}

#pragma mark - UIAction method
-(IBAction)joinButtonPressed:(id)sender{
    //to create a user path
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *userJoinList=[appDelegate.userState objectForKey:kUserJoinListKey];
    
    UIButton *joinButton=(UIButton *)sender;
    UITableViewCell *cell=[self.agendaTable cellForRowAtIndexPath:self.selectedCell];
    UILabel *sessionTitleLabel=(UILabel *)[cell viewWithTag:tag_cell_session_title_view];
    UILabel *sessionTimeLabel=(UILabel *)[cell viewWithTag:tag_cell_session_time_view];
    
    Agenda *agenda=[self.agendaList objectAtIndex:self.selectedCell.section];
    Session *session=[agenda.sessions objectAtIndex:self.selectedCell.row];
    
    NSMutableArray *conflictList=[self checkSessionJoinConflict:session];
    if(conflictList!=nil && conflictList.count>0){
        //need to handle session confiction
    }
    
    if([userJoinList containsObject:session.sessionID]){
        [userJoinList removeObject:session.sessionID];
        [joinButton setImage:[UIImage imageNamed:@"join_button.png"] forState:UIControlStateNormal];
        [sessionTitleLabel setTextColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f]];
        [sessionTimeLabel setTextColor:[UIColor colorWithRed:78/255.0 green:78/255.0 blue:78/255.0 alpha:1.0f]];
        [AppHelper showInfoView:self.view withText:@"Cancelled!" withLoading:NO];
    }else{
        UserPath *path=[[UserPath alloc]init];
        [path setPathID:[AppHelper generateUDID]];
        [path setPathContent:[NSString stringWithFormat:@"Join %@", session.sessionTitle]];
        [path setPathCreateTime:[NSDate date]];
        [path save];
        [path release];
        
        [userJoinList addObject:session.sessionID];
        [joinButton setImage:[UIImage imageNamed:@"unjoin_button.png"] forState:UIControlStateNormal];
        [sessionTitleLabel setTextColor:[UIColor colorWithRed:214/255.0 green:95/255.0 blue:54/255.0 alpha:1.0f]];
        [sessionTimeLabel setTextColor:[UIColor colorWithRed:214/255.0 green:95/255.0 blue:54/255.0 alpha:1.0f]];
        [AppHelper showInfoView:self.view withText:@"Joined!" withLoading:NO];
    }
    
    UITextView *detailTitleView=(UITextView *)[cell viewWithTag:tag_cell_session_detail_title_view];
    if(detailTitleView!=nil){
        [detailTitleView setTextColor:sessionTitleLabel.textColor];
    }
    
    [appDelegate saveUserState];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];
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
        Agenda *agenda=[self.agendaList objectAtIndex:self.selectedCell.section];
        Session *session=[agenda.sessions objectAtIndex:self.selectedCell.row];
        CGSize size=[session.sessionNote sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(320, 100) lineBreakMode:UILineBreakModeWordWrap];
        CGSize titleSize=[session.sessionTitle sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(310, 100)];
        float height=110+titleSize.height+size.height;
        return height;
    }else{
        return 50.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    
    Agenda *agenda=[self.agendaList objectAtIndex:section];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setLocale:locale];
    [locale release];
    [dateFormatter setDateFormat:@"d"];
    
    UILabel *monthLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 40, 24)];
    [monthLabel setBackgroundColor:[UIColor clearColor]];
    [monthLabel setTextColor:[UIColor colorWithRed:29/255.0 green:207/255.0 blue:219/255.0 alpha:1.0f]];
    [monthLabel setFont:[UIFont systemFontOfSize:30.0f]];
    [monthLabel setText:[dateFormatter stringFromDate:agenda.agendaDate]];
    [view addSubview:monthLabel];
    [monthLabel release];
    
    [dateFormatter setDateFormat:@"MMM, yyyy"];;
    UILabel *dateLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 20, 80, 20)];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTextColor:[UIColor colorWithRed:29/255.0 green:207/255.0 blue:219/255.0 alpha:1.0f]];
    [dateLabel setFont:[UIFont systemFontOfSize:15.0f]];
    NSString *text=[dateFormatter stringFromDate:agenda.agendaDate];
    text=[text uppercaseString];
    [dateLabel setText:text];
    [view addSubview:dateLabel];
    [dateLabel release];
    
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.refreshView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    loading=YES;
    [self getAgendaListFromServer:(NSString *)kServiceLoadSessionList showLoading:YES];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return loading;
}
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}

#pragma mark - Netowork callback method
- (void)requestFinished:(ASIHTTPRequest *)request{
    if(request.tag==tag_req_load_session_list){
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSString *resp = [request responseString];
        resp=[resp stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        resp=[resp stringByReplacingOccurrencesOfString:@"'" withString:@"\'"];
        NSMutableArray *receivedObjects = [parser objectWithString:resp];
        [parser release];
        
        if(receivedObjects.count>0){
            [self.agendaList removeAllObjects];
            [DBService deleteAllSessions];
            
            for (NSDictionary *object in receivedObjects) {
                Agenda *agenda = [Agenda createAgenda:object];
                [self.agendaList addObject:agenda];
                [DBService saveSessionList:agenda.sessions];
            }
            
            [self.agendaTable reloadData];
            [self updateTopSession];
        }
        
        loading=NO;
        [AppHelper removeInfoView:self.view];
        
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agendaTable];
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    if(request.tag==tag_req_load_session_list){
        NSLog(@"%@", [request.error localizedDescription]);
        [AppHelper removeInfoView:self.view];
        loading=NO;
        [self.refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.agendaTable];
        [AppHelper showInfoView:self.view withText:@"Failed" withLoading:NO];
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeInfoView) userInfo:nil repeats:NO];
    }
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
    [_reminderList release];
}

@end
