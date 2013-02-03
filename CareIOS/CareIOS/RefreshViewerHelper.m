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
#import "RenrenConverter.h"
#import "DoubanConverter.h"
#import "RSSFeedConverter.h"
#import "MainViewModel.h"
#import "TaskHelper.h"
#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"
#import "LocalStorageHelper.h"
#import "PreferenceHelper.h"


@interface RefreshViewerHelper ()
@property (strong, nonatomic) MainViewModel* mainViewModel;
@end


@implementation RefreshViewerHelper
@synthesize mainViewModel;
@synthesize m_taskHelper;
@synthesize delegate;
@synthesize feedParser;
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
    if(mainViewModel.items == nil)
    {
        mainViewModel.items = [NSMutableArray arrayWithCapacity:100];
    }
    [mainViewModel.items removeAllObjects];
    [mainViewModel.listItems removeAllObjects];
    [mainViewModel.pictureItems removeAllObjects];
    [mainViewModel.listPictureItems removeAllObjects];
    
    // 1.状态部分
    [mainViewModel.listItems addObjectsFromArray:mainViewModel.sinaWeiboItems];
    [mainViewModel.listItems addObjectsFromArray:mainViewModel.renrenItems];
    [mainViewModel.listItems addObjectsFromArray:mainViewModel.doubanItems];
    [mainViewModel.listItems addObjectsFromArray:mainViewModel.rssItems];
    
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
    
    
    [LocalStorageHelper saveToLoaclStorage];
    if ( delegate != nil && [delegate respondsToSelector:@selector(refreshComplete)])
    {
        [delegate refreshComplete];
    }
}


-(void)refreshMainViewModel
{
    [m_taskHelper pushTask];
    [m_taskHelper pushTask];
    [m_taskHelper pushTask];
    [m_taskHelper pushTask];

    [self refreshModelSinaWeibo];
    [self refreshModelRenren];
    [self refreshModelDouban];
    [self refreshModelRSS];
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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString* sinaWeiboToken = [defaults objectForKey:@"SinaWeibo_Token"];
    NSDate* sinaWeiboExpDate = [defaults objectForKey:@"SinaWeibo_ExpirationDate"];
    if(sinaWeiboToken != nil && [sinaWeiboExpDate compare:[NSDate date]] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"新浪微博授权已过期，请重新登陆的喵～" delegate:nil
                                              cancelButtonTitle:@"朕知道了喵～" otherButtonTitles:nil];
        [alert show];
        [PreferenceHelper clearSinaWeiboPreference];
        [m_taskHelper popTask];
        return;
    }
    
    SinaWeibo* sinaweibo = [self sinaweibo];    
    NSString* herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
    if( ![sinaweibo isAuthValid] || herID == nil)
    {
        [m_taskHelper popTask];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:herID forKey:@"uid"];
    // 新浪支持的最大为100

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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"由于未知原因，获取新浪微博失败，请确保网络畅通" delegate:nil
                                          cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
    [alert show];
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

#pragma mark - Renren Logic
- (Renren *)renren
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.renren;
}

- (void)refreshModelRenren
{
    [mainViewModel.renrenItems removeAllObjects];
    [mainViewModel.renrenPictureItems removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* renrenToken = [defaults objectForKey:@"Renren_Token"];
    NSDate* renrenExpDate = [defaults objectForKey:@"Renren_ExpirationDate"];
    if(renrenToken != nil && [renrenExpDate compare:[NSDate date]] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"人人授权已过期，请重新登陆的喵～" delegate:nil
                                              cancelButtonTitle:@"朕知道了喵～" otherButtonTitles:nil];
        [alert show];
        [PreferenceHelper clearRenrenPreference];
        [m_taskHelper popTask];
        return;
    }
    
    Renren* renren = [self renren];

    NSString* herID = [defaults objectForKey:@"Renren_FollowerID"];
    
    if( ![renren isSessionValid] || herID == nil)
    {
        [m_taskHelper popTask];
        return;
    }
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"feed.get" forKey:@"method"];
    [dic setObject:herID forKey:@"uid"];
    [dic setObject:@"50" forKey:@"count"];
    [dic setObject:@"10,30,32" forKey:@"type"];
    [renren requestWithParams:dic andDelegate:self];
}


#pragma mark - Renren Delegate
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    NSArray *statuses = (NSArray *)(response.rootObject);
    for(id status in statuses)
    {
        ItemViewModel* model = [RenrenConverter convertStatusToCommon:status];
        if(model != nil)
        {
            [mainViewModel.renrenItems addObject:model];
        }
    }
    [m_taskHelper popTask];    
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    [m_taskHelper popTask];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"由于未知原因，获取人人新鲜事失败，请确保网络畅通" delegate:nil
                                          cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
    [alert show];
}


static NSString * const kAPIKey = @"0ed6ec78c3bfd5cb2c84c56a4b3f8161";
static NSString * const kPrivateKey = @"e5cbdd30d10b1c5d";
static NSString * const kRedirectUrl = @"http://thankcreate.github.com/Care/callback.html";

#pragma mark - Douban Logic
- (void)refreshModelDouban
{
    [mainViewModel.doubanItems removeAllObjects];
    [mainViewModel.doubanPictureItems removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* doubanToken = [defaults objectForKey:@"Douban_Token"];
    NSDate* doubanExpDate = [defaults objectForKey:@"Douban_ExpirationDate"];
    // 如果过期，先请求刷新    
    if(doubanToken != nil && [doubanExpDate compare:[NSDate date]] == NSOrderedAscending)    
    {
        DOUOAuthService *service = [DOUOAuthService sharedInstance];
        service.authorizationURL = kTokenUrl;
        service.delegate = self;
        service.clientId = kAPIKey;
        service.clientSecret = kPrivateKey;
        service.callbackURL = kRedirectUrl;
        NSString* refreshToken = [defaults objectForKey:@"Douban_RefreshToken"];
        [service validateRefresh:refreshToken];
        return;
    }
    else
    {    
        DOUService *service = [DOUService sharedInstance];

        NSString* herID = [defaults objectForKey:@"Douban_FollowerID"];

        
        if( ![service isValid] || herID == nil)
        {
            [m_taskHelper popTask];
            return;
        }
            
        NSString* subPath = [NSString stringWithFormat:@"/shuo/v2/statuses/user_timeline/%@", herID];
        DOUQuery* query = [[DOUQuery alloc] initWithSubPath:subPath
                                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"30",@"count",nil]];
        
        DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
            NSError *error = [req error];
            
            if (!error) {
                id statues = [[req responseString] JSONValue];
                for(id status in statues)
                {
                    ItemViewModel* model = [DoubanConverter convertStatusUnion:status];
                    if(model != nil)
                    {
                        [mainViewModel.doubanItems addObject:model];
                    }
                }
                [m_taskHelper popTask];  
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                                message:@"由于未知原因，获取豆瓣广播失败，请确保网络畅通" delegate:nil
                                                      cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
                [alert show];
                [m_taskHelper popTask];
            }
        };
        
        service.apiBaseUrlString = [CareConstants doubanBaseAPI];
        [service get:query callback:completionBlock];
    }
}


- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [dic objectForKey:@"access_token"];
    NSString *douban_user_id = [dic objectForKey:@"douban_user_id"];
    NSNumber *expires_in = [dic objectForKey:@"expires_in"];
    NSString *refresh_token = [dic objectForKey:@"refresh_token"];
    
    NSTimeInterval seconds = [expires_in doubleValue];
    NSDate* expDate = [[NSDate date] dateByAddingTimeInterval:seconds];
    [defaults setValue:access_token forKey:@"Douban_Token"];
    [defaults setValue:douban_user_id forKey:@"Douban_ID"];
    [defaults setValue:expDate forKey:@"Douban_ExpirationDate"];
    [defaults setValue:refresh_token forKey:@"Douban_RefreshToken"];
    [defaults synchronize];
    [self refreshModelDouban];
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"豆瓣授权已过期，请重新登陆的喵～" delegate:nil
                                          cancelButtonTitle:@"朕知道了喵～" otherButtonTitles:nil];
    [alert show];
    [PreferenceHelper clearDoubanPreference];
    [m_taskHelper popTask];
    return;
}



#pragma mark - RSS logic
-(void)refreshModelRSS
{
    [mainViewModel.rssItems removeAllObjects];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* rssPath = [defaults objectForKey:@"RSS_FollowerPath"];
    if(rssPath == nil || rssPath.length == 0)
    {
        [m_taskHelper popTask];
        return;
    }
    NSURL *feedURL = [NSURL URLWithString:rssPath];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
}

#pragma mark MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    [mainViewModel.rssItems removeAllObjects];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    // 因为有时候在RSS设置页用户并没有等到title smmary信息回来，就已经退到另一页面了，所以每次这里都要设一下
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:parser.url.absoluteString forKey:@"RSS_FollowerPath"];
    [defaults setObject:info.title forKey:@"RSS_FollowerSiteTitle"];
    [defaults setObject:info.summary forKey:@"RSS_FollowerDescription"];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    ItemViewModel* model = [RSSFeedConverter convertFeedToCommon:item];
    if(model != nil)
    {
        [mainViewModel.rssItems addObject:model];
    }
}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    [m_taskHelper popTask];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {    
    [m_taskHelper popTask];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"由于未知原因，获取RSS订阅失败，请确保RSS地址正确，网络畅通" delegate:nil
                                          cancelButtonTitle:@"嗯，朕知道了～" otherButtonTitles:nil];
    [alert show];
    return;
}
@end
