//
//  SettingViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

//  user settings view

#import <UIKit/UIKit.h>
#import "InputNameViewController.h"

@interface SettingViewController : UIViewController

@property (atomic, retain) InputNameViewController *inputNameViewController;

@property (atomic, retain) IBOutlet UILabel *userNameLabel;

-(IBAction)goInputNameView:(id)sender;

@end
