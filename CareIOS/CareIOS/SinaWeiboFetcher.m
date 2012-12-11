//
//  SinaWeiboFetcher.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-7.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SinaWeiboFetcher.h"
#import "MiscTool.h"
#import "CareAppDelegate.h"

@implementation SinaWeiboFetcher
@synthesize delegate;
@synthesize taskHelper;
@synthesize resultMenList;
-(void)startFetchCommentMan
{
    [resultMenList removeAllObjects];
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo* sinaweibo =  appDelegate.sinaweibo;
      
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
    
    if( ![sinaweibo isAuthValid] || herID == nil)
    {
        [delegate fetchComplete:nil];
        return;
    }    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:herID forKey:@"uid"];
    // 新浪支持的最大为100
    // TODO:
    [dic setObject:@"30" forKey:@"count"];
    
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:dic
                   httpMethod:@"GET"
                     delegate:self];
}


-(id)initWithDelegate:(id<FetcherDelegate>)del
{
    if(!(self = [super init]))
    {
        return nil;
    }
    resultMenList = [NSMutableArray arrayWithCapacity:50];
    taskHelper = [[TaskHelper alloc] initWithDelegate:self];
    delegate = del;
    return self;
}


#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        if(delegate)
        {
            [taskHelper clearTask];
            [delegate fetchComplete:resultMenList];
        }
    }
    else if ([request.url hasSuffix:@"comments/show.json"])
    {
        [taskHelper popTask];
    }

}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        NSArray* statuses = [result objectForKey:@"statuses"];
        for(id status in statuses)
        {
            [taskHelper pushTask];
            CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
            SinaWeibo* sinaweibo =  appDelegate.sinaweibo;
            NSNumber* numStatusID = [status objectForKey:@"id"];
            NSString* statusID = [numStatusID stringValue];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:statusID forKey:@"id"];
            // 新浪支持的最大为100
            // TODO:
            [dic setObject:@"50" forKey:@"count"];
            
            [sinaweibo requestWithURL:@"comments/show.json"
                               params:dic
                           httpMethod:@"GET"
                             delegate:self];         

        }        
    }
   
    else if ([request.url hasSuffix:@"comments/show.json"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
        NSString* myID = [defaults objectForKey:@"SinaWeibo_ID"];

        @try {
            NSArray* listComments = [result objectForKey:@"comments"];
            for(id comment in listComments)
            {
                id user = [comment objectForKey:@"user"];
                if(user)
                {
                    NSString* ID = [[user objectForKey:@"id"] stringValue];
                    NSString* name = [user objectForKey:@"screen_name"];
                    if(!( [ID compare:herID] == NSOrderedSame )  || ( [ID compare:myID] == NSOrderedSame ))
                    {
                        CommentMan * man = [[CommentMan alloc] init];
                        man.ID = ID;
                        man.name = name;
                        [resultMenList addObject:man];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {            
            [taskHelper popTask];
        }
    }
}

#pragma mark - TaskComplete Delegate
- (void)taskComplete
{
    if(delegate)
    {
        [delegate fetchComplete:resultMenList];
    }
}
@end
