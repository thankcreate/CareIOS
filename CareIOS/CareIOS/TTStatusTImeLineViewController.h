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
#import "MWPhotoBrowser.h"
@class TTStatusTImeDragRefreshDelegate;
@interface TTStatusTImeLineViewController  : TTTableViewController
<TTModelDelegate,UIActionSheetDelegate,TTPostControllerDelegate, UIAlertViewDelegate,
SinaWeiboRequestDelegate,RenrenDelegate, MWPhotoBrowserDelegate>
{
    int lastSelectIndex;
    EntryType lastSelectPostType;
}

// for MWPhotoBrowserDelegate use
@property (strong, nonatomic) NSMutableArray* photos;
@property (strong, nonatomic) TTStatusTImeDragRefreshDelegate* myTTStatusTImeDragRefreshDelegate;

@end
