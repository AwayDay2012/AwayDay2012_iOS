//
//  MenuViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

//  the bottom menu view

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIImageView *tapImageView;
@property(nonatomic, retain) IBOutlet UIImageView *chooseFlagImageView;
@property(nonatomic, retain) IBOutlet UIButton *agendaViewButton;
@property(nonatomic, retain) IBOutlet UIButton *pathViewButton;
@property(nonatomic, retain) IBOutlet UIButton *settingViewButton;

-(IBAction)agendaButtonPressed:(id)sender;
-(IBAction)settingButtonPressed:(id)sender;
-(IBAction)myPathButtonPressed:(id)sender;

-(IBAction)handleTapGesture:(UITapGestureRecognizer *)sender;
-(IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender;

@end
