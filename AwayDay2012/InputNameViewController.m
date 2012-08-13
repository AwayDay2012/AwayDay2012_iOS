//
//  InputNameViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InputNameViewController.h"
#import "AppDelegate.h"
#import "AppConstant.h"

@implementation InputNameViewController
@synthesize userNameField=_userNameField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate hideMenuView];
    [self.userNameField becomeFirstResponder];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showMenuView];
}

#pragma mark - UIAction method
-(IBAction)inputDoneButtonPressed:(id)sender{
    NSString *name=[self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(name.length==0){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input your name" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.userState setObject:self.userNameField.text forKey:kUserNameKey];
    [appDelegate saveUserState];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_userNameField release];
}

@end
