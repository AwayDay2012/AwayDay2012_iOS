//
//  SettingViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "AppDelegate.h"
#import "AppConstant.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize inputNameViewController = _inputNameViewController;

@synthesize userNameLabel = _userNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)goInputNameView:(id)sender{
    if(self.inputNameViewController == nil){
        InputNameViewController *tempView = [[InputNameViewController alloc] initWithNibName:@"InputNameViewController" bundle:nil];
        self.inputNameViewController = tempView;
        [tempView release];
    }
    [self presentModalViewController:self.inputNameViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Settings"];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *username = [delegate.userState objectForKey:kUserNameKey];
    [self.userNameLabel setText:username];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_inputNameViewController release];
    [_userNameLabel release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
