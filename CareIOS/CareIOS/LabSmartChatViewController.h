//
//  LabSmartChatViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20UI/Three20UI.h>
#import "SinaWeibo.h"

@interface LabSmartChatViewController : TTTableViewController<UITextFieldDelegate, UIActionSheetDelegate, TTPostControllerDelegate,
SinaWeiboRequestDelegate, RenrenDelegate>
{
    EntryType lastSelectPostType;
    UIImage *screenShotImage;
}

@property (strong, nonatomic) NSMutableArray* chatList;
@property (nonatomic) CGRect originalRootView;
@end
