//
//  PostShareViewController.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PostShareViewController.h"
#import "AppDelegate.h"
#import "UserPath.h"
#import "AppHelper.h"
#import "ImageService.h"

#define text_length_limit   140

@implementation PostShareViewController
@synthesize session=_session;
@synthesize textView=_textView;
@synthesize textCountLabel=_textCountLabel;
@synthesize imageIconView=_imageIconView;
@synthesize userImage=_userImage;
@synthesize sessionTextLabel=_sessionTextLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
    if(self.userImage==nil){
        self.imageIconView.alpha=0.0f;
    }
    
    if(self.session==nil){
        [self.sessionTextLabel setText:@""];
    }else{
        [self.sessionTextLabel setText:[NSString stringWithFormat:@"For %@", self.session.sessionTitle]];
    }
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate hideMenuView];
}
#pragma mark - UIAction method
-(IBAction)backButtonPressed:(id)sender{
    self.userImage=nil;
    [self.textView setText:@""];
    [self.navigationController popViewControllerAnimated:YES];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showMenuView];
}
-(IBAction)sendButtonPressed:(id)sender{
    //to send the share
    NSString *content=self.textView.text;
    if(content.length==0 && self.userImage==nil){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Input something please" message:@"you need to input something or put a photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    UserPath *userPath=[[UserPath alloc]init];
    [userPath setPathID:[AppHelper generateUDID]];
    [userPath setPathContent:content];
    if(self.userImage!=nil){
        [userPath setPathImage:self.userImage];
        [userPath setHasImage:[NSNumber numberWithBool:YES]];
    }else{
        [userPath setHasImage:[NSNumber numberWithBool:NO]];
    }
    [userPath save];
    [userPath release];
    
    self.userImage=nil;
    [self.textView setText:@""];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate showMenuView];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)addImageButtonPressed:(id)sender{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [actionSheet addButtonWithTitle:@"Take Photo"];
    }
    [actionSheet addButtonWithTitle:@"Choose from Album"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setDestructiveButtonIndex:0];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==actionSheet.numberOfButtons-1) return;
    
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    [picker setDelegate:self];
    
    if([[actionSheet buttonTitleAtIndex:buttonIndex] rangeOfString:@"Take"].length>0){
        //take photo
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    if([[actionSheet buttonTitleAtIndex:buttonIndex] rangeOfString:@"Album"].length>0){
        //select from album
        [picker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

#pragma mark - UITextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if(self.textView.text.length<text_length_limit){
        return YES;
    }else{
        return NO;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if(range.location>=text_length_limit){
        return NO;
    }else{
        return YES;
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if(text_length_limit==-1) return;
    if(self.textView.text.length==text_length_limit){
        self.textView.text=[self.textView.text substringWithRange:NSMakeRange(0, text_length_limit)];
    }
    [self.textCountLabel setText:[NSString stringWithFormat:@"%d/%d", self.textView.text.length, text_length_limit]];
}

#pragma UIImagePickerViewController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    @autoreleasepool {
        self.userImage= [info objectForKey:UIImagePickerControllerOriginalImage];
        self.userImage=[ImageService scaleImage:self.userImage toResolution:600];
    }
    [self.imageIconView setAlpha:1.0f];
    [picker dismissModalViewControllerAnimated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [_session release];
    [_textView release];
    [_textCountLabel release];
    [_imageIconView release];
    [_userImage release];
    [_sessionTextLabel release];
}

@end
