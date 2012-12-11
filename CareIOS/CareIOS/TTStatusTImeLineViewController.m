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
@interface TTStatusTImeLineViewController ()
@property (strong, nonatomic) MainViewModel* mainViewModel;
@property (strong, nonatomic) RefreshViewerHelper* refreshViewerHelper;
@end

@implementation TTStatusTImeLineViewController

@synthesize refreshViewerHelper;
@synthesize mainViewModel;


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
    //refreshViewerHelper = [[RefreshViewerHelper alloc] initWithDelegate:self];
    mainViewModel = [MainViewModel sharedInstance];
    [mainViewModel.delegates addObject:self];
    self.variableHeightRows = YES;
    
    self.tableViewStyle = UITableViewStylePlain;
 
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = RGBCOLOR(200, 12, 40);
    if(mainViewModel.isChanged)
    {
        [mainViewModel load:TTURLRequestCachePolicyNetwork more:NO];
    }
}

- (id<UITableViewDelegate>)createDelegate {
    return [[TTStatusTImeDragRefreshDelegate alloc] initWithController:self] ;
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
        TTTableMessageItem* item = [TTTableMessageItem itemWithTitle:model.title
                                                             caption:nil
                                                                text:model.content
                                                           timestamp:model.time
                                                            imageURL:model.iconURL
                                                                 URL:nil];
        item.thumbImageURL = model.imageURL;
        item.from = model.fromText;
        
        // 转发
        if(model.forwardItem)
        {
            TTTableMessageItem* forwardItem = [TTTableMessageItem itemWithTitle:model.forwardItem.title
                                                                        caption:nil
                                                                           text:model.forwardItem.content
                                                                      timestamp:model.time
                                                                       imageURL:model.forwardItem.iconURL
                                                                            URL:nil];
            forwardItem.thumbImageURL = model.forwardItem.imageURL;
            item.forwardItem = forwardItem;
        }
        [itemsRow addObject: item];
    }
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
}

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
	//actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
	[actionSheet showFromTabBar:self.tabBarController.tabBar]; // show from our table view (pops up in the middle of the table)


}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    lastSelectIndex = indexPath.row;
    [self performSegueWithIdentifier:@"Segue_GotoDetailPage" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
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
        [self SinaWeiboPostStatus];
    }
    // Renren
    else if(buttonIndex == 1)
    {
        lastSelectPostType = EntryType_Renren;
        [self RenrenPostStatus];        
    }
    // Douban
    else if(buttonIndex == 2)
    {
        lastSelectPostType = EntryType_Douban;
        [self DoubanPostStatus];        
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

#pragma mark TTPostControllerDelegate
- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
    int length = text.length;
    int nLeft = length - 140;
    if(length > 140)
    {
        NSString* preText = [[NSString alloc]initWithFormat:@"内容超长了%d个 ", nLeft];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:preText         delegate:nil
                                              cancelButtonTitle:@"嗯嗯" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo* sinaweibo = appDelegate.sinaweibo;
    
    if( ![sinaweibo isAuthValid])
        return FALSE;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:text forKey:@"status"];
    
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:dic
                   httpMethod:@"POST"
                     delegate:self];
    return TRUE;
}

#pragma mark Sina Logic
- (void)SinaWeiboPostStatus
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


#pragma mark - SinaWeiboRequest Delegate
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


#pragma mark Renren Logic
- (void)RenrenPostStatus
{
    
}

#pragma mark Douban Logic
- (void)DoubanPostStatus
{
    
}
@end
