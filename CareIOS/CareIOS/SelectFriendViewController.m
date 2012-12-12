//
//  SinaWeiboSelectFriendViewController.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-2.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SelectFriendViewController.h"
#import "CareAppDelegate.h"
#import "MainViewModel.h"
#import "pinyin.h"
#import "SinaWeiboConverter.h"
#import "RenrenConverter.h"
#import "FriendViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SelectFriendViewController ()
@property(strong, nonatomic) NSMutableArray* allFriends;
@property(strong, nonatomic) NSMutableArray* friendsInShow;
@property(strong, nonatomic) NSMutableDictionary* dicAllFriends;
@property(strong, nonatomic) NSMutableDictionary* dicFriendsInShow;
@property(strong, nonatomic) NSMutableArray* keysInShow;
@property BOOL shouldBeginEditing;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@end

@implementation SelectFriendViewController
@synthesize type;
@synthesize mySearchBar;
@synthesize renren;

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
    self.allFriends = [NSMutableArray arrayWithCapacity:200];
    self.friendsInShow = [NSMutableArray arrayWithCapacity:200];
    self.dicAllFriends = [NSMutableDictionary dictionaryWithCapacity:10];
    self.dicFriendsInShow = [NSMutableDictionary dictionaryWithCapacity:10];
    self.keysInShow = [NSMutableArray arrayWithCapacity:50];
    self.shouldBeginEditing = YES;
       
    
    int tp = [type intValue];
    if(tp == EntryType_SinaWeibo)
    {
        [self initLoadSinaWeibo];
    }
    else if(tp == EntryType_Renren)
    {
        [self initLoadRenren];
    }
    else if(tp == EntryType_Douban)
    {
        //TODO
    }
    
      // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchComplete
{
    // 按首字母分类
    for(FriendViewModel* friend in self.allFriends)
    {
        NSString* name = friend.name;
        char first = pinyinFirstLetter([name characterAtIndex:0]);
        //char first='a';
        NSString* strFirst = [[NSString stringWithFormat:@"%c" , first] uppercaseString];
        NSMutableArray* arrayWithKey = [self.dicAllFriends objectForKey:strFirst];
        if(arrayWithKey != nil)
        {
            [arrayWithKey addObject:friend];
        }
        else
        {
            NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
            [array addObject:friend];
            [self.dicAllFriends setObject:array forKey:strFirst];
        }
        
        // 将所有key排序
        NSArray* allkeys = [self.dicAllFriends allKeys];
        NSArray* sortedKeys = [allkeys sortedArrayUsingSelector:@selector(compare:)];
        [self.keysInShow removeAllObjects];
        [self.keysInShow addObjectsFromArray:sortedKeys];
        [self.dicFriendsInShow addEntriesFromDictionary:self.dicAllFriends];
    }
    
    [self.friendsInShow removeAllObjects];
    for(id ob in self.allFriends)
    {
        [self.friendsInShow addObject:ob];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sec = [self.keysInShow count];
    return sec;
   // return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dicFriendsInShow == nil)
    {
        return 0;
    }
    else
    {
        NSString* key = [self.keysInShow objectAtIndex:section];
        NSArray* arrayForKey = [self.dicFriendsInShow objectForKey:key];
        return [arrayForKey count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel* lblName = (UILabel*)[cell viewWithTag:2];
    UILabel* lblDescription = (UILabel*)[cell viewWithTag:3];
    UIImageView* imgAvatar = (UIImageView*)[cell viewWithTag:1];

    
    NSInteger sec = [indexPath section];
    NSInteger row = [indexPath row];
    NSString* key = [self.keysInShow objectAtIndex:sec];
    NSArray* arrayForKey = [self.dicFriendsInShow objectForKey:key];
    FriendViewModel* friend = [arrayForKey objectAtIndex:row];

    
    lblName.text = friend.name;
    lblDescription.text = friend.description;

    
    NSString* path =[NSString stringWithFormat: friend.avatar ,[self.title UTF8String]];
    NSURL* url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [imgAvatar setImageWithURL:url ];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [self.keysInShow objectAtIndex:section];
    return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keysInShow;
}

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
    NSString* key = [self.keysInShow objectAtIndex:sec];
    NSArray* arrayForKey = [self.dicFriendsInShow objectForKey:key];
    FriendViewModel* friend = [arrayForKey objectAtIndex:row];
    
    NSString* followerID = friend.ID;
    NSString* followerNickName = friend.name;
    NSString* followerAvatar = friend.avatar;
    NSString* followerAvatar2 = friend.avatar2;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger tp = [type integerValue];
    if(tp == EntryType_SinaWeibo)
    {
        [defaults setValue:followerID forKey:@"SinaWeibo_FollowerID"];
        [defaults setValue:followerNickName forKey:@"SinaWeibo_FollowerNickName"];
        [defaults setValue:followerAvatar forKey:@"SinaWeibo_FollowerAvatar"];
        [defaults setValue:followerAvatar2 forKey:@"SinaWeibo_FollowerAvatar2"];

    }
    else if(tp == EntryType_Renren)
    {
        [defaults setValue:followerID forKey:@"Renren_FollowerID"];
        [defaults setValue:followerNickName forKey:@"Renren_FollowerNickName"];
        [defaults setValue:followerAvatar forKey:@"Renren_FollowerAvatar"];
        [defaults setValue:followerAvatar2 forKey:@"Renren_FollowerAvatar2"];
        
    }
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
    
    [MainViewModel sharedInstance].isChanged = true;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.mySearchBar resignFirstResponder];
}

#pragma mark -
#pragma mark Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self recoverOrigin];
    [searchBar resignFirstResponder];
    return;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTerm
{
    NSLog(@"searchBar:textDidChange: isFirstResponder: %i", [searchBar isFirstResponder]);
    if(![searchBar isFirstResponder]) {
        // 跑这儿来了的话，说明是点了那个右侧的小叉叉
        // 之所里这里要这么纠结，是因为当点了右侧的那个小叉叉时，此时还不是firstResponder
        // 做resign也就没有用，也就没法儿取消键盘
        self.shouldBeginEditing = NO;
        // do whatever I want to happen when the user clears the search...
    }
    if ([searchTerm length] == 0)
    {
        [self recoverOrigin];
        [searchBar resignFirstResponder];
        self.shouldBeginEditing = NO;
        //[self performSelector:@selector(resignFirstResponder:) withObject:mySearchBar afterDelay:0];
        return;        
    }
    [self handleSearchForTerm:searchTerm];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar {
    // reset the shouldBeginEditing BOOL ivar to YES, but first take its value and use it to return it from the method call
    BOOL boolToReturn = self.shouldBeginEditing;
    self.shouldBeginEditing = YES;
    return boolToReturn;
}


- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self.dicFriendsInShow removeAllObjects];
    // 按首字母分类
    for(FriendViewModel* friend in self.allFriends)
    {
        NSString* name = friend.name;
        if([name rangeOfString:searchTerm].length <= 0)
        {
            continue;
        }
        char first = pinyinFirstLetter([name characterAtIndex:0]);
        NSString* strFirst = [[NSString stringWithFormat:@"%c" , first] uppercaseString];
        NSMutableArray* arrayWithKey = [self.dicFriendsInShow objectForKey:strFirst];
        if(arrayWithKey != nil)
        {
            [arrayWithKey addObject:friend];
        }
        else
        {
            NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
            [array addObject:friend];
            [self.dicFriendsInShow setObject:array forKey:strFirst];
        }
        
        
    }
    // 将所有key排序
    NSArray* allkeys = [self.dicFriendsInShow allKeys];
    NSArray* sortedKeys = [allkeys sortedArrayUsingSelector:@selector(compare:)];
    [self.keysInShow removeAllObjects];
    [self.keysInShow addObjectsFromArray:sortedKeys];
    [self.tableView reloadData];
}

- (void)recoverOrigin
{
    [self.dicFriendsInShow removeAllObjects];
    [self.dicFriendsInShow addEntriesFromDictionary:self.dicAllFriends];
    NSArray* allkeys = [self.dicFriendsInShow allKeys];
    NSArray* sortedKeys = [allkeys sortedArrayUsingSelector:@selector(compare:)];
    [self.keysInShow removeAllObjects];
    [self.keysInShow addObjectsFromArray:sortedKeys];

    [self.tableView reloadData];
}

#pragma mark - SinaWeibo Logic
-(void)initLoadSinaWeibo
{
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    renren = delegate.renren;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* myID = [defaults objectForKey:@"SinaWeibo_ID"];
    
    SinaWeibo* sinaweibo = [self sinaweibo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:myID forKey:@"uid"];
    [dic setObject:@"0" forKey:@"cursor"];
    [dic setObject:@"200" forKey:@"count"];
    
    [sinaweibo requestWithURL:@"friendships/friends.json"
                       params:dic
                   httpMethod:@"GET"
                     delegate:self];
}


- (SinaWeibo *)sinaweibo
{
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}


#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"friendships/friends.json"])
    {
        NSDictionary* dic = result;
        NSArray* array = [dic objectForKey:@"users"];
        NSNumber* numNextCursor =(NSNumber*) [dic objectForKey:@"next_cursor"];
        NSInteger nNextCursor = [numNextCursor integerValue];
        
        // 按首字母分类
        for(id ob in array)
        {
            FriendViewModel* model = [SinaWeiboConverter convertFrendToCommon:ob];
            [self.allFriends addObject:model];
        }
        // 不为0继续请求
        if(nNextCursor != 0)
        {
            SinaWeibo* sinaweibo = [self sinaweibo];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString* myID = [defaults objectForKey:@"SinaWeibo_ID"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:myID forKey:@"uid"];
            [dic setObject:[numNextCursor stringValue] forKey:@"cursor"];
            [dic setObject:@"200" forKey:@"count"];
            
            [sinaweibo requestWithURL:@"friendships/friends.json"
                               params:dic
                           httpMethod:@"GET"
                             delegate:self];
        }
        // 为0说明做完了，刷新页面
        else
        {
            [self fetchComplete];
        }
        
    }
}

#pragma mark - Renren Logic
-(void)initLoadRenren
{
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    renren = delegate.renren;
    
    ROGetFriendsInfoRequestParam *requestParam = [[ROGetFriendsInfoRequestParam alloc] init] ;
	requestParam.page = @"1";
	requestParam.count = @"500";
    requestParam.fields = @"";
	
	[self.renren getFriendsInfo:requestParam andDelegate:self];
}

#pragma mark - Renren Delegate
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    NSArray *friendsInfo = (NSArray *)(response.rootObject);
    if(friendsInfo.count)
    {
        for (ROFriendResponseItem *item in friendsInfo)
        {
            FriendViewModel* model = [RenrenConverter convertFrendToCommon:item];
            [self.allFriends addObject:model];
        }
        
        id strLastPage = [response.param.requestParamToDictionary objectForKey:@"page"];
        NSInteger nLastPage = [strLastPage integerValue];
        ++nLastPage;
        
        ROGetFriendsInfoRequestParam *requestParam = [[ROGetFriendsInfoRequestParam alloc] init] ;
        requestParam.page = [[NSNumber numberWithInt:nLastPage] stringValue];
        requestParam.count = @"500";
        requestParam.fields = @"";
        
        [self.renren getFriendsInfo:requestParam andDelegate:self];
    }
    else
    {
        [self fetchComplete];    
    }

}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
	NSString *title = [NSString stringWithFormat:@"Error code:%d", [error code]];
	NSString *description = [NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"error_msg"]];
	UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:title message:description delegate:nil cancelButtonTitle:@"拖出去枪毙五分钟" otherButtonTitles:nil];
	[alertView show];
}

@end
