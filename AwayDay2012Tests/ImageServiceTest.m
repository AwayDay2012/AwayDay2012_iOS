//
//  ImageServiceTest.m
//  AwayDay2012
//
//  Created by xuehai zeng on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageServiceTest.h"
#import "ImageService.h"

@implementation ImageServiceTest

-(void)testScaleImage{
    UIImage *image=[UIImage imageNamed:@"background.png"];
    UIImage *newImage=[ImageService scaleImage:image toResolution:10];
    STAssertTrue(newImage.size.width<=10,@"wrong scaled width");
    STAssertTrue(newImage.size.height<=10, @"wrong scaled height");
}

@end
