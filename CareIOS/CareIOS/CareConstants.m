//
//  Constants.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "CareConstants.h"

@implementation CareConstants
+(NSString*)doubanBaseAPI
{
    return @"https://api.douban.com";
}

+(NSString*)doubanAppKey
{
    return @"0ed6ec78c3bfd5cb2c84c56a4b3f8161";
}

+(UIColor*)headerColor
{
    // this is because iOS7 has changed the color behaviours in navigationBar
    // for more info: https://developer.apple.com/library/ios/documentation/userexperience/conceptual/TransitionGuide/Bars.html
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        //return [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
        return [UIColor whiteColor];
    }
    else
    {
        return RGBCOLOR(200, 12, 40);
    }
}

+(UIColor*)labPink;
{
    return RGBACOLOR(255, 102, 102, 0.8);
}
@end
