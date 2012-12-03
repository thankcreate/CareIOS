//
//  AccountViewController.h
//  CareIOS
//
//  Created by 谢 创 on 12-12-1.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Renren.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
@interface AccountViewController : UITableViewController<RenrenDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>

@end
