//
//  TTStatusTImeLineViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-4.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "RefreshViewerHelper.h"
#import "CareConstants.h"
@interface TTStatusTImeLineViewController  : TTTableViewController
<TTModelDelegate,UIActionSheetDelegate,TTPostControllerDelegate,
SinaWeiboRequestDelegate,RenrenDelegate>
{
    int lastSelectIndex;
    EntryType lastSelectPostType;
}

@end
