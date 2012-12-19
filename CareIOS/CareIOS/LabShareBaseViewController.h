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
@interface LabShareBaseViewController : UIViewController<UIActionSheetDelegate, TTPostControllerDelegate,
SinaWeiboRequestDelegate, RenrenDelegate>
{
    EntryType lastSelectPostType;
    UIImage *screenShotImage;
}
@end
