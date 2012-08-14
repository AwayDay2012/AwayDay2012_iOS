//
//  ImageService.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageService.h"

@implementation ImageService

+(UIImage *)scaleImage:(UIImage *)image toResolution:(int)resolution{
    UIImage *img=nil;
    
    CGImageRef imgRef = [image CGImage];
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    //if already at the minimum resolution, return the orginal image, otherwise scale
    if (width <= resolution && height <= resolution) {
        img=image;
    } else {
        CGFloat ratio = width/height;
        
        if (ratio > 1) {
            bounds.size.width = resolution;
            bounds.size.height = bounds.size.width / ratio;
        } else {
            bounds.size.height = resolution;
            bounds.size.width = bounds.size.height * ratio;
        }
        
        UIGraphicsBeginImageContext(bounds.size);
        [image drawInRect:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return img;
}

@end
