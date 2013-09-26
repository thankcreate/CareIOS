//
//  LabSmartChatViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "LabSmartChatViewController.h"
#import "ChatItemViewModel.h"
#import "TTTableChatItem.h"
#import "CareAppDelegate.h"
#import "DOUAPIEngine.h"
#import "MobClick.h"


@interface LabSmartChatViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textInput;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnSubmit;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;

@end

@implementation LabSmartChatViewController
@synthesize chatList;
@synthesize textInput;
@synthesize btnSubmit;
@synthesize myToolbar;
@synthesize originalRootView;

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
    chatList = [[NSMutableArray alloc] init];
    self.variableHeightRows = YES;
    
    // 清除额外的分隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    v.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:v];
    
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile1.png"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    textInput.delegate = self;
    textInput.returnKeyType = UIReturnKeySend;
    [self initActionBar];
    // 加载本地缓存
    [self loadFromLocalStorage];
    

    
    
}

- (void)initActionBar
{
    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 0)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.backgroundColor = [UIColor clearColor];
    [MiscTool setHeader:self];
    // anyone know how to get it perfect?
    tools.barStyle = UIBarStyleBlackTranslucent; // clear background
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Create a standard refresh button.
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clear)];
    //[buttons addObject:bi];

    
//    // Create a spacer.
//    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    bi.width = 0.0f;
//    [buttons addObject:bi];

    
//    // Add profile button.
    UIBarButtonItem *b2 = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareClicked:)];
//    bi.style = UIBarButtonItemStyleBordered;
//    [buttons addObject:bi];
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];

    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];

    // self.navigationItem.rightBarButtonItem = twoButtons;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:b2, bi, nil];
    // for iOS7 update
    [MiscTool autoAdjuctScrollView:self.tableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(liftMainViewWhenKeybordAppears:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnMainViewToInitialposition:) name:UIKeyboardWillHideNotification object:nil];

    [MiscTool setHeader:self];

    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    
    if(chatList == nil)
    {
        chatList = [[NSMutableArray alloc] initWithCapacity:10];
    }
    if(chatList.count == 0)
    {
        ChatItemViewModel* firstModel = [[ChatItemViewModel alloc]init];
        firstModel.title = [MiscTool getHerName];
        firstModel.iconURL = [MiscTool getHerIcon];
        firstModel.content = @"^_^";
        firstModel.time = [NSDate date];
        firstModel.type = ChatType_Her;
        [chatList addObject:firstModel];
    }
    for(ChatItemViewModel* chatItemViewModel in chatList)
    {
        if(chatItemViewModel != nil)
        {
            TTTableChatItem* item = [TTTableChatItem itemWithChatItemViewModel:chatItemViewModel];
            [itemsRow addObject:item];
        }
    }
    
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
    
    CGRect barFrame =  myToolbar.frame;
    CGRect viewFrame = self.view.frame;
    [self.tableView setFrame:CGRectMake(0, 0, 320, viewFrame.size.height - barFrame.size.height)];
    
    // 这里不用担心 如果count为0，是不是减到-1上去了，实验证明没有问题
    NSIndexPath* lastPath = [NSIndexPath indexPathForRow: chatList.count-1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)clear
{
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    
    chatList = [[NSMutableArray alloc] init];
       
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
    NSIndexPath* lastPath = [NSIndexPath indexPathForRow: chatList.count-1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [textInput setText:@""];

}

- (IBAction)submit:(id)sender
{
    [textInput resignFirstResponder];
    int length = textInput.text.length;
    if(length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"呃～是智商要超过250才能看到您写的字么？" delegate:nil
                                              cancelButtonTitle:@"寡人知之矣" otherButtonTitles:nil];
        [alert show];
        return;
    }


    ChatItemViewModel* myPost = [[ChatItemViewModel alloc]init];
    myPost.title = [MiscTool getMyName];
    myPost.iconURL = [MiscTool getMyIcon];
    myPost.content = textInput.text;
    myPost.time = [NSDate date];
    myPost.type = ChatType_Me;
    [self addItem:myPost];
    [textInput setText:@""];
    
    [self performSelector:@selector(react) withObject:nil afterDelay:1];
}

// 她的回应
-(void)react
{   
    ChatItemViewModel* herPost = [[ChatItemViewModel alloc]init];
    herPost.title = [MiscTool getHerName];
    herPost.iconURL = [MiscTool getHerIcon];

    NSString* arrayHerSentece[3] = { @"^_^ 然后呢?", @"呵呵..", @"哈哈，这样~~" };
    int index = arc4random() % 3;
    herPost.content = arrayHerSentece[index];
    
    herPost.time = [NSDate date];
    herPost.type = ChatType_Her;
    [self addItem:herPost];
}

-(void)addItem:(ChatItemViewModel*)model
{
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    [chatList addObject:model];
    for(ChatItemViewModel* chatItemViewModel in chatList)
    {
        if(chatItemViewModel != nil)
        {
            TTTableChatItem* item = [TTTableChatItem itemWithChatItemViewModel:chatItemViewModel];
            [itemsRow addObject:item];
        }
    }
    
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
    NSIndexPath* lastPath = [NSIndexPath indexPathForRow: chatList.count-1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self saveToLoaclStorage];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) liftMainViewWhenKeybordAppears:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    if(originalRootView.size.width == 0)
        originalRootView = self.view.frame;
    [self.view setFrame:CGRectMake(originalRootView.origin.x, originalRootView.origin.y , originalRootView.size.width, originalRootView.size.height - keyboardFrame.size.height)];
    [UIView commitAnimations];
}

- (void) returnMainViewToInitialposition:(NSNotification*)aNotification{
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(originalRootView.origin.x, originalRootView.origin.y , originalRootView.size.width, originalRootView.size.height)];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"archiveChat"];
}


-(void)loadFromLocalStorage
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* chatCacheItems = [unarchiver decodeObjectForKey:@"chatItems"];
    if(chatCacheItems != nil)
        chatList = chatCacheItems;   
    [unarchiver finishDecoding];
}

-(void)saveToLoaclStorage
{
//    if(chatList == nil || chatList.count == 0 )
//        return;
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:chatList forKey:@"chatItems"];    
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

- (void)viewDidUnload {
    [self setTextInput:nil];
    [self setBtnSubmit:nil];
    [self setTextInput:nil];
    [self setBtnSubmit:nil];
    [self setMyToolbar:nil];
    [super viewDidUnload];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self submit:nil];
    return YES;
}



// OC里不允许多重继承，LabShareBaseViewController的东西不能直接重用到LabSmartChatViewController
// 想来想去，一时找不到什么完美的解决方案，所以直接把代码复制过去了
// 以后在LabShareBaseViewController里所做的任何修改，务必同步到LabSmartChatViewController的相关部分
// 虽然这样做实在是不能丑陋得更多，但是我还想今天把智能聊天模块做完打dota去呢，先这么的吧^_^
// 我想佛祖会原谅我的
// 我真是不能屌丝得更多了，自己跟自己都能聊得high起来了
// 谁来救救我
// 停不下来了
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
    NSString* result = @"";
    if(lastSelectPostType == EntryType_SinaWeibo)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* myName = [defaults objectForKey:@"SinaWeibo_NickName"];
        result = [NSString stringWithFormat:@"UP主活了这么多年， @%@ 是我见过的最无聊的一个，没有之一！"
                  , myName];
    }
    else if(lastSelectPostType == EntryType_Renren)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* myName = [defaults objectForKey:@"Renren_NickName"];
        NSString* myID =[defaults objectForKey:@"Renren_ID"];
        result = [NSString stringWithFormat:@"UP主活了这么多年， @%@(%@) 是我见过的最无聊的一个，没有之一！"
                  , myName, myID];
    }
    else if(lastSelectPostType == EntryType_Douban)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* myName = [defaults objectForKey:@"Douban_NickName"];
        result = [NSString stringWithFormat:@"UP主活了这么多年， @%@ 是我见过的最无聊的一个，没有之一！"
                  , myName];
    }
    return result;}


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
    CGFloat scale = image.scale;
    CGRect contentRectToCrop = CGRectMake(0, 20 * scale, 320 * scale, (imageHeight - 20) * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    
    return croppedImage;
}


@end
