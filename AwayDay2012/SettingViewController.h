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

@property (nonatomic, retain) InputNameViewController *inputNameViewController;
@property (nonatomic, retain) IBOutlet UILabel *userNameLabel;

-(IBAction)goInputNameView:(id)sender;

@end
