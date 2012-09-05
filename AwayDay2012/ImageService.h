//
//  ImageService.h
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageService : NSObject

+(UIImage *)scaleImage:(UIImage *)image toResolution:(int)resolution;

+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage *)image toSize:(CGSize)targetSize;

@end
