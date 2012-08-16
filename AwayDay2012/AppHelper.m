//
//  AppHelper.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppHelper.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>

#define tag_app_info_view   9999999

@implementation AppHelper

+(void)showInfoView:(UIView *)parentView{
    [self showInfoView:parentView withText:@"Loading..." withLoading:YES];
}

+(void)showInfoView:(UIView *)parentView withText:(NSString *)text withLoading:(BOOL)withLoading{
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
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width, 30)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [label setTextAlignment:UITextAlignmentCenter];
    [label setText:text];
    [view addSubview:label];
    [label release];
    
    if(withLoading){
        UIActivityIndicatorView *loading=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [loading setCenter:CGPointMake(view.frame.size.width/2, view.frame.size.height/3)];
        [view addSubview:loading];
        [loading startAnimating];
        [loading release];
    }else{
        [label setCenter:CGPointMake(label.center.x, view.frame.size.height-30)];
    }
    
    [parentView addSubview:view];
    
    [view release];
}

+(void)removeInfoView:(UIView *)parentView{
    if(parentView==nil) return;
    
    if([parentView viewWithTag:tag_app_info_view]!=nil){
        [[parentView viewWithTag:tag_app_info_view] removeFromSuperview];
    }
}

+(NSString *)macaddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    outstring=[outstring stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    return outstring;
}

+(NSString *)md5:(NSString *)str { 
    const char *cStr = [str UTF8String]; 
    unsigned char result[16]; 
    CC_MD5( cStr, strlen(cStr), result ); 
    return [NSString stringWithFormat: 
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7], 
            result[8], result[9], result[10], result[11], 
            result[12], result[13], result[14], result[15] 
            ]; 
}

+(NSString *)generateUDID{
    return [NSString stringWithFormat:@"%d", [NSDate timeIntervalSinceReferenceDate]];
}

@end
