//
//  AppConstant.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppConstant.h"

@implementation AppConstant

NSString const *kUserNameKey=@"user_name";
NSString *kUserPathImageFolder=@"user_path_image";

NSString const *kSessionIDKey=@"session_id";
NSString const *kSessionTitleKey=@"settion_title";
NSString const *kSessionDescriptionKey=@"session_description";
NSString const *kSessionSpeakerKey=@"session_speaker";
NSString const *kSessionStartKey=@"session_start";
NSString const *kSessionEndKey=@"session_end";
NSString const *kSessionLocationKey=@"session_location";

NSString const *kShareImageKey=@"share_image";
NSString const *kDeviceIDKey=@"device_id";
NSString const *kShareTextKey=@"share_text";
NSString const *kTimastampKey=@"timestamp";

NSString const *kPathTextKey=@"text_content";
NSString const *kPathImageKey=@"image_content";

NSString const *kServiceLoadSessionList=@"http://awayday2012.herokuapp.com/sessions_grouped_by_date";
NSString *kServiceUserShare=@"http://awayday2012.herokuapp.com/share";
NSString *kServiceUserPath=@"http://awayday2012.herokuapp.com/moment";

@end
