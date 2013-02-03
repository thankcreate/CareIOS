//
//  LabShareBaseViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-15.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "SinaWeibo.h"


@class TTStatusTImeDragRefreshDelegate;
// OC里不允许多重继承，LabShareBaseViewController的东西不能直接重用到LabSmartChatViewController
// 想来想去，一时找不到什么完美的解决方案，所以直接把代码复制过去了
// 以后在LabShareBaseViewController里所做的任何修改，务必同步到LabSmartChatViewController的相关部分
// 虽然这样做实在是不能丑陋得更多，但是我还想今天把智能聊天模块做完打dota去呢，先这么的吧^_^
// 我想佛祖会原谅我的
// 我真是不能屌丝得更多了，自己跟自己都能聊得high起来了
// 谁来救救我
// 停不下来了
@interface LabShareBaseViewController : UIViewController<UIActionSheetDelegate, TTPostControllerDelegate,
SinaWeiboRequestDelegate, RenrenDelegate>
{
    EntryType lastSelectPostType;
    UIImage *screenShotImage;
}
@end
