//
//  SinaWeiboSelectFriendViewController.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-2.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SinaWeiboSelectFriendViewController.h"
#import "CareAppDelegate.h"
#import "pinyin.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SinaWeiboSelectFriendViewController ()
@property(strong, nonatomic) NSMutableArray* allFriends;
@property(strong, nonatomic) NSMutableArray* friendsInShow;
@property(strong, nonatomic) NSMutableDictionary* dicAllFriends;
@property(strong, nonatomic) NSMutableDictionary* dicFriendsInShow;
@property(strong, nonatomic) NSMutableArray* keysInShow;
@end

@implementation SinaWeiboSelectFriendViewController

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
    
    SinaWeibo* sinaweibo = [self sinaweibo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:sinaweibo.userID forKey:@"uid"];
    [dic setObject:@"0" forKey:@"cursor"];
    [dic setObject:@"200" forKey:@"count"];
    
    [sinaweibo requestWithURL:@"friendships/friends.json"
                       params:dic
                   httpMethod:@"GET"
                     delegate:self];
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
     //   return  [self.allFriends count];
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
    id friend = [arrayForKey objectAtIndex:row];
    //id friend = [self.allFriends objectAtIndex:row];
    
    lblName.text = [friend objectForKey:@"screen_name"];
    lblDescription.text = [friend objectForKey:@"description"];

    
    NSString* path =[NSString stringWithFormat: [friend objectForKey:@"profile_image_url"] ,[self.title UTF8String]];
    NSURL* url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//网络图片url
   // NSData* data = [NSData dataWithContentsOfURL:url];//获取网咯图片数据

//    [imgAvatar setImage:[[UIImage alloc]  initWithData:data]];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
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
            [self.allFriends addObject:ob];           
        }
        // 不为0继续请求
        if(nNextCursor != 0)
        {
            SinaWeibo* sinaweibo = [self sinaweibo];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:sinaweibo.userID forKey:@"uid"];
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
            // 按首字母分类
            for(id ob in self.allFriends)
            {
                NSString* name = [ob objectForKey:@"screen_name"];
                char first = pinyinFirstLetter([name characterAtIndex:0]);
                //char first='a';
                NSString* strFirst = [[NSString stringWithFormat:@"%c" , first] uppercaseString];
                NSMutableArray* arrayWithKey = [self.dicAllFriends objectForKey:strFirst];
                if(arrayWithKey != nil)
                {
                    [arrayWithKey addObject:ob];
                }
                else
                {
                    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
                    [array addObject:ob];
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
        
    }
}

#pragma mark - SinaWeibo Logic

- (SinaWeibo *)sinaweibo
{
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}


@end
