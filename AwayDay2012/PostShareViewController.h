//
//  PostShareViewController.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface PostShareViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(nonatomic, retain) Session *session;
@property(nonatomic, retain) UIImage *userImage;
@property(nonatomic, retain) IBOutlet UITextView *textView;
@property(nonatomic, retain) IBOutlet UILabel *textCountLabel;
@property(nonatomic, retain) IBOutlet UIImageView *imageIconView;

-(IBAction)backButtonPressed:(id)sender;
-(IBAction)sendButtonPressed:(id)sender;
-(IBAction)addImageButtonPressed:(id)sender;

@end
