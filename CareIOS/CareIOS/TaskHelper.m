//
//  TaskHelper.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-4.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TaskHelper.h"
#import "RefreshViewerHelper.h"
@implementation TaskHelper
@synthesize nTaskInProcess;
@synthesize delegate;

-(id)init
{
    if(!(self = [super init]))
    {
        return nil;
    }
    nTaskInProcess = 0;
    return self;
}

-(id)initWithDelegate:(id<TaskCompleteDelegate>)del
{
    if(!(self = [super init]))
    {
        return nil;
    }
    nTaskInProcess = 0;
    delegate = del;
    return self;
}

-(void) pushTask
{
    self.nTaskInProcess++;
}

-(void) popTask
{
    if(nTaskInProcess == 0)
        return;
    if(--nTaskInProcess == 0)
    {
        if ( delegate != nil && [delegate respondsToSelector:@selector(taskComplete)])
        {
            [delegate taskComplete];
        }        
    }    
}
@end
