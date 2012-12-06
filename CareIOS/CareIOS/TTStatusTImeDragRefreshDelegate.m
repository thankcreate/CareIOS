//
//  TTStatusTImeDragRefreshDelegate.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-5.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTStatusTImeDragRefreshDelegate.h"
#import "MainViewModel.h"
#import "Three20/Three20.h"
@implementation TTStatusTImeDragRefreshDelegate

- (id)initWithController:(TTTableViewController*)controller {
	self = [super initWithController:controller];
    if (self) {
        _model = [MainViewModel sharedInstance];
        [_model.delegates addObject:self];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView {
    [super scrollViewDidScroll:scrollView];
}



- (void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelDelegate


- (void)modelDidStartLoad:(id<TTModel>)model {
    [super modelDidStartLoad:model];
}

- (void)modelDidFinishLoad:(id<TTModel>)model
{
//    _controller
    [super modelDidFinishLoad:model];
}
@end
