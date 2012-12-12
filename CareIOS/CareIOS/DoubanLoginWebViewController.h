//
//  WebViewController.h
//  DoubanAPIEngineDemo
//
//  Created by Lin GUO on 3/26/12.
//  Copyright (c) 2012 douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOUOAuthService.h"


@protocol DoubanLoginDelegate

- (void)doubanDidLogin:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic;
- (void)doubanloginDidFail:(DOUOAuthService *)client didFailWithError:(NSError *)error;

@end

@interface DoubanLoginWebViewController : UIViewController<UIWebViewDelegate, DOUOAuthServiceDelegate>

- (id)initWithDelegate:(id<DoubanLoginDelegate>)inputDelegate;
@property(strong, nonatomic) id<DoubanLoginDelegate> delegate;

@end
