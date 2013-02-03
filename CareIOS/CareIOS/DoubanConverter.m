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


// 现在豆瓣把有的新鲜事我都从这里来convert了，从此以后不严格区分豆瓣广播种类
+(ItemViewModel*) convertStatusUnion:(id)status
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
        
        NSString* attachTitle = @"";
        NSArray* listAttach = [status objectForKey:@"attachments"];
        if(listAttach != nil)
        {
            for(id attach in listAttach)
            {
                // 这里现在不严格区分type了
                // NSString* attachType = [attach objectForKey:@"type"];
                attachTitle = [attach objectForKey:@"title"];
            }
        }

        NSString* trimStatusTitle = [MiscTool removeDoubanScoreTag:[status objectForKey:@"title"]];
        if(trimStatusTitle == nil)
            trimStatusTitle = @"";
        NSString* statusText = [status objectForKey:@"text"];
        if(statusText == nil)
            statusText = @"";
        
        model.content = [NSString stringWithFormat:@"%@ %@ %@", trimStatusTitle, attachTitle, statusText];
        model.time = [self convertDoubanDateStringToDate:[status objectForKey:@"created_at"]];
        model.ID = [[status objectForKey:@"id"] stringValue];
        model.commentCount = [[status objectForKey:@"comments_count"] stringValue];
        model.sharedCount = [[status objectForKey:@"reshared_count"] stringValue];
        model.type = EntryType_Douban;
        
        id forwardStatus = [status objectForKey:@"reshared_status"];
        if(forwardStatus != nil)
        {
            ItemViewModel* forwardModel = [[ItemViewModel alloc] init];
            id forwardUser = [forwardStatus objectForKey:@"user"];
            if(forwardUser == nil)
                return nil;

            forwardModel.iconURL = [forwardUser objectForKey:@"small_avatar"];           
            forwardModel.largeIconURL = forwardModel.iconURL;
            forwardModel.title = [forwardUser objectForKey:@"screen_name"];
            
            NSString* forwardAttachTitle = @"";
            NSArray* forwardListAttach = [forwardStatus objectForKey:@"attachments"];
            if(forwardListAttach != nil)
            {
                for(id attach in forwardListAttach)
                {
                    // 这里现在不严格区分type了
                    // NSString* attachType = [attach objectForKey:@"type"];
                    forwardAttachTitle = [attach objectForKey:@"title"];
                }
            }
            
            NSString* trimForwardStatusTitle = [MiscTool removeDoubanScoreTag:[forwardStatus objectForKey:@"title"]];
            if(trimForwardStatusTitle == nil)
                trimForwardStatusTitle = @"";
            NSString* forwardStatusText = [forwardStatus objectForKey:@"text"];
            if(forwardStatusText == nil)
                forwardStatusText = @"";
            
            forwardModel.content = [NSString stringWithFormat:@"%@ %@ %@", trimForwardStatusTitle, forwardAttachTitle, forwardStatusText];
            forwardModel.time = [self convertDoubanDateStringToDate:[forwardStatus objectForKey:@"created_at"]];
            forwardModel.ID = [[forwardStatus objectForKey:@"id"] stringValue];
            forwardModel.commentCount = [[forwardStatus objectForKey:@"comments_count"] stringValue];
            forwardModel.sharedCount = [[forwardStatus objectForKey:@"reshared_count"] stringValue];
            forwardModel.type = EntryType_Douban;
            NSString* useFowardPicture = [defaults objectForKey:@"Global_NeedFetchImageInRetweet"];
            if(useFowardPicture == nil || [useFowardPicture compare:@"YES"] == NSOrderedSame)
            {
                [self filtPictureWithStatus:forwardStatus itemViewModel:forwardModel];
            }
            
            // 如果是转播，把model的text改成“转播”两字，不然空在那里很奇怪
            model.content = @"转播";
            model.commentCount = forwardModel.commentCount;
            model.sharedCount = forwardModel.sharedCount;
            model.forwardItem = forwardModel;
        }
        [self filtPictureWithStatus:status itemViewModel:model];
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
        [self filtPictureWithStatus:status itemViewModel:model];
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
        [self filtPictureWithStatus:status itemViewModel:model];
        
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
                break;
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
        [self filtPictureWithStatus:status itemViewModel:model];
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
        [self filtPictureWithStatus:status itemViewModel:model];
        
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



// 这一步需要在解析status的最后一步来做
// 因为其description依赖于itemViewModel的content
+(void)filtPictureWithStatus:(id)status itemViewModel:(ItemViewModel*)itemViewModel
{
    NSArray* listAttach = [status objectForKey:@"attachments"];
    for(id attach in listAttach)
    {
//        NSString* attachType = [attach objectForKey:@"type"];
//        if([attachType compare:@"movie"] == NSOrderedSame
//           || [attachType compare:@"music"] == NSOrderedSame
//           || [attachType compare:@"book"] == NSOrderedSame
//           || [attachType compare:@"image"] == NSOrderedSame)
        {
            // 抓图
            NSArray* listMedia =[attach objectForKey:@"media"];
            for(id media in listMedia)
            {
                NSString* mediaType =  [media objectForKey:@"type"];
                if([mediaType compare:@"image"] == NSOrderedSame)
                {
                    PictureItemViewModel* model = [[PictureItemViewModel alloc] init];
                    // 豆瓣虽然只给了一个src,但是它的中图和大图是直接把链接中的small替换成median或raw就行了
                    model.smallURL = [media objectForKey:@"src"];
                    model.middleURL = [self convertURLFrom:model.smallURL to:@"median"];
                    model.largeURL = [self convertURLFrom:model.smallURL to:@"raw"];
                    model.ID = itemViewModel.ID;
                    model.description = itemViewModel.content;
                    model.time = itemViewModel.time;                    
                    model.title = itemViewModel.title;
                    model.type = EntryType_Douban;
                    if(model.smallURL.length)
                    {
                        [[MainViewModel sharedInstance].doubanPictureItems addObject:model];
                    }
                    
                    // 反过来设置ItemViewModel的图片参数
                    itemViewModel.imageURL = model.smallURL;
                    itemViewModel.midImageURL = model.middleURL;
                    itemViewModel.fullImageURL = model.largeURL;
                    break;
                }                
            }
            break;
        }
    }
}

+(NSString*)convertURLFrom:(NSString*) smallURL to:(NSString*)to
{
    NSString *s = [smallURL copy];
    NSRange r;
    r = [s rangeOfString:@"small" options:NSRegularExpressionSearch];
    if(r.location != NSNotFound)
    {
        s = [s stringByReplacingCharactersInRange:r withString:to];
        return s;
    }
    else
    {
        return smallURL;
    };
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
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
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
