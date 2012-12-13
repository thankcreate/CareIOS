//
//  TTCommentViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-10.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTCommentViewController.h"
#import "ItemViewModel.h"
#import "CommentViewModel.h"
#import "CareAppDelegate.h"
#import "SinaWeiboConverter.h"
#import "RenrenConverter.h"
#import "DoubanConverter.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TTTableCommentItem.h"
#import "TTTableCommentItemCell.h"
#import "MiscTool.h"

#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"

@interface TTCommentViewController ()

@end

@implementation  TTSectionedDataSource(CommentSource)
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[TTTableCommentItem class]]) {
        return [TTTableCommentItemCell class];
    }
    
    else
    {
     return [super tableView:tableView cellClassForObject:object];   
    }
}

@end

@implementation TTCommentViewController
@synthesize itemViewModel;
@synthesize commentList;
@synthesize lastRenrenMethod;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    commentList = [[NSMutableArray alloc] init];
    self.variableHeightRows = YES;
    
    // 清除额外的分隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];

    //[self fetchComments];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [CareConstants headerColor];
    [self fetchComments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchComments
{
    if(itemViewModel.type == EntryType_SinaWeibo)
    {
        [self fetchCommentsSinaWeibo];
    }
    else if (itemViewModel.type == EntryType_Renren)
    {
        [self fetchCommentsRenren];
    }
    else if (itemViewModel.type == EntryType_Douban)
    {
        [self fetchCommentsDouban];
    }
}

-(void)fetchComplete
{
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    
    NSArray* sortedCommentList = [commentList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* time1 = ((CommentViewModel*)(obj1)).time;
        NSDate* time2 = ((CommentViewModel*)(obj2)).time;
        NSComparisonResult res =  [time1 compare:time2];
        return -res;
    }];

    for(CommentViewModel* comment in sortedCommentList)
    {
        if(comment != nil)
        {
            TTTableCommentItem* item = [TTTableCommentItem itemWithTitle:comment.title
                                                                 content:comment.content
                                                                imageURL:comment.iconURL
                                                                    time:comment.time
                                                        commentViewModel:comment
                                                           itemViewModel:itemViewModel];
            [itemsRow addObject:item];
        }
    }
    if(commentList.count == 0)
    {
        TTTableCommentItem* item = [TTTableCommentItem itemWithTitle:@">_< 尚无评论"
                                                             content:@"少年，不来抢个沙发么？"
                                                            imageURL:@""
                                                                time:nil
                                                    commentViewModel:nil
                                                       itemViewModel:nil];
        [itemsRow addObject:item];
    }

    
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
}


- (IBAction)writeCommentClick:(id)sender
{
    
    TTPostController* controller = [[TTPostController alloc] initWithNavigatorURL:nil
                                                                            query:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"text", nil]];
    controller.originView = self.view;
    controller.delegate = self;
    [controller showInView:self.view animated:YES];
    
}


#pragma mark - SinaWeibo Logic
- (SinaWeibo *)sinaweibo
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.sinaweibo;
}

-(void)fetchCommentsSinaWeibo
{
    SinaWeibo* sinaweibo = [self sinaweibo];
   
    if( ![sinaweibo isAuthValid])
        return;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:itemViewModel.ID forKey:@"id"];
    [dic setObject:@"50" forKey:@"count"];
    
    [sinaweibo requestWithURL:@"comments/show.json"
                       params:dic
                   httpMethod:@"GET"
                     delegate:self];
}

#pragma mark  SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"comments/create.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因，发送失败" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"comments/show.json"])
    {
        [commentList removeAllObjects];
        NSArray* comments = [result objectForKey:@"comments"];
        for(id comment in comments)
        {
            CommentViewModel* model = [SinaWeiboConverter convertCommentToCommon:comment];
            if(model)
            {
                [commentList addObject:model];
            }
        }
        [self fetchComplete];
    }
    else if([request.url hasSuffix:@"comments/create.json"])
    {
        // 因为刚刚自己发表了一个评论，这里需要重新加载评论列表
        // 延迟是因为新浪的服务器需要一定时间来更新数据，如果立即请求，可能得不到最新的
        [self performSelector:@selector(fetchCommentsSinaWeibo) withObject:nil afterDelay:0.5];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                        message:@"发送成功" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
        [alert show];
    }
}



#pragma mark - Renren Logic
- (Renren *)renren
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.renren;
}

-(void)fetchCommentsRenren
{
    Renren* renren = [self renren];
   
    if( ![renren isSessionValid] )
        return;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(itemViewModel.renrenFeedType == RenrenNews_TextStatus)
    {
        [dic setObject:@"status.getComment" forKey:@"method"];
        [dic setObject:itemViewModel.ID forKey:@"status_id"];
        [dic setObject:itemViewModel.ownerID forKey:@"owner_id"];
        [dic setObject:@"50" forKey:@"count"];
    }
    else if(itemViewModel.renrenFeedType == RenrenNews_UploadPhoto)
    {
        [dic setObject:@"photos.getComments" forKey:@"method"];
        [dic setObject:itemViewModel.ID forKey:@"pid"];
        [dic setObject:itemViewModel.ownerID forKey:@"uid"];
        [dic setObject:@"50" forKey:@"count"];
    }
    else if(itemViewModel.renrenFeedType == RenrenNews_SharePhoto)
    {
        [dic setObject:@"share.getComments" forKey:@"method"];
        [dic setObject:itemViewModel.ID forKey:@"share_id"];
        [dic setObject:itemViewModel.ownerID forKey:@"user_id"];
        [dic setObject:@"50" forKey:@"count"];
    }
    lastRenrenMethod = @"getComment";
    [renren requestWithParams:dic andDelegate:self];
}



#pragma mark  Renren Delegate
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    if([lastRenrenMethod compare:@"getComment"] == NSOrderedSame)
    {
        [commentList removeAllObjects];
        NSArray* comments;
        // 这里很恶心，对于分享的评论是存在comments结点下的，其它的直接存在root结点下
        if(itemViewModel.renrenFeedType == RenrenNews_SharePhoto)
        {
            comments = [response.rootObject objectForKey:@"comments"];
        }
        else
        {
            comments = response.rootObject;
        }
        
        for(id comment in comments)
        {
            CommentViewModel* model = [RenrenConverter convertCommentToCommon:comment renrenType:itemViewModel.renrenFeedType];
            if(model)
            {
                [commentList addObject:model];
            }
        }
        [self fetchComplete];
    }
    else if ([lastRenrenMethod compare:@"addComment"] == NSOrderedSame)
    {
        // 因为刚刚自己发表了一个评论，这里需要重新加载评论列表
        // 延迟是因为人人的服务器需要一定时间来更新数据，如果立即请求，可能得不到最新的
        [self performSelector:@selector(fetchCommentsRenren) withObject:nil afterDelay:0.5];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                        message:@"发送成功" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
        [alert show];
    }

}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"error_msg"]];
	UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"拖出去枪毙五分钟" otherButtonTitles:nil];
	[alertView show];
}

#pragma mark - Douban Logic
-(void)fetchCommentsDouban
{
    DOUService *service = [DOUService sharedInstance];
    if(itemViewModel.ID == nil)
        return;
    NSString* subPath = [NSString stringWithFormat:@"/shuo/v2/statuses/%@/comments", itemViewModel.ID];
    DOUQuery* query = [[DOUQuery alloc] initWithSubPath:subPath
                                             parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"50",@"count",nil]];
    
    DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
        NSError *error = [req error];
        
        if (!error) {
            [commentList removeAllObjects];
            NSArray* comments = [[req responseString] JSONValue];
            for(id comment in comments)
            {
                CommentViewModel* model = [DoubanConverter convertCommentToCommon:comment];
                if(model)
                {
                    [commentList addObject:model];
                }
            }
            [self fetchComplete];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"由于未知原因，获取评论失败" delegate:nil
                                                  cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
            [alert show];
        }
    };
    
    service.apiBaseUrlString = [CareConstants doubanBaseAPI];
    [service get:query callback:completionBlock];
    
}

#pragma  mark -  TTPostControllerDelegate
// 对于评论而言都是140字上限，对于发表新状态，人人是280,其它还是140
- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
    int length = text.length;
    if(length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"呃～是智商要超过250才能看到您写的字么？" delegate:nil
                                              cancelButtonTitle:@"寡人知之矣" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
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
    
    if(itemViewModel.type == EntryType_SinaWeibo)
    {
        SinaWeibo* sinaweibo = [self sinaweibo];
        
        if( ![sinaweibo isAuthValid])
            return FALSE;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:text forKey:@"comment"];
        [dic setObject:itemViewModel.ID forKey:@"id"];
        
        [sinaweibo requestWithURL:@"comments/create.json"
                           params:dic
                       httpMethod:@"POST"
                         delegate:self];     

    }
    else if(itemViewModel.type == EntryType_Renren)
    {
        Renren* renren = [self renren];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if(itemViewModel.renrenFeedType == RenrenNews_TextStatus)
        {
            [dic setObject:@"status.addComment" forKey:@"method"];
            [dic setObject:itemViewModel.ID forKey:@"status_id"];
            [dic setObject:itemViewModel.ownerID forKey:@"owner_id"];
            [dic setObject:text forKey:@"content"];
        }
        else if(itemViewModel.renrenFeedType == RenrenNews_UploadPhoto)
        {
            [dic setObject:@"photos.addComment" forKey:@"method"];
            [dic setObject:itemViewModel.ID forKey:@"pid"];
            [dic setObject:itemViewModel.ownerID forKey:@"uid"];
            [dic setObject:text forKey:@"content"];
        }
        else if(itemViewModel.renrenFeedType == RenrenNews_SharePhoto)
        {
            [dic setObject:@"share.addComment" forKey:@"method"];
            [dic setObject:itemViewModel.ID forKey:@"share_id"];
            [dic setObject:itemViewModel.ownerID forKey:@"user_id"];
            [dic setObject:text forKey:@"content"];
        }
        lastRenrenMethod = @"addComment";
        [renren requestWithParams:dic andDelegate:self];
    }
    else if(itemViewModel.type == EntryType_Douban)
    {
        DOUService *service = [DOUService sharedInstance];
        if(![service isValid])
            return FALSE;
        
        NSString* subPath = [NSString stringWithFormat:@"/shuo/v2/statuses/%@/comments", itemViewModel.ID];
        DOUQuery* query = [[DOUQuery alloc] initWithSubPath:subPath
                                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:text,@"text",
                                                             [CareConstants doubanAppKey], @"source",nil]];
        
        DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
            NSError *error = [req error];
            
            if (!error) {
                [self performSelector:@selector(fetchCommentsDouban) withObject:nil afterDelay:0.5];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                                message:@"发送成功" delegate:nil
                                                      cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                                message:@"由于未知原因，获取评论失败" delegate:nil
                                                      cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
                [alert show];
            }
        };
        
        service.apiBaseUrlString = [CareConstants doubanBaseAPI];
        
        // TODO: urlencode
        [service post:query postBody:nil callback:completionBlock];
    }
    return TRUE;
 }
@end