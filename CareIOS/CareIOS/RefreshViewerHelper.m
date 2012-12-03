//
//  RefreshViewerHelper.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "RefreshViewerHelper.h"
#import "CareAppDelegate.h"

@implementation RefreshViewerHelper

-(void)refreshMainViewModel
{
    // TODO
    [self refreshModelSinaWeibo];
}




#pragma mark - SinaWeibo Logic
- (SinaWeibo *)sinaweibo
{
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)refreshModelSinaWeibo
{
    SinaWeibo* sinaweibo = [self sinaweibo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
    
    if( ![sinaweibo isAuthValid] || herID == nil)
        return;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:herID forKey:@"uid"];
    // 新浪支持的最大为100
    // TODO:
    [dic setObject:@"50" forKey:@"count"];
    
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:dic
                   httpMethod:@"GET"
                     delegate:self];

}


#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request
didReceiveResponse:(NSURLResponse *)response;
{
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {

    }
}

@end
