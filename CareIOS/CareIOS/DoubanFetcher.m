//
//  DoubanFetcher.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-12.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "DoubanFetcher.h"
#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"

@implementation DoubanFetcher

@synthesize delegate;
@synthesize taskHelper;
@synthesize resultMenList;

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

-(void)startFetchCommentMan
{
    [resultMenList removeAllObjects];
    DOUService *service = [DOUService sharedInstance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herID = [defaults objectForKey:@"Douban_FollowerID"];
    
    if( ![service isValid] || herID == nil)
    {
        [delegate fetchComplete:nil];
        return;
    }
    
    NSString* subPath = [NSString stringWithFormat:@"/shuo/v2/statuses/user_timeline/%@", herID];
    DOUQuery* query = [[DOUQuery alloc] initWithSubPath:subPath
                                             parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"30",@"count",nil]];
    
    DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
        NSError *error = [req error];
        
        if (!error) {
            // timeline 返回处理
            id statues = [[req responseString] JSONValue];
            for(id status in statues)
            {
                [taskHelper pushTask];
                NSString* statusID = [[status objectForKey:@"id"] stringValue];
                
                NSString* subPath = [NSString stringWithFormat:@"/shuo/v2/statuses/%@/comments", statusID];
                DOUQuery* query = [[DOUQuery alloc] initWithSubPath:subPath
                                                         parameters:[NSDictionary dictionaryWithObjectsAndKeys:@"50",@"count",nil]];
                
                DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
                    NSError *error = [req error];
                    
                    // 返回单条状态的评论列表
                    if (!error) {
                        @try
                        {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            NSString* herID = [defaults objectForKey:@"Douban_FollowerID"];
                            NSString* myID = [defaults objectForKey:@"Douban_ID"];
                            
                            NSArray* comments = [[req responseString] JSONValue];
                            for(id comment in comments)
                            {
                                id user = [comment objectForKey:@"user"];
                                if(user == nil)
                                    continue;
                                NSString* name = [user objectForKey:@"screen_name"];
                                NSString* ID = [user objectForKey:@"id"];
                                if( ([ID compare:herID] != NSOrderedSame )  && ( [ID compare:myID] != NSOrderedSame ))
                                {
                                    CommentMan * man = [[CommentMan alloc] init];
                                    man.ID = ID;
                                    man.name = name;
                                    [resultMenList addObject:man];
                                }
                            }
                        }
                        @catch (NSException *exception) {
                        }
                        @finally {
                            [taskHelper popTask];
                        }

                    }
                    else
                    {
                        [taskHelper popTask];
                    }
                };                
                service.apiBaseUrlString = [CareConstants doubanBaseAPI];
                [service get:query callback:completionBlock];                 }
            // timeline 返回处理结束
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"由于未知原因，获取数据失败" delegate:nil
                                                  cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
            [alert show];
            if(delegate)
            {
                [taskHelper clearTask];
                [delegate fetchComplete:nil];
            }
        }
    };
    
    service.apiBaseUrlString = [CareConstants doubanBaseAPI];
    [service get:query callback:completionBlock];

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
