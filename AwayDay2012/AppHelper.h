//
//  AppHelper.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AppHelper : NSObject

+(void)showInfoView:(UIView *)parentView;
+(void)showInfoView:(UIView *)parentView withText:(NSString *)text withLoading:(BOOL)withLoading;
+(void)removeInfoView:(UIView *)parentView;
+(NSString *)macaddress;
+(NSString *)md5:(NSString *)str;
+(NSString *)generateUDID;
+(NSString *)base64EncodeImage:(UIImage *)image;

@end
