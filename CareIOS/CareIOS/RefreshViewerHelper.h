//
//  RefreshViewerHelper.h
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "TaskHelper.h"
#import "MWFeedParser.h"
#import "DOUOAuthService.h"

@protocol RefreshViewerDelegate<NSObject>
@required
- (void)refreshComplete;
@end

@interface RefreshViewerHelper : NSObject<SinaWeiboRequestDelegate,RenrenDelegate,MWFeedParserDelegate, TaskCompleteDelegate,DOUOAuthServiceDelegate>

- (void)taskComplete;
-(id)initWithDelegate:(id<RefreshViewerDelegate>)del;
-(void)refreshMainViewModel;
@property (strong, atomic) TaskHelper* m_taskHelper;
@property (nonatomic) id<RefreshViewerDelegate> delegate;

@property (strong, atomic) MWFeedParser *feedParser;
@end