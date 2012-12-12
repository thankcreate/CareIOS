//
//  PreferenceHelper.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "PreferenceHelper.h"

@implementation PreferenceHelper
+(void) clearSinaWeiboPreference
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"SinaWeibo_Token"];
    [defaults removeObjectForKey:@"SinaWeibo_ExpirationDate"];
    [defaults removeObjectForKey:@"SinaWeibo_ID"];
    [defaults removeObjectForKey:@"SinaWeibo_NickName"];
    [defaults removeObjectForKey:@"SinaWeibo_Avatar"];
    
    [defaults removeObjectForKey:@"SinaWeibo_FollowerID"];
    [defaults removeObjectForKey:@"SinaWeibo_FollowerNickName"];
    [defaults removeObjectForKey:@"SinaWeibo_FollowerAvatar"];
    [defaults removeObjectForKey:@"SinaWeibo_FollowerAvatar2"];

}

+(void) clearRenrenPreference
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"Renren_Token"];
    [defaults removeObjectForKey:@"Renren_ExpirationDate"];
    [defaults removeObjectForKey:@"Renren_ID"];
    [defaults removeObjectForKey:@"Renren_NickName"];
    [defaults removeObjectForKey:@"Renren_Avatar"];
    
    [defaults removeObjectForKey:@"Renren_FollowerID"];
    [defaults removeObjectForKey:@"Renren_FollowerNickName"];
    [defaults removeObjectForKey:@"Renren_FollowerAvatar"];
    [defaults removeObjectForKey:@"Renren_FollowerAvatar2"];   
}

+(void) clearDoubanPreference
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"Douban_Token"];
    [defaults removeObjectForKey:@"Douban_ExpirationDate"];
    [defaults removeObjectForKey:@"Douban_ID"];
    [defaults removeObjectForKey:@"Douban_NickName"];
    [defaults removeObjectForKey:@"Douban_Avatar"];
    
    [defaults removeObjectForKey:@"Douban_FollowerID"];
    [defaults removeObjectForKey:@"Douban_FollowerNickName"];
    [defaults removeObjectForKey:@"Douban_FollowerAvatar"];
    [defaults removeObjectForKey:@"Douban_FollowerAvatar2"];
}
@end
