//
//  MenuViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize tapImageView=_tapImageView;
@synthesize chooseFlagImageView=_chooseFlagImageView;
@synthesize agendaViewButton=_agendaViewButton;
@synthesize pathViewButton=_pathViewButton;
@synthesize settingViewButton=_settingViewButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self.tapImageView addGestureRecognizer:tap];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [tap release];
    
    [self.chooseFlagImageView setFrame:CGRectMake(0, 38, 4, 43)];
    
    UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipe];
    [swipe release];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipe];
    [swipe release];
    
    UIImageView *agendaViewIcon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 16, 16)];
    [agendaViewIcon setAlpha:1.0f];
    [agendaViewIcon setImage:[UIImage imageNamed:@"agenda_view_icon.png"]];
    [self.agendaViewButton addSubview:agendaViewIcon];
    [agendaViewIcon release];
    
    UIImageView *pathViewIcon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 16, 16)];
    [pathViewIcon setAlpha:0.5f];
    [pathViewIcon setImage:[UIImage imageNamed:@"path_view_icon.png"]];
    [self.pathViewButton addSubview:pathViewIcon];
    [pathViewIcon release];
    
    UIImageView *settingViewIcon=[[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 16, 16)];
    [settingViewIcon setAlpha:0.5f];
    [settingViewIcon setImage:[UIImage imageNamed:@"setting_view_icon.png"]];
    [self.settingViewButton addSubview:settingViewIcon];
    [settingViewIcon release];
    
    [self.agendaViewButton setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.pathViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.settingViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
}

#pragma mark - UIAction method
-(IBAction)agendaButtonPressed:(id)sender{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.agendaViewController] animated:NO];
    
    [self.chooseFlagImageView setFrame:CGRectMake(0, 38, 4, 43)];
    [self.agendaViewButton setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.pathViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.settingViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
    
    for(UIView *view in self.agendaViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:1.0f];
        }
    }
    for(UIView *view in self.pathViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:0.5f];
        }
    }
    for(UIView *view in self.settingViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:0.5f];
        }
    }
}
-(IBAction)myPathButtonPressed:(id)sender{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.userPathViewController] animated:NO];
    [self.chooseFlagImageView setFrame:CGRectMake(0, 83, 4, 43)];
    [self.agendaViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.pathViewButton setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.settingViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
    
    for(UIView *view in self.agendaViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:0.5f];
        }
    }
    for(UIView *view in self.pathViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:1.0f];
        }
    }
    for(UIView *view in self.settingViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:0.5f];
        }
    }
}
-(IBAction)settingButtonPressed:(id)sender{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.navigationController setViewControllers:[NSArray arrayWithObject:appDelegate.settingViewController] animated:NO];
    [self.chooseFlagImageView setFrame:CGRectMake(0, 123, 4, 43)];
    [self.agendaViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.pathViewButton setTitleColor:[UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.settingViewButton setTitleColor:[UIColor colorWithRed:79/255.0 green:79/255.0 blue:79/255.0 alpha:1.0f] forState:UIControlStateNormal];
    
    for(UIView *view in self.agendaViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:0.5f];
        }
    }
    for(UIView *view in self.pathViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:0.5f];
        }
    }
    for(UIView *view in self.settingViewButton.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view setAlpha:1.0f];
        }
    }
}

-(IBAction)handleTapGesture:(UITapGestureRecognizer *)sender{
    [UIView beginAnimations:@"Move" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.1f];
    if(self.view.frame.origin.y>400){
        [self.view setFrame:CGRectMake(0, 320,self.view.frame.size.width, self.view.frame.size.height)];
    }else{
        [self.view setFrame:CGRectMake(0, 450, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [UIView commitAnimations];
}
-(IBAction)handleSwipeGesture:(UISwipeGestureRecognizer *)sender{
    [self handleTapGesture:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_tapImageView release];
    [_chooseFlagImageView release];
    [_agendaViewButton release];
    [_pathViewButton release];
    [_settingViewButton release];
}

@end
