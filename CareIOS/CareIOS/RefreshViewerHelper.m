//
//  RefreshViewerHelper.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "RefreshViewerHelper.h"
#import "CareAppDelegate.h"
#import "SinaWeiboConverter.h"
#import "MainViewModel.h"
#import "TaskHelper.h"

@interface RefreshViewerHelper ()
@property (strong, nonatomic) MainViewModel* mainViewModel;
@end


@implementation RefreshViewerHelper
@synthesize mainViewModel;
@synthesize m_taskHelper;
@synthesize delegate;

-(id)initWithDelegate:(id<RefreshViewerDelegate>) del
{
    if(!(self = [super init]))
    {
        return nil;
    }
    mainViewModel = [MainViewModel sharedInstance];
    m_taskHelper = [[TaskHelper alloc] initWithDelegate:self];
    delegate = del;
    return self;
}

-(void)refreshViewItems
{
    [mainViewModel.items removeAllObjects];
    [mainViewModel.listItems removeAllObjects];
    [mainViewModel.pictureItems removeAllObjects];
    [mainViewModel.listPictureItems removeAllObjects];
    
    // 1.状态部分
    [mainViewModel.listItems addObjectsFromArray:mainViewModel.sinaWeiboItems];
    [mainViewModel.listItems addObjectsFromArray:mainViewModel.renrenItems];
    [mainViewModel.listItems addObjectsFromArray:mainViewModel.doubanItems];
    
    NSArray* temp = [mainViewModel.listItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* time1 = ((ItemViewModel*)(obj1)).time;
        NSDate* time2 = ((ItemViewModel*)(obj2)).time;
        NSComparisonResult res =  [time1 compare:time2];
        return -res;
    }];
    [mainViewModel.items addObjectsFromArray:temp];
    
    // 2.图片部分
    [mainViewModel.listPictureItems addObjectsFromArray:mainViewModel.sinaWeiboPictureItems];
    [mainViewModel.listPictureItems addObjectsFromArray:mainViewModel.renrenPictureItems];
    [mainViewModel.listPictureItems addObjectsFromArray:mainViewModel.doubanPictureItems];
    
    NSArray* temp2 = [mainViewModel.listPictureItems sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* time1 = ((PictureItemViewModel*)(obj1)).time;
        NSDate* time2 = ((PictureItemViewModel*)(obj2)).time;
        NSComparisonResult res =  [time1 compare:time2];
        return -res;
    }];
    [mainViewModel.pictureItems addObjectsFromArray:temp2];
    
    
    
    if ( delegate != nil && [delegate respondsToSelector:@selector(refreshComplete)])
    {
        [delegate refreshComplete];
    }
}


-(void)refreshMainViewModel
{
    [m_taskHelper pushTask];
    [self refreshModelSinaWeibo];
}




#pragma mark - SinaWeibo Logic
- (SinaWeibo *)sinaweibo
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.sinaweibo;
}

- (void)refreshModelSinaWeibo
{
    [mainViewModel.sinaWeiboItems removeAllObjects];
    [mainViewModel.sinaWeiboPictureItems removeAllObjects];
    
    SinaWeibo* sinaweibo = [self sinaweibo];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
    
    if( ![sinaweibo isAuthValid] || herID == nil)
        return;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:herID forKey:@"uid"];
    // 新浪支持的最大为100
    // TODO:
    [dic setObject:@"50" forKey:@"count"];
    
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:dic
                   httpMethod:@"GET"
                     delegate:self];

}


#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    [m_taskHelper popTask];    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        NSArray* statuses = [result objectForKey:@"statuses"];
        for(id status in statuses)
        {
            ItemViewModel* model = [SinaWeiboConverter convertStatusToCommon:status];
            if(model != nil)
            {
                [mainViewModel.sinaWeiboItems addObject:model];
            }        
        }
        [m_taskHelper popTask];
    }
}
#pragma mark - TaskComplete Delegate
- (void)taskComplete
{
    [self refreshViewItems];
}



@end
