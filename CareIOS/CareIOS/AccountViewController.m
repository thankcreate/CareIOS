//
//  AccountViewController.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-1.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "AccountViewController.h"
#import "CareAppDelegate.h"
#import "PreferenceHelper.h"
#import "SelectFriendViewController.h"
#import "MainViewModel.h"
#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"
@interface AccountViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblSinaWeiboName;
@property (strong, nonatomic) IBOutlet UILabel *lblSinaWeiboFollowerName;
@property (strong, nonatomic) IBOutlet UILabel *lblRenrenName;
@property (strong, nonatomic) IBOutlet UILabel *lblRenrenFollowerName;
@property (strong, nonatomic) IBOutlet UILabel *lblDoubanName;
@property (strong, nonatomic) IBOutlet UILabel *lblDoubanFollowerName;
@property (strong, nonatomic) IBOutlet UILabel *lblRSSFollowerSiteTitle;
@property (strong, nonatomic) IBOutlet UITableView *table;
@end

@implementation AccountViewController
@synthesize TypeWillGotoInSelectFriendPage;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    TypeWillGotoInSelectFriendPage = EntryType_NotSet;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)initUISinaWeibo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* name = [defaults objectForKey:@"SinaWeibo_NickName"];
    NSString* herName = [defaults objectForKey:@"SinaWeibo_FollowerNickName"];
    if(name == nil)
    {
        name = @"未登陆";
    }
    self.lblSinaWeiboName.text = name;
    [self.lblSinaWeiboName sizeToFit];
    
    if(herName == nil)
    {
        herName = @"未关注";
    }
    self.lblSinaWeiboFollowerName.text = herName;
    [self.lblSinaWeiboFollowerName sizeToFit];    
}

- (void)initUIRenren
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* name = [defaults objectForKey:@"Renren_NickName"];
    NSString* herName = [defaults objectForKey:@"Renren_FollowerNickName"];
    if(name == nil)
    {
        name = @"未登陆";
    }
    self.lblRenrenName.text = name;
    [self.lblRenrenName sizeToFit];
    
    if(herName == nil)
    {
        herName = @"未关注";
    }
    self.lblRenrenFollowerName.text = herName;
    [self.lblRenrenFollowerName sizeToFit];
}

- (void)initUIDouban
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* name = [defaults objectForKey:@"Douban_NickName"];
    NSString* herName = [defaults objectForKey:@"Douban_FollowerNickName"];
    if(name == nil)
    {
        name = @"未登陆";
    }
    self.lblDoubanName.text = name;
    [self.lblDoubanName sizeToFit];
    
    if(herName == nil)
    {
        herName = @"未关注";
    }
    self.lblDoubanFollowerName.text = herName;
    [self.lblDoubanFollowerName sizeToFit];
}

- (void)initUIRSS
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* followerSiteTitle = [defaults objectForKey:@"RSS_FollowerSiteTitle"];
    
    if(followerSiteTitle == nil)
    {
        followerSiteTitle = @"未关注";
    }
    self.lblRSSFollowerSiteTitle.text = followerSiteTitle;
    [self.lblRSSFollowerSiteTitle sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MiscTool setHeader:self];    
    [self initUISinaWeibo];
    [self initUIRenren];
    [self initUIDouban];
    [self initUIRSS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id selectFriendPage = segue.destinationViewController;
    if ([selectFriendPage isKindOfClass:[SelectFriendViewController class]]) {
        NSNumber* num = [NSNumber numberWithInt:TypeWillGotoInSelectFriendPage];
        [selectFriendPage setValue:num forKey:@"type"];
    } 
}

#pragma mark - Table view delegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger sec = [indexPath section];
    NSInteger row = [indexPath row];
    // 新浪区
    if(sec ==0)
    {
        // 登陆
        if(row == 0)
        {
            SinaWeibo *sinaweibo = [self sinaweibo];
            sinaweibo.delegate = self;
            [sinaweibo logIn];
        }
        else if (row == 1)
        {
            [self sinaWeiboSelectFollowerClick];
        }
        else if (row == 2)
        {
            [self sinaWeiboLogoutClick];
        }
    }
    // 人人区
    else if (sec == 1)
    {
        // 登陆
        if(row == 0)
        {
            Renren *renren = [self renren];
            NSArray *permissions=[NSArray arrayWithObjects: @"publish_feed",
                                  @"publish_blog",
                                  @"publish_share",
                                  @"read_user_album",
                                  @"read_user_status",
                                  @"read_user_photo",
                                  @"read_user_comment",
                                  @"read_user_status",
                                  @"publish_comment",
                                  @"read_user_share",
                                  @"create_album",
                                  @"status_update",
                                  @"photo_upload", nil];
            [renren authorizationWithPermisson:permissions andDelegate:self];
        }
        else if (row == 1)
        {
            [self renrenSelectFollowerClick];
        }
        else if (row == 2)
        {
            [self renrenLogoutClick];
        }
    }
    // 豆瓣区
    else if (sec == 2)
    {
        // 登陆
        if(row == 0)
        {
            DoubanLoginWebViewController *webViewController = [[DoubanLoginWebViewController alloc] initWithDelegate:self];
            webViewController.hidesBottomBarWhenPushed = TRUE;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        else if (row == 1)
        {
            [self doubanSelectFollowerClick];
        }
        else if (row == 2)
        {
            [self doubanLogoutClick];
        }
    }
    else if ( sec == 3)
    {
        [self performSegueWithIdentifier:@"Segue_SetRss" sender:self];
    }
    
    
    // 清除选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    // Navigation logic may go here. Create and push another view controller.
    /*
    ￼ *detailViewController = [[￼ alloc] initWithNibName:@"￼" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    */
}

#pragma mark - SinaWeibo Logic

- (SinaWeibo *)sinaweibo
{
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}


- (void)sinaweiboRefreshUserInfo
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)sinaWeiboSelectFollowerClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* myID = [defaults objectForKey:@"SinaWeibo_ID"];
    if(myID == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"没有登陆，怎么指定关注人的说~" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，明白了" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        TypeWillGotoInSelectFriendPage = EntryType_SinaWeibo;
        [self performSegueWithIdentifier:@"Segue_SelectFollower" sender:self];
    }
}

- (void)sinaWeiboLogoutClick
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
    [MainViewModel sharedInstance].isChanged = true;
    [PreferenceHelper clearSinaWeiboPreference];
    [self initUISinaWeibo];
    
}



#pragma mark SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:sinaweibo.userID forKey:@"SinaWeibo_ID"];
    [defaults setValue:sinaweibo.accessToken forKey:@"SinaWeibo_Token"];
    [defaults setValue:sinaweibo.expirationDate forKey:@"SinaWeibo_ExpirationDate"];
    [self sinaweiboRefreshUserInfo];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"登陆过程发生未知错误，请保持网络通畅" delegate:nil
                                          cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
    [alert show];
}

#pragma mark SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        NSDictionary* dic = result;
        NSString *name = [dic objectForKey:@"screen_name"];        
        NSString *avatar = [dic objectForKey:@"profile_image_url"];
        
        // 存到本地
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:name forKey:@"SinaWeibo_NickName"];
        [defaults setValue:avatar forKey:@"SinaWeibo_Avatar"];
        [defaults synchronize];
        
        // 设置标签
        self.lblSinaWeiboName.text = name;
        [self.lblSinaWeiboName sizeToFit];
        [self initUISinaWeibo];
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"comments/create.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因，获取帐号信息失败，请尝试重新登陆" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Renren Logic

- (Renren *)renren
{
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.renren;
}

- (void)renrenLogoutClick
{
    Renren *renren = [self renren];
    [renren logout:self];
    [MainViewModel sharedInstance].isChanged = true;
    [PreferenceHelper clearRenrenPreference];
    [self initUIRenren];
}

- (void)renrenSelectFollowerClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* myID = [defaults objectForKey:@"Renren_ID"];
    if(myID == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"没有登陆，怎么指定关注人的说~" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，朕知道了" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        TypeWillGotoInSelectFriendPage = EntryType_Renren;
        [self performSegueWithIdentifier:@"Segue_SelectFollower" sender:self];
    }
}

#pragma mark Renren Delegate
- (void)renrenDidLogin:(Renren *)renren
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:renren.accessToken forKey:@"Renren_Token"];
    [defaults setValue:renren.expirationDate forKey:@"Renren_ExpirationDate"];
    [defaults synchronize];
    ROUserInfoRequestParam *requestParam = [[ROUserInfoRequestParam alloc] init];
	requestParam.fields = [NSString stringWithFormat:@"uid,name,sex,birthday,headurl"];	
	[self.renren getUsersInfo:requestParam andDelegate:self];
}

- (void)renrenDidLogout:(Renren *)renren
{
    int haha = 575;
    haha ++;
}

- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
	NSArray *usersInfo = (NSArray *)(response.rootObject);
	for (ROUserResponseItem *item in usersInfo) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:item.userId forKey:@"Renren_ID"];
        [defaults setValue:item.name forKey:@"Renren_NickName"];
        [defaults setValue:item.headUrl forKey:@"Renren_Avatar"];
        [defaults synchronize];        
        break;
	}
    [self initUIRenren];
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"由于未知原因，获取人人信息失败，请确保网络畅通" delegate:nil
                                          cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Douban Logic
-(void)doubanRefreshUseInfo:(NSString*)userID
{
    NSString *subPath = @"/v2/user/~me";
    DOUQuery *query = [[DOUQuery alloc] initWithSubPath:subPath parameters:nil];
    
    DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
        NSError *error = [req error];        
        
        if (!error) {
            id user = [[req responseString] JSONValue];
            // 因为ID已经在登陆时就拿到了，所以此处不保存ID
            NSString* name = [user objectForKey:@"name"];
            NSString* avatar = [user objectForKey:@"avatar"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:name forKey:@"Douban_NickName"];
            [defaults setValue:avatar forKey:@"Douban_Avatar"];
            [self initUIDouban];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"由于未知原因，获取帐号信息失败，请尝试重新登陆" delegate:nil
                                                  cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
            [alert show];            
        }
    };
    DOUService *service = [DOUService sharedInstance];
    service.apiBaseUrlString = [CareConstants doubanBaseAPI];
    [service get:query callback:completionBlock ];
}


- (void)doubanSelectFollowerClick
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* myID = [defaults objectForKey:@"Douban_ID"];
    if(myID == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"没有登陆，怎么指定关注人的说~" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，朕知道了" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        TypeWillGotoInSelectFriendPage = EntryType_Douban;
        [self performSegueWithIdentifier:@"Segue_SelectFollower" sender:self];
    }
}


- (void)doubanLogoutClick
{
    //    DOUService *service = [DOUService sharedInstance];
    [MainViewModel sharedInstance].isChanged = true;
    DOUOAuthStore *store = [DOUOAuthStore sharedInstance];
    [store clear];
    [PreferenceHelper clearDoubanPreference];
    [self initUIDouban];
    
}

#pragma mark Douban Login Delegate
- (void)doubanDidLogin:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic
{
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
    
    [self doubanRefreshUseInfo:douban_user_id];
}

- (void)doubanloginDidFail:(DOUOAuthService *)client didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"登陆过程发生未知错误，请保持网络通畅" delegate:nil
                                          cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
    [alert show];
}

@end
