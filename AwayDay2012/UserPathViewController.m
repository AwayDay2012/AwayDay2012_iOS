//
//  UserActivityViewControllerViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPathViewController.h"
#import "AppDelegate.h"
#import "DBService.h"
#import "AppConstant.h"
#import "UserPath.h"

#define tag_view_table_child_view   1001

@implementation UserPathViewController
@synthesize pathList=_pathList;
@synthesize userPathTable=_userPathTable;
@synthesize userNameLabel=_userNameLabel;
@synthesize userRecordsCountLabel=_userRecordsCountLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.pathList==nil){
        NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:0];
        self.pathList=list;
        [list release];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUserActivity];
    [self buildUI];
}

#pragma mark - UIAction method
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)addPathButtonPressed:(id)sender{
    
}

#pragma mark - util method
-(void)loadUserActivity{
    NSMutableArray *list=[UserPath getAllUserPath];
    if(list!=nil && list.count>0){
        [self.pathList removeAllObjects];
        [self.pathList addObjectsFromArray:list];
    }
}

-(void)buildUI{
    [self.userNameLabel.layer setMasksToBounds:YES];
    [self.userNameLabel.layer setCornerRadius:15.0f];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *userName=[appDelegate.userState objectForKey:kUserNameKey];
    [self.userNameLabel setText:userName];
    [self.userRecordsCountLabel setText:[NSString stringWithFormat:@"has %d records", self.pathList.count]];
}

-(void)buildPathCell:(UITableViewCell *)cell withPath:(UserPath *)path{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm"];
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
    [timeLabel setTextAlignment:UITextAlignmentRight];
    [timeLabel setTag:tag_view_table_child_view];
    [timeLabel setText:[formatter stringFromDate:path.pathCreateTime]];
    [timeLabel setTextColor:[UIColor colorWithRed:31/255.0 green:206/255.0 blue:217/255.0 alpha:1.0f]];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [cell addSubview:timeLabel];
    [timeLabel release];
    
    [formatter setDateFormat:@"dd, MM"];
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 50, 20)];
    [dateLabel setTextColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0f]];
    [dateLabel setTag:tag_view_table_child_view];
    [dateLabel setTextAlignment:UITextAlignmentRight];
    [dateLabel setText:[formatter stringFromDate:path.pathCreateTime]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [cell addSubview:dateLabel];
    [dateLabel release];
    
    UIView *seperator=[[UIView alloc]initWithFrame:CGRectMake(65, 0, 2, 80.0f)];
    [seperator setTag:tag_view_table_child_view];
    [seperator setBackgroundColor:[UIColor colorWithRed:186/255.0 green:233/255.0 blue:236/255.0 alpha:1.0f]];
    [cell addSubview:seperator];
    [seperator release];
    
    UITextView *pathContent=[[UITextView alloc]initWithFrame:CGRectMake(67, 5, 250, 50)];
    [pathContent setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"path_content_back.png"]]];
    [pathContent setText:path.pathContent];
    [pathContent setTag:tag_view_table_child_view];
    [pathContent setUserInteractionEnabled:NO];
    [pathContent setFont:[UIFont systemFontOfSize:14.0f]];
    [pathContent setTextColor:[UIColor blackColor]];
    [cell addSubview:pathContent];
    [pathContent release];
    
    [formatter release];
}

#pragma mark - UITableView method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pathList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    for(UIView *view in cell.subviews){
        if(view.tag==tag_view_table_child_view){
            [view removeFromSuperview];
        }
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UserPath *userPath=[self.pathList objectAtIndex:indexPath.row];
    [self buildPathCell:cell withPath:userPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_pathList release];
    [_userPathTable release];
    [_userNameLabel release];
    [_userRecordsCountLabel release];
}

@end
