//
//  TaskHelper.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-4.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TaskCompleteDelegate<NSObject>
@optional
- (void)taskComplete;
@end

@interface TaskHelper : NSObject

@property (atomic, assign) int nTaskInProcess;
@property (nonatomic, weak) id<TaskCompleteDelegate> delegate;

-(id)initWithDelegate:(id<TaskCompleteDelegate>)del;
-(void) pushTask;
-(void) popTask;
-(void) clearTask;
@end
