//
//  AppHelper.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppHelper.h"

#define tag_app_info_view   9999999

@implementation AppHelper

+(void)showInfoView:(UIView *)parentView{
    if(parentView==nil) return;
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 80)];
    [view setCenter:parentView.center];
    [view setTag:tag_app_info_view];
    [view setBackgroundColor:[UIColor clearColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:10.0f];
    
    UIView *back=[[UIView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [back setBackgroundColor:[UIColor blackColor]];
    [back setAlpha:0.7f];
    [view addSubview:back];
    [back release];
    
    UIActivityIndicatorView *loading=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loading setCenter:CGPointMake(view.frame.size.width/2, view.frame.size.height/3)];
    [view addSubview:loading];
    [loading startAnimating];
    [loading release];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setText:@"Loading"];
    [view addSubview:label];
    [label release];
    
    [parentView addSubview:view];
    
    [view release];
}
+(void)removeInfoView:(UIView *)parentView{
    if(parentView==nil) return;
    
    if([parentView viewWithTag:tag_app_info_view]!=nil){
        [[parentView viewWithTag:tag_app_info_view] removeFromSuperview];
    }
}

@end
