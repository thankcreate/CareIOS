//
//  DoubanConverter.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-12.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "DoubanConverter.h"
#import "ItemViewModel.h"
#import "PictureItemViewModel.h"
#import "MiscTool.h"
#import "MainViewModel.h"
#import "CommentViewModel.h"
#import "FriendViewModel.h"
#import "CareConstants.h"
@implementation DoubanConverter
+(FriendViewModel*) convertFrendToCommon:(id)user
{
    FriendViewModel* model = [[FriendViewModel alloc] init];
    @try {
        model.name =[user objectForKey:@"screen_name"];
        model.description =[user objectForKey:@"description"];
        model.avatar =[user objectForKey:@"small_avatar"];
        model.avatar2 =[user objectForKey:@"large_avatar"];
        model.ID =[user objectForKey:@"id"] ;
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}

+(ItemViewModel*) convertStatusToCommon:(id)status
{
    if(status == nil)
        return nil;
    
    ItemViewModel* model;
    @try {
        NSString* type = [status objectForKey:@"type"];
        // 有的时候不带type
        if(type == nil || [type isKindOfClass:[NSNull class]])
        {
            return nil;
        }
        if ([type compare:@"collect_book"] == NSOrderedSame) // 不硬编码不舒服斯基
        {
            model =  [self convertStatusBook:status];
        }
        else if ([type compare:@"collect_movie"] == NSOrderedSame)
        {
            model =  [self convertStatusMovie:status];
        }
        else if ([type compare:@"collect_music"] == NSOrderedSame)
        {
            model =  [self convertStatusMusic:status];
        }
        else if ([type compare:@"text"] == NSOrderedSame)
        {
            model =  [self convertStatusText:status];
        }
        else
        {
//            NSArray* listIgnore = [NSArray arrayWithObject:@"关注", @"加入", @"活动", @"歌曲", @"试读", @"购买了", @"推荐", @"使用"];
            model = nil;
        }
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}

+(ItemViewModel*) convertStatusBook:(id)status
{
    if(status == nil)
        return nil;
    
    ItemViewModel* model;
    @try {
        id user = [status objectForKey:@"user"];
        if(user == nil)
            return nil;
        
        model= [[ItemViewModel alloc] init];
        model.iconURL = [user objectForKey:@"small_avatar"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        model.largeIconURL = [defaults objectForKey:@"Douban_FollowerAvatar2"];
        model.title = [user objectForKey:@"screen_name"];
        
        NSString* bookTitle = @"";
        NSArray* listAttach = [status objectForKey:@"attachments"];
        for(id attach in listAttach)
        {
            NSString* attachType = [attach objectForKey:@"type"];
            if([attachType compare:@"book"] == NSOrderedSame)
            {
                bookTitle = [attach objectForKey:@"title"];
            }
        }     
        NSString* trimStatusTitle = [MiscTool removeDoubanScoreTag:[status objectForKey:@"title"]];
        if(trimStatusTitle == nil)
            trimStatusTitle = @"";
        NSString* statusText = [status objectForKey:@"text"];
        if(statusText == nil)
            statusText = @"";
        
        model.content = [NSString stringWithFormat:@"%@ “%@” %@", trimStatusTitle, bookTitle, statusText];
        model.time = [self convertDoubanDateStringToDate:[status objectForKey:@"created_at"]];
        model.ID = [[status objectForKey:@"id"] stringValue];
        model.commentCount = [[status objectForKey:@"comments_count"] stringValue];
        model.sharedCount = [[status objectForKey:@"reshared_count"] stringValue];
        model.type = EntryType_Douban;
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }

}


+(ItemViewModel*) convertStatusMusic:(id)status
{
    if(status == nil)
        return nil;
    
    ItemViewModel* model;
    @try {
        id user = [status objectForKey:@"user"];
        if(user == nil)
            return nil;
        
        model= [[ItemViewModel alloc] init];
        model.iconURL = [user objectForKey:@"small_avatar"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        model.largeIconURL = [defaults objectForKey:@"Douban_FollowerAvatar2"];
        model.title = [user objectForKey:@"screen_name"];

        NSString* musicTitle = @"";
        NSArray* listAttach = [status objectForKey:@"attachments"];
        for(id attach in listAttach)
        {
            NSString* attachType = [attach objectForKey:@"type"];
            if([attachType compare:@"music"] == NSOrderedSame)
            {
                musicTitle = [attach objectForKey:@"title"];
            }
        }
        
        NSString* trimStatusTitle = [MiscTool removeDoubanScoreTag:[status objectForKey:@"title"]];
        if(trimStatusTitle == nil)
            trimStatusTitle = @"";
        NSString* statusText = [status objectForKey:@"text"];
        if(statusText == nil)
            statusText = @"";
        
        model.content = [NSString stringWithFormat:@"%@ “%@” %@", trimStatusTitle, musicTitle, statusText];
        model.time = [self convertDoubanDateStringToDate:[status objectForKey:@"created_at"]];
        model.ID = [[status objectForKey:@"id"] stringValue];
        model.commentCount = [[status objectForKey:@"comments_count"] stringValue];
        model.sharedCount = [[status objectForKey:@"reshared_count"] stringValue];
        model.type = EntryType_Douban;
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}


+(ItemViewModel*) convertStatusMovie:(id)status
{
    if(status == nil)
        return nil;
    
    ItemViewModel* model;
    @try {
        id user = [status objectForKey:@"user"];
        if(user == nil)
            return nil;
        
        model= [[ItemViewModel alloc] init];
        model.iconURL = [user objectForKey:@"small_avatar"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        model.largeIconURL = [defaults objectForKey:@"Douban_FollowerAvatar2"];
        model.title = [user objectForKey:@"screen_name"];
        
        NSString* movieTitle = @"";
        NSArray* listAttach = [status objectForKey:@"attachments"];
        for(id attach in listAttach)
        {
            NSString* attachType = [attach objectForKey:@"type"];
            if([attachType compare:@"movie"] == NSOrderedSame)
            {
                movieTitle = [attach objectForKey:@"title"];
            }
        }
        
        NSString* trimStatusTitle = [MiscTool removeDoubanScoreTag:[status objectForKey:@"title"]];
        if(trimStatusTitle == nil)
            trimStatusTitle = @"";
        NSString* statusText = [status objectForKey:@"text"];
        if(statusText == nil)
            statusText = @"";
        
        model.content = [NSString stringWithFormat:@"%@ “%@” %@", trimStatusTitle, movieTitle, statusText];
        model.time = [self convertDoubanDateStringToDate:[status objectForKey:@"created_at"]];
        model.ID = [[status objectForKey:@"id"] stringValue];
        model.commentCount = [[status objectForKey:@"comments_count"] stringValue];
        model.sharedCount = [[status objectForKey:@"reshared_count"] stringValue];
        model.type = EntryType_Douban;        
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}


+(ItemViewModel*) convertStatusText:(id)status
{
    if(status == nil)
        return nil;
    
    ItemViewModel* model;
    @try {
        id user = [status objectForKey:@"user"];
        if(user == nil)
            return nil;
        
        model= [[ItemViewModel alloc] init];
        model.iconURL = [user objectForKey:@"small_avatar"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        model.largeIconURL = [defaults objectForKey:@"Douban_FollowerAvatar2"];
        model.title = [user objectForKey:@"screen_name"];
        model.content = [status objectForKey:@"text"];
        
        model.time = [self convertDoubanDateStringToDate:[status objectForKey:@"created_at"]];
        model.ID = [[status objectForKey:@"id"] stringValue];
        model.commentCount = [[status objectForKey:@"comments_count"] stringValue];
        model.sharedCount = [[status objectForKey:@"reshared_count"] stringValue];
        model.type = EntryType_Douban;
        
        id resharedStatus = [status objectForKey:@"reshared_status"];
        if(resharedStatus != nil)
        {
            ItemViewModel* sharedModel = [self convertStatusText:[status objectForKey:@"reshared_status"]];
            if(sharedModel == nil)
                return nil;
            // 如果是转播的话，把model的text改成“转播”两字，不然空在那里很奇怪
            model.content = @"转播";/*你妹*/;
            model.forwardItem = sharedModel;
        }
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}

+(CommentViewModel*) convertCommentToCommon:(id)comment
{
    CommentViewModel* model = [[CommentViewModel alloc] init];
    @try {
        id user = [comment objectForKey:@"user"];
        if(user == nil)
            return nil;
        model.title = [user objectForKey:@"screen_name"];
        model.iconURL = [user objectForKey:@"small_avatar"];
        model.uid = [user objectForKey:@"id"] ;
        model.doubanUID = [user objectForKey:@"uid"];
        
        model.content = [comment objectForKey:@"text"];
        model.ID = [[comment objectForKey:@"id"] stringValue];
        id rawTime = [comment objectForKey:@"created_at"];
        model.time = [self convertDoubanDateStringToDate:rawTime];
        model.type = EntryType_Douban;
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}


// 豆瓣的祼格式是这样的
// 2012-10-03 11:25:26
+ (NSDate*) convertDoubanDateStringToDate:(NSString*) plainDate
{
    if(plainDate == nil)
        return [NSDate date];
    
    NSDate *date = nil;
    @try
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        date=[dateFormatter dateFromString:plainDate];
    }
    @catch (NSException *exception)
    {
        date = [NSDate date];
    }
    @finally
    {
        return date;
    }
}


@end
