//
//  TTStatusTImeLineViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-4.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTStatusTImeLineViewController.h"
#import "MainViewModel.h"
#import "CareAppDelegate.h"
#import "TTStatusTImeDragRefreshDelegate.h"
#import "MiscTool.h"
#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"
#import "TTTableStatusItem.h"
#import "TTSectionedDataSource+CareCell.h"
#import "LocalStorageHelper.h"
#import "PreferenceHelper.h"
#import "MobClick.h"

@interface TTStatusTImeLineViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnPostStatus;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnRefresh;
@property (strong, nonatomic) MainViewModel* mainViewModel;
@property (strong, nonatomic) RefreshViewerHelper* refreshViewerHelper;
@end

@implementation TTStatusTImeLineViewController

@synthesize refreshViewerHelper;
@synthesize mainViewModel;
@synthesize photos;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super updateTableDelegate];
    
    // 检查是否需要弹出提示：是否好评
    [self showReviewDialogSmart];

    [MobClick event:@"TTStatusTImeLineViewController"];

    mainViewModel = [MainViewModel sharedInstance];
    [mainViewModel.delegates addObject:self];
    self.variableHeightRows = YES;
    
    self.tableViewStyle = UITableViewStylePlain;
    // 清除额外的分隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];

    self.btnPostStatus.width = 10.0f;
    self.btnRefresh.width = 10.0f;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile2.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // 加载缓存
    [LocalStorageHelper loadFromLocalStorage];
    [self modelDidFinishLoad:nil];
    
    // 检查是否过期
    [self checkOutOfDate];
}

-(void)showReviewDialogSmart
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* count = [defaults objectForKey:@"Global_LaunchCount"];
    if(count == nil)
    {
        [defaults setObject:[NSNumber numberWithInt:1] forKey:@"Global_LaunchCount"];
        [defaults synchronize];
    }
    else
    {
        int nCount = [count intValue];
        ++nCount;
        [defaults setObject:[NSNumber numberWithInt:nCount] forKey:@"Global_LaunchCount"];
        if(nCount == 3)
        {
            [defaults synchronize];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@">_<" message:@"主人使用我已经有一段时间了，喜欢的话能否给个好评呢？" delegate:self cancelButtonTitle:@"好评" otherButtonTitles:@"评你妹",nil];
            alert.tag = 250;
            alert.alertViewStyle=UIAlertViewStyleDefault;
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //该方法由UIAlertViewDelegate协议定义，在点击AlertView按钮时自动执行，所以如果这里再用alertView来弹出提//示，就会死循环，不停的弹AlertView
    if(alertView.tag != 250)
        return;
    if(buttonIndex == 0)
    {
        [MobClick event:@"GoReview"];
        [MiscTool gotoReviewPage];
    }
    else
    {
        [MobClick event:@"NotGoReview"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.tintColor = [CareConstants headerColor];    
    
    if(mainViewModel.isChanged )
    {
        [mainViewModel load:TTURLRequestCachePolicyNetwork more:NO];
    }
}

- (id<UITableViewDelegate>)createDelegate {
    self.myTTStatusTImeDragRefreshDelegate = [[TTStatusTImeDragRefreshDelegate alloc] initWithController:self] ;
    return self.myTTStatusTImeDragRefreshDelegate ;
}


-(void)checkOutOfDate
{
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
    }

    NSString* renrenToken = [defaults objectForKey:@"Renren_Token"];
    NSDate* renrenExpDate = [defaults objectForKey:@"Renren_ExpirationDate"];    
    if(renrenToken != nil && [renrenExpDate compare:[NSDate date]] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"人人授权已过期，请重新登陆的喵～" delegate:nil
                                              cancelButtonTitle:@"朕知道了喵～" otherButtonTitles:nil];
        [alert show];
        [PreferenceHelper clearRenrenPreference];
    }
    
    NSString* doubanToken = [defaults objectForKey:@"Douban_Token"];
    NSDate* doubanExpDate = [defaults objectForKey:@"Douban_ExpirationDate"];    
    if(doubanToken != nil && [doubanExpDate compare:[NSDate date]] == NSOrderedAscending)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"豆瓣授权已过期，请重新登陆的喵～" delegate:nil
                                              cancelButtonTitle:@"朕知道了喵～" otherButtonTitles:nil];
        [alert show];
        [PreferenceHelper clearDoubanPreference];
    }
}

#pragma mark - Event
- (IBAction)ButtonRefresh_Clicked:(id)sender
{
    [mainViewModel load:TTURLRequestCachePolicyNetwork more:NO];
}

- (IBAction)ButtonPostStatus_Clicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"发布平台"
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"新浪微博", @"人人网", @"豆瓣社区", nil];
  	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidFinishLoad:(id<TTModel>)model
{
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    for (ItemViewModel* model in mainViewModel.items)
    {
        TTTableStatusItem* item = [TTTableStatusItem itemWithTitle:model.title
                                                             caption:nil
                                                                text:model.content
                                                           timestamp:model.time
                                                            imageURL:model.iconURL
                                                                 URL:nil];
        item.thumbImageURL = model.imageURL;
        item.from = model.fromText;
        item.itemViewModel = model;
        
        // 转发
        if(model.forwardItem)
        {
            TTTableStatusItem* forwardItem = [TTTableStatusItem itemWithTitle:nil
                                                                        caption:nil
                                                                           text:model.forwardItem.contentWithTitle
                                                                      timestamp:model.time
                                                                       imageURL:model.forwardItem.iconURL
                                                                            URL:nil];
            forwardItem.thumbImageURL = model.forwardItem.imageURL;
            item.forwardItem = forwardItem;
        }
        [itemsRow addObject: item];
    }
    if(mainViewModel.items.count == 0)
    {
        TTTableMessageItem* item = [TTTableMessageItem itemWithTitle:@">_<"
                                                             caption:nil
                                                                text:@"尚无任何信息，请至少登陆一个帐户并保持网络畅通。点我开始进行SNS帐号绑定。"
                                                           timestamp:[NSDate date]
                                                            imageURL:nil
                                                                 URL:nil];
        item.from = @"来自可怜的UP主";
        [itemsRow addObject: item];
    }
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
}



- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    // 有可能选中的是当mainViewModel中item为空时放上去的那个提示项，所以要判断一下，如果是提示项的话，转到帐户页
    if(mainViewModel.items.count == 0)
    {
        self.tabBarController.selectedViewController
        = [self.tabBarController.viewControllers objectAtIndex:3];
        return;
    }
    lastSelectIndex = indexPath.row;
    ItemViewModel* item = [mainViewModel.items objectAtIndex:lastSelectIndex];
    if(item.type == EntryType_RSS)
    {
        [self performSegueWithIdentifier:@"Segue_GotoRSSDetailPage" sender:self];
    }
    else if(item.type == EntryType_SinaWeibo
            || item.type == EntryType_Renren
            || item.type == EntryType_Douban)
    {
        [self performSegueWithIdentifier:@"Segue_GotoStatusDetailPage" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 这里实际上有两个待跳转页
    // 1. StatusDetailViewController
    // 2. RSSDetailViewController
    // 他们都必须实现一个叫itemViewModel的property
    id detailPage = segue.destinationViewController;
    ItemViewModel* item = [mainViewModel.items objectAtIndex:lastSelectIndex];
    [detailPage setValue:item forKey:@"itemViewModel"];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Sina
    if(buttonIndex == 0)
    {
        lastSelectPostType = EntryType_SinaWeibo;
        [self SinaWeiboAlertPostStatusSheet];
    }
    // Renren
    else if(buttonIndex == 1)
    {
        lastSelectPostType = EntryType_Renren;
        [self RenrenAlertPostStatusSheet];
    }
    // Douban
    else if(buttonIndex == 2)
    {
        lastSelectPostType = EntryType_Douban;
        [self DoubanAlertPostStatusSheet];        
    }
}

- (void)showPostStatusPostController
{
    TTPostController* controller = [[TTPostController alloc] initWithNavigatorURL:nil
                                                                            query:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", nil]];
    controller.originView = self.view;
    controller.delegate = self;
    [controller showInView:self.view animated:YES];
}

#pragma mark - TTPostControllerDelegate
- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
    int length = text.length;
    if(length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"呃～是智商要超过250才能看到您写的字么？" delegate:nil
                                              cancelButtonTitle:@"寡人喻之矣" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    int maxLenth = 140;
    // 人人是个例外，新鲜事最长为280
    if(lastSelectPostType == EntryType_Renren)
    {
        maxLenth = 280;
    }
    int nLeft = length - maxLenth;
    if(nLeft >= 0)
    {
        NSString* preText = [[NSString alloc]initWithFormat:@"内容超长了%d个 ", nLeft];        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:preText         delegate:nil
                                              cancelButtonTitle:@"嗯嗯" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    if(lastSelectPostType == EntryType_SinaWeibo)
    {
        [self SinaWeiboPostStatus:text];
    }
    else if(lastSelectPostType == EntryType_Renren)
    {
        [self RenrenPostStatus:text];
    }
    else if(lastSelectPostType == EntryType_Douban)
    {
        [self DoubanPostStatus:text];
    }
    return TRUE;
}

#pragma mark - Sina Logic
- (void)SinaWeiboAlertPostStatusSheet
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo* sinaweibo = appDelegate.sinaweibo;
    
    if( ![sinaweibo isAuthValid])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"新浪帐号尚未登陆或已过期" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self showPostStatusPostController];
}


-(void)SinaWeiboPostStatus:(NSString*) text
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo* sinaweibo = appDelegate.sinaweibo;
    
    if( ![sinaweibo isAuthValid])
        return;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:text forKey:@"status"];
    
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:dic
                   httpMethod:@"POST"
                     delegate:self];
    
}

#pragma mark SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因，发送失败" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                        message:@"发送成功" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Renren Logic
- (void)RenrenAlertPostStatusSheet
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    Renren* renren = appDelegate.renren;
    
    if( ![renren isSessionValid])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"人人帐号尚未登陆或已过期" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self showPostStatusPostController];
}

-(void)RenrenPostStatus:(NSString*) text
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    Renren* renren = appDelegate.renren;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:@"status.set" forKey:@"method"];
    [dic setObject:text forKey:@"status"];
    [renren requestWithParams:dic andDelegate:self];
}


#pragma mark  Renren Delegate
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                    message:@"发送成功" delegate:nil
                                          cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
    [alert show];
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"由于未知原因，发送失败，请确保网络畅通" delegate:nil
                                          cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - Douban Logic
- (void)DoubanAlertPostStatusSheet
{
    DOUService *service = [DOUService sharedInstance];
    if(![service isValid])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"豆瓣帐号尚未登陆或已过期" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self showPostStatusPostController];
}

-(void)DoubanPostStatus:(NSString*) text
{
    DOUService *service = [DOUService sharedInstance];
    if(![service isValid])
        return ;
    
    NSString* subPath = @"/shuo/v2/statuses/";
    DOUQuery* query = [[DOUQuery alloc] initWithSubPath:subPath
                                             parameters:[NSDictionary dictionaryWithObjectsAndKeys:text,@"text",
                                                         [CareConstants doubanAppKey], @"source",nil]];
    
    DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
        NSError *error = [req error];
        NSLog(@"str:%@", [req responseString]);
        
        if (!error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                            message:@"发送成功" delegate:nil
                                                  cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"由于未知原因，发送失败" delegate:nil
                                                  cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
            [alert show];
        }
    };
    
    service.apiBaseUrlString = [CareConstants doubanBaseAPI];
    

    [service post:query postBody:nil callback:completionBlock];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if(photos == nil)
        return 0;
    return photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if(photos == nil)
        return nil;
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}


// 因为在在TTTableStatusItemCell里不方便拿到navigationController,所以跑到这里去做页面跳转
-(void)gotoPhotoViewerWithURL:(NSString*)url
{
    if(url == nil || url.length == 0)
        return;
    photos = [[NSMutableArray alloc] init];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    [self.navigationController pushViewController:browser animated:YES];

}
@end
