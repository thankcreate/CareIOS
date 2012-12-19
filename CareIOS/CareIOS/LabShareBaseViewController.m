//
//  LabShareBaseViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-15.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LabShareBaseViewController.h"
#import "CareAppDelegate.h"
#import "DOUAPIEngine.h"
#import "MobClick.h"

@interface LabShareBaseViewController ()


@end

@implementation LabShareBaseViewController
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
    UIBarButtonItem* btnShare = [[UIBarButtonItem alloc] init];
    btnShare.title = @"分享";

    self.navigationController.navigationItem.rightBarButtonItem = btnShare;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Sub class use
- (IBAction)shareClicked:(id)sender
{
    [MobClick event:@"LabShareClick"];
    screenShotImage = [self screenshot];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到"
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"新浪微博", @"人人网", @"豆瓣社区", nil];
  	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];
}


-(NSString*)preLoadShareString
{
    return @"";
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
        [self SinaWeiboShare:text];
    }
    else if(lastSelectPostType == EntryType_Renren)
    {
        [self RenrenShare:text];
    }
    else if(lastSelectPostType == EntryType_Douban)
    {
        [self DoubanShare:text];
    }
    
    return TRUE;
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
                                                                            query:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   [self preLoadShareString], @"text",
                                                                                   screenShotImage, @"image",
                                                                                   nil]];
    controller.originView = self.view;
    controller.delegate = self;
    controller.title = @"分享";
    [controller showInView:self.view animated:YES];
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

-(void)SinaWeiboShare:(NSString*) text
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo* sinaweibo = appDelegate.sinaweibo;
    
    if( ![sinaweibo isAuthValid])
        return;

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:text forKey:@"status"];
    [dic setObject:screenShotImage forKey:@"pic"];

    
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:dic
                   httpMethod:@"POST"
                     delegate:self];
}


#pragma mark SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因，发送失败" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/upload.json"])
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

-(void)RenrenShare:(NSString*) text
{
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    Renren* renren = appDelegate.renren;
    
    ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
    param.imageFile = screenShotImage;
    param.caption = text;
    [renren publishPhoto:param andDelegate:self];
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

-(void)DoubanShare:(NSString*) text
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
    

    NSData* imageData = UIImagePNGRepresentation(screenShotImage);
    [service post2:query photoData:imageData description:text callback:completionBlock uploadProgressDelegate:nil];
}


- (UIImage*)screenshot
{
    NSLog(@"Shot");
    
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // Remove the status bar
    CGFloat imageHeight = image.size.height;
    CGRect contentRectToCrop = CGRectMake(0, 20, 320, imageHeight - 20);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    return croppedImage;
}

@end
