//
//  MainViewModel.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "MainViewModel.h"
#import "ItemViewModel.h"
#import "Three20Core/NSArrayAdditions.h"
#import "SoundTool.h"

static MainViewModel * sharedInstance = nil;

@interface MainViewModel ()
@property (strong, nonatomic) RefreshViewerHelper* refreshViewerHelper;
@end

@implementation MainViewModel

@synthesize refreshViewerHelper;

+(MainViewModel *)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
            sharedInstance.refreshViewerHelper = [[RefreshViewerHelper alloc] initWithDelegate:sharedInstance];
        }
    }
    return sharedInstance;
}

-(id)init
{
    if(!(self = [super init]))
    {        
        return nil;        
    }   
    _isLoading = false;
    self.items = [NSMutableArray arrayWithCapacity:100];
    self.listItems = [NSMutableArray arrayWithCapacity:100];
    self.sinaWeiboItems = [NSMutableArray arrayWithCapacity:50];
    self.renrenItems = [NSMutableArray arrayWithCapacity:50];
    self.doubanItems = [NSMutableArray arrayWithCapacity:50];
    self.rssItems = [NSMutableArray arrayWithCapacity:20];
    
    self.pictureItems = [NSMutableArray arrayWithCapacity:100];
    self.listPictureItems = [NSMutableArray arrayWithCapacity:100];
    self.sinaWeiboPictureItems = [NSMutableArray arrayWithCapacity:50];
    self.renrenPictureItems = [NSMutableArray arrayWithCapacity:50];
    self.doubanPictureItems = [NSMutableArray arrayWithCapacity:50];
    
    self.isChanged = true;
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TTModel implement
- (BOOL)isLoadingMore {
    return NO;
}

- (BOOL)isOutdated {
    return FALSE;
}

- (BOOL)isLoaded {
    return !_isLoading;
}

- (BOOL)isLoading {
    return _isLoading;
}

- (BOOL)isEmpty {
    return ![self.items count];
}


- (NSMutableArray*)delegates {
    if (!_delegates) {
        _delegates = TTCreateNonRetainingArray();
    }
    return _delegates;
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    NSLog(@"MainViewModel load");
    if(_isLoading)
        return;
    _isLoading = true;
    self.isChanged = false;
    // 加载开始
    [_delegates perform:@selector(modelDidStartLoad:) withObject:self];
    [refreshViewerHelper refreshMainViewModel];
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TTPhotoSource implement

- (id<TTPhoto>)photoAtIndex:(NSInteger)index
{
    if(index < self.pictureItems.count)
    {
        return [self.pictureItems objectAtIndex:index];
    }
    else
    {
        return nil;
    }
}

- (NSInteger)numberOfPhotos {
    return self.pictureItems.count;
}

- (NSInteger)maxPhotoIndex {
    return self.pictureItems.count - 1;
}

- (NSString*)title {
    return @"图片";
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RefreshViewer delegate

- (void)refreshComplete
{
    _isLoading = false;
    [SoundTool playSoundLoadComplete];
    // 加载完毕
    [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
}
@end
