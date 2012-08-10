//
//  InputNameViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputNameViewController : UIViewController

@property(nonatomic, retain) IBOutlet UITextField *userNameField;

-(IBAction)inputDoneButtonPressed:(id)sender;

@end
