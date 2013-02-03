//
//  SinaWeiboSelectFriendViewController.h
//  CareIOS
//
//  Created by 谢 创 on 12-12-2.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "CareConstants.h"

@class Renren;
@interface SelectFriendViewController : UITableViewController<SinaWeiboRequestDelegate, RenrenDelegate,UISearchBarDelegate>
{
    
}

// 因为enum不是id类型，不能传递，这里要用个nsnumber包着
@property (copy, nonatomic) NSNumber* type;
@property (strong, nonatomic) Renren* renren;

@property (nonatomic) NSInteger currentDoubanIndex;


@end
