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
#import <SDWebImage/UIImageView+WebCache.h>
#import "TTTableCommentItem.h"
#import "TTTableCommentItemCell.h"
#import "MiscTool.h"

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

#pragma mark - SinaWeiboRequest Delegate
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
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    
    if ([request.url hasSuffix:@"comments/show.json"])
    {
        NSArray* comments = [result objectForKey:@"comments"];
        for(id comment in comments)
        {
            CommentViewModel* model = [SinaWeiboConverter convertCommentToCommon:comment];
            if(model != nil)
            {
                TTTableCommentItem* item = [TTTableCommentItem itemWithTitle:model.title
                                                                     content:model.content
                                                                    imageURL:model.iconURL
                                                                        time:model.time
                                                            commentViewModel:model
                                                               itemViewModel:itemViewModel];
                [itemsRow addObject:item];
            }
        }        
        if(comments.count == 0)
        {
            TTTableCommentItem* item = [TTTableCommentItem itemWithTitle:@">_< 尚无评论"
                                                                 content:@"少年，不来抢个沙发么？"
                                                                imageURL:@""
                                                                    time:nil
                                                        commentViewModel:nil
                                                           itemViewModel:nil];
            [itemsRow addObject:item];
        }

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
    return TRUE;
}

@end
