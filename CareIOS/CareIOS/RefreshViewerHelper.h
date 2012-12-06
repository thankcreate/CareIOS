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

@protocol RefreshViewerDelegate<NSObject>
@required
- (void)refreshComplete;
@end

@interface RefreshViewerHelper : NSObject<SinaWeiboRequestDelegate, TaskCompleteDelegate>

- (void)taskComplete;
-(id)initWithDelegate:(id<RefreshViewerDelegate>)del;
-(void)refreshMainViewModel;
@property (strong, atomic) TaskHelper* m_taskHelper;
@property (weak, nonatomic) id<RefreshViewerDelegate> delegate;
@end