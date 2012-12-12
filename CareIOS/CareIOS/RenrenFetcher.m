//
//  RenrenFetcher.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-11.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "RenrenFetcher.h"
#import "MiscTool.h"
#import "CareAppDelegate.h"

@implementation RenrenFetcher
@synthesize delegate;
@synthesize resultMenList;

-(id)initWithDelegate:(id<FetcherDelegate>)del
{
    if(!(self = [super init]))
    {
        return nil;
    }
    resultMenList = [NSMutableArray arrayWithCapacity:50];
    delegate = del;
    return self;
}

-(void)startFetchCommentMan
{
    [resultMenList removeAllObjects];
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    Renren* renren =  appDelegate.renren;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herID = [defaults objectForKey:@"Renren_FollowerID"];
    
    if( ![renren isSessionValid] || herID == nil)
    {
        [delegate fetchComplete:nil];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"feed.get" forKey:@"method"];
    [dic setObject:herID forKey:@"uid"];
    [dic setObject:@"50" forKey:@"count"];
    [dic setObject:@"10,30,32" forKey:@"type"];
    [renren requestWithParams:dic andDelegate:self];
}

#pragma mark - Renren Delegate
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* herID = [defaults objectForKey:@"Renren_FollowerID"];
    NSString* myID = [defaults objectForKey:@"Renren_ID"];

    [resultMenList removeAllObjects];
    NSArray *statuses = (NSArray *)(response.rootObject);
    for(id status in statuses)
    {
        @try {
            id commentsWrapper = [status objectForKey:@"comments"];
            if(commentsWrapper == nil)
                continue;
            NSArray* commentArray = [commentsWrapper objectForKey:@"comment"];
            if(commentArray == nil || commentArray.count == 0)
                continue;
            for(id comment in commentArray)
            {
                NSString* ID = [[comment objectForKey:@"uid"] stringValue];
                NSString* name = [comment objectForKey:@"name"];
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
            continue;
        }
    }
    if(delegate)
    {
        [delegate fetchComplete:resultMenList];
    }
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"由于未知原因，获取数据失败" delegate:nil
                                          cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
    [alert show];
    if(delegate)
    {
        [delegate fetchComplete:nil];
    }
}

@end
