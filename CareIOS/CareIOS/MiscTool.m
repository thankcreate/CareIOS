//
//  MiscTool.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-4.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "MiscTool.h"
#import <Three20/Three20.h>

@implementation MiscTool
+(NSString*)convertDateToString:(NSDate*)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];           
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss "];    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString*)getHerIcon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herIcon = [defaults objectForKey:@"SinaWeibo_FollowerAvatar2"];
    if(herIcon)
    {
        return herIcon;
    }
    
    herIcon = [defaults objectForKey:@"Renren_FollowerAvatar2"];
    if(herIcon)
    {
        return herIcon;
    }
    
    herIcon = [defaults objectForKey:@"Douban_FollowerAvatar2"];
    if(herIcon)
    {
        return herIcon;
    }
    
    herIcon = [defaults objectForKey:@"SinaWeibo_FollowerAvatar"];
    if(herIcon)
    {
        return herIcon;
    }
    
    herIcon = [defaults objectForKey:@"Renren_FollowerAvatar"];
    if(herIcon)
    {
        return herIcon;
    }
    
    herIcon = [defaults objectForKey:@"Douban_FollowerAvatar"];
    if(herIcon)
    {
        return herIcon;
    }
    return nil;
}


+(NSString*)getMyIcon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* myIcon = [defaults objectForKey:@"SinaWeibo_Avatar"];
    if(myIcon)
    {
        return myIcon;
    }
    myIcon = [defaults objectForKey:@"Renren_Avatar"];
    if(myIcon)
    {
        return myIcon;
    }
    myIcon = [defaults objectForKey:@"Douban_Avatar"];
    if(myIcon)
    {
        return myIcon;
    }
    return myIcon;
}



+(NSString*)getHerName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herName = [defaults objectForKey:@"SinaWeibo_FollowerNickName"];
    if(herName)
    {
        return herName;
    }
    
    herName = [defaults objectForKey:@"Renren_FollowerNickName"];
    if(herName)
    {
        return herName;
    }
    
    herName = [defaults objectForKey:@"Douban_FollowerNickName"];
    if(herName)
    {
        return herName;
    }
    return nil;
}

+(NSString*)getMyName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* myName = [defaults objectForKey:@"SinaWeibo_NickName"];
    if(myName)
    {
        return myName;
    }
    
    myName = [defaults objectForKey:@"Renren_NickName"];
    if(myName)
    {
        return myName;
    }
    
    myName = [defaults objectForKey:@"Douban_NickName"];
    if(myName)
    {
        return myName;
    }
    return nil;
}


+(NSString*)getHerSinaWeiboIcon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herIcon = [defaults objectForKey:@"SinaWeibo_FollowerAvatar2"];
    if(herIcon)
    {
        return herIcon;
    }
    
    
    herIcon = [defaults objectForKey:@"SinaWeibo_FollowerAvatar"];
    if(herIcon)
    {
        return herIcon;
    }
    return herIcon;
}

+(NSString*)getHerSinaWeiboName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herName = [defaults objectForKey:@"SinaWeibo_FollowerNickName"];
    if(herName)
    {
        return herName;
    }
    return @"";
}


+(NSString*)getHerRenrenIcon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herIcon = [defaults objectForKey:@"Renren_FollowerAvatar2"];
    if(herIcon)
    {
        return herIcon;
    }
    
    
    herIcon = [defaults objectForKey:@"Renren_FollowerAvatar"];
    if(herIcon)
    {
        return herIcon;
    }
    return herIcon;
}

+(NSString*)getHerRenrenName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herName = [defaults objectForKey:@"Renren_FollowerNickName"];
    if(herName)
    {
        return herName;
    }
    return @"";
}

+(NSString*)getHerDoubanIcon
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herIcon = [defaults objectForKey:@"Douban_FollowerAvatar2"];
    if(herIcon)
    {
        return herIcon;
    }
    
    
    herIcon = [defaults objectForKey:@"Douban_FollowerAvatar"];
    if(herIcon)
    {
        return herIcon;
    }
    return herIcon;
}


+(NSString*)getHerDoubanName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herName = [defaults objectForKey:@"Douban_FollowerNickName"];
    if(herName)
    {
        return herName;
    }
    return @"";
}


+(BOOL)isAnyOneFollowed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* renrenID = [defaults objectForKey:@"Renren_FollowerID"];
    NSString* sinaWeiboID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
    NSString* doubanID = [defaults objectForKey:@"Douban_FollowerID"];
    if(renrenID == nil && sinaWeiboID == nil && doubanID == nil)
    {
        return FALSE;
    }
    return TRUE;    
}

+(NSString *) removeHTMLTag:(NSString*)input
{
    if(input == nil)
        return nil;
    NSRange r;
    NSString *s = [input copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

+(NSString *) removeDoubanScoreTag:(NSString*)input
{
    if(input == nil)
        return nil;
    NSRange r;
    
    NSString *s = [input copy];
    r = [s rangeOfString:@"^.*?(?=\\[)" options:NSRegularExpressionSearch];
    if(r.location != NSNotFound)
        return [s substringWithRange:r];
    return s;
}

+(NSString *) getFileName:(NSString*)input
{
    if(input == nil)
        return @"";
    NSString* fileName = @"";
    @try {
        
        NSArray *linkSeperated = [input componentsSeparatedByString:@"/"];
        fileName = [linkSeperated lastObject];
    }
    @catch (NSException *exception) {
        fileName = @"";
    }
    return fileName;

}

+(BOOL) isNilOrEmpty:(NSString*)input
{
    if(input == nil || [input length] == 0)
        return YES;
    return NO;
}

+(void)gotoReviewPage
{
    NSString* appID = @"588950071";
    NSString* navStr = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:navStr]];
}

+(void)setHeader:(UIViewController*)controller
{
    // this is because iOS7 has changed the color behaviours in navigationBar
    // for more info: https://developer.apple.com/library/ios/documentation/userexperience/conceptual/TransitionGuide/Bars.html
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        // Three20's TTBaseViewController will save statusBarStyle as a property
        // and refresh it in viewWillAppear
        if([controller isKindOfClass:[TTBaseViewController class]])
        {
            TTBaseViewController* ttController = (TTBaseViewController*) controller;
            ttController.statusBarStyle = UIStatusBarStyleLightContent;
        }
        controller.navigationController.navigationBar.barTintColor = RGBACOLOR(255, 0, 0, 1);
        controller.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        controller.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor : [UIColor whiteColor]};
    }
    else
    {
        controller.navigationController.navigationBar.tintColor = [CareConstants headerColor];
    }
}

+(void)autoAdjuctScrollView:(UIScrollView*)scrollView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGRect originalBounds = scrollView.bounds;
        scrollView.bounds = CGRectMake(originalBounds.origin.x, -64, originalBounds.size.width, originalBounds.size.height);
        scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
    }
    else
    {
        // Nothing
    }
}
@end
