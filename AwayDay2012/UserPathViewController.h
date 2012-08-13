//
//  UserPathViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPathViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) NSMutableArray *pathList;
@property(nonatomic, retain) IBOutlet UILabel *userNameLabel;
@property(nonatomic, retain) IBOutlet UILabel *userRecordsCountLabel;
@property(nonatomic, retain) IBOutlet UITableView *userPathTable;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)addPathButtonPressed:(id)sender;

/**
 load user joined sessions
 */
-(void)loadUserActivity;

@end
