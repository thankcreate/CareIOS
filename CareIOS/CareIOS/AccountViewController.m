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
@interface AccountViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblSinaWeiboName;
@property (strong, nonatomic) IBOutlet UILabel *lblSinaWeiboFollowerName;
@property (strong, nonatomic) IBOutlet UILabel *lblRenrenName;
@property (strong, nonatomic) IBOutlet UILabel *lblRenrenFollowerName;

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
    SinaWeibo* sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
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

- (void)viewWillAppear:(BOOL)animated
{
    [self initUISinaWeibo];
    [self initUIRenren];
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


#pragma mark - Table view data source -

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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



#pragma mark - SinaWeibo Delegate

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

#pragma mark - SinaWeiboRequest Delegate
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

#pragma mark - Renren Delegate
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
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"error_msg"]];
	UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"拖出去枪毙五分钟" otherButtonTitles:nil];
	[alertView show];
}


@end
