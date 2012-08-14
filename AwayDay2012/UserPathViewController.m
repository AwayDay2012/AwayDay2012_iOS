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

#define tag_view_table_child_view   10001
#define tag_view_table_path_image   tag_view_table_child_view+1
#define key_timer_table_cell        @"timer_key_cell"
#define key_timer_user_path         @"timer_key_path"
#define key_timer_path_image        @"timer_key_path_image"

@implementation UserPathViewController
@synthesize pathList=_pathList;
@synthesize userPathTable=_userPathTable;
@synthesize userNameLabel=_userNameLabel;
@synthesize userRecordsCountLabel=_userRecordsCountLabel;
@synthesize operationQueue=_operationQueue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.pathList==nil){
        NSMutableArray *list=[[NSMutableArray alloc]initWithCapacity:0];
        self.pathList=list;
        [list release];
    }
    
    if(self.operationQueue==nil){
        NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        self.operationQueue=queue;
        [queue release];
    }
    [self.operationQueue setMaxConcurrentOperationCount:5];
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
-(IBAction)pathImageButtonPressed:(id)sender{
    UIButton *button=(UIButton *)sender;
    UITableViewCell *cell=(UITableViewCell *)[button superview];
    int index=[self.userPathTable indexPathForCell:cell].row;
    UserPath *userPath=[self.pathList objectAtIndex:index];
    UIImage *image=[userPath loadLocalPathImage];
    if(image!=nil){
        UIView *largeImageView=[[UIView alloc]initWithFrame:self.view.frame];
        
        UIView *back=[[UIView alloc]initWithFrame:self.view.frame];
        [back setBackgroundColor:[UIColor blackColor]];
        [back setAlpha:0.7f];
        [largeImageView addSubview:back];
        [back release];
        
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.frame];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImage:image];
        [imageView setUserInteractionEnabled:YES];
        [imageView setMultipleTouchEnabled:YES];
        [largeImageView addSubview:imageView];
        [imageView release];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [largeImageView addGestureRecognizer:tap];
        [tap release];
        
        [self.view addSubview:largeImageView];
        [largeImageView release];
    }
}

-(IBAction)handleTapGesture:(UITapGestureRecognizer *)sender{
    [sender.view removeFromSuperview];
}

#pragma mark - util method
-(void)loadUserActivity{
    [self.pathList removeAllObjects];
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
    [self.userPathTable reloadData];
}

-(void)buildPathCell:(UITableViewCell *)cell withPath:(UserPath *)path{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm"];
    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
    [timeLabel setTextAlignment:UITextAlignmentRight];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setTag:tag_view_table_child_view];
    [timeLabel setText:[formatter stringFromDate:path.pathCreateTime]];
    [timeLabel setTextColor:[UIColor colorWithRed:31/255.0 green:206/255.0 blue:217/255.0 alpha:1.0f]];
    [timeLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [cell addSubview:timeLabel];
    [timeLabel release];
    
    [formatter setDateFormat:@"MM-dd"];
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 26, 50, 20)];
    [dateLabel setTextColor:[UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0f]];
    [dateLabel setTag:tag_view_table_child_view];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setTextAlignment:UITextAlignmentRight];
    [dateLabel setText:[formatter stringFromDate:path.pathCreateTime]];
    [dateLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
    [cell addSubview:dateLabel];
    [dateLabel release];
    
    [formatter release];
    
    UIView *seperator=[[UIView alloc]initWithFrame:CGRectMake(65, 0, 2, 70)];
    if(path.hasImage!=nil && path.hasImage.boolValue && path.pathContent!=nil && path.pathContent.length>0){
        [seperator setFrame:CGRectMake(65, 0, 2, 120)];
    }
    [seperator setTag:tag_view_table_child_view];
    [seperator setBackgroundColor:[UIColor colorWithRed:186/255.0 green:233/255.0 blue:236/255.0 alpha:1.0f]];
    [cell addSubview:seperator];
    [seperator release];
    
    int y=5;
    
    if(path.pathContent!=nil && path.pathContent.length>0){
        UITextView *pathContent=[[UITextView alloc]initWithFrame:CGRectMake(67, y, 250, 50)];
        [pathContent setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"path_content_back.png"]]];
        [pathContent setText:path.pathContent];
        [pathContent setTag:tag_view_table_child_view];
        [pathContent setUserInteractionEnabled:NO];
        [pathContent setFont:[UIFont systemFontOfSize:14.0f]];
        [pathContent setTextColor:[UIColor blackColor]];
        [cell addSubview:pathContent];
        [pathContent release];
        y=60;
    }
    
    if(path.hasImage!=nil && path.hasImage.boolValue){
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button.imageView setClipsToBounds:YES];
        [button setFrame:CGRectMake(70, y, 240,60)];
        [button setTag:tag_view_table_path_image];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [button setAdjustsImageWhenHighlighted:NO];
        [cell addSubview:button];
        
        UIImage *image=[path loadLocalPathImage];
        if(image!=nil){
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pathImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            //to load the image from server
        }
    }
}

#pragma mark - UITableView method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.pathList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserPath *userPath=[self.pathList objectAtIndex:indexPath.row];
    if(userPath.hasImage!=nil && userPath.hasImage.boolValue && userPath.pathContent!=nil && userPath.pathContent.length>0){
        return 120.0f;
    }
    return 70.0f;
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle==UITableViewCellEditingStyleDelete){
        UserPath *userPath=[self.pathList objectAtIndex:indexPath.row];
        [userPath drop];
        [self.pathList removeObjectAtIndex:indexPath.row];
        [self.userPathTable reloadData];
        [self.userRecordsCountLabel setText:[NSString stringWithFormat:@"has %d records", self.pathList.count]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_pathList release];
    [_userPathTable release];
    [_userNameLabel release];
    [_userRecordsCountLabel release];
    [self.operationQueue cancelAllOperations];
    [_operationQueue release];
}

@end
