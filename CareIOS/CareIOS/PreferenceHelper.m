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
@end
