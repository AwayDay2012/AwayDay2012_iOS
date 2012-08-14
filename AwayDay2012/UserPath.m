//
//  UserPath.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserPath.h"
#import "DBService.h"
#import "AppConstant.h"

@implementation UserPath
@synthesize pathID=_pathID;
@synthesize pathContent=_pathContent;
@synthesize pathCreateTime=_pathCreateTime;
@synthesize pathImage=_pathImage;
@synthesize hasImage=_hasImage;

-(void)save{
    if(self.pathImage!=nil){
        @autoreleasepool {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
            NSString *documentsDir = [paths objectAtIndex:0];
            documentsDir=[documentsDir stringByAppendingPathComponent:kUserPathImageFolder];
            
            NSFileManager *fileManager=[NSFileManager defaultManager];
            if(![fileManager fileExistsAtPath:documentsDir]){
                [fileManager createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            documentsDir=[documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.pathID]];
            
            NSData *data=UIImageJPEGRepresentation(self.pathImage, 0.9f);
            [data writeToFile:documentsDir atomically:YES];
        }
    }
    [DBService saveUserPath:self];
}

-(void)drop{
    [DBService deleteUserPath:self];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    documentsDir=[documentsDir stringByAppendingPathComponent:kUserPathImageFolder];
    documentsDir=[documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.pathID]];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:documentsDir]){
        [fileManager removeItemAtPath:documentsDir error:nil];
    }
}

+(NSMutableArray *)getAllUserPath{
    return [DBService getAllUserPath];
}

-(UIImage *)loadLocalPathImage{
    if(self.pathImage!=nil) return self.pathImage;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    documentsDir=[documentsDir stringByAppendingPathComponent:kUserPathImageFolder];
    documentsDir=[documentsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", self.pathID]];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:documentsDir]){
        NSData *data=[[NSData alloc] initWithContentsOfFile:documentsDir];
        self.pathImage=[UIImage imageWithData:data];
        [data release];
    }
    return self.pathImage;
}

-(void)dealloc{
    [_pathID release];
    [_pathContent release];
    [_pathCreateTime release];
    [_pathImage release];
    [_hasImage release];
    [super dealloc];
}

@end
