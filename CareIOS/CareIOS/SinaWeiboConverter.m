//
//  SinaWeiboConverter.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SinaWeiboConverter.h"
#import "ItemViewModel.h"
#import "PictureItemViewModel.h"
#import "MiscTool.h"
#import "MainViewModel.h"
@implementation SinaWeiboConverter

+(ItemViewModel*) convertStatusToCommon:(id)status
{
    ItemViewModel* model = [[ItemViewModel alloc] init];
    @try {
        // 先做图片过滤
        [self convertPictureToCommon:status];
        
        id user = [status objectForKey:@"user"];
        if(user == nil)
            return nil;
        
        model.iconURL = [user objectForKey:@"profile_image_url"];
        model.largeIconURL = [user objectForKey:@"avatar_large"];
        model.title = [user objectForKey:@"name"];
        model.content = [status objectForKey:@"text"];
        // TODO: confirm gif format can show well
        model.imageURL = [status objectForKey:@"thumbnail_pic"];
        model.midImageURL = [status objectForKey:@"bmiddle_pic"];
        model.fullImageURL = [status objectForKey:@"original_pic"];
        
        id rawTime = [status objectForKey:@"created_at"];
        model.time = [self convertSinaWeiboDateStringToDate:rawTime];
        
        model.ID = [status objectForKey:@"id"];
        model.type = EntryType_SinaWeibo;
        model.sharedCount = [[status objectForKey:@"reposts_count"] stringValue];
        model.commentCount = [[status objectForKey:@"comments_count"] stringValue];
        
        id forward = [status objectForKey:@"retweeted_status"];
        if(forward != nil)
        {
            model.forwardItem = [[ItemViewModel alloc] init];
            id forwardUser = [forward objectForKey:@"user"];
            if(user == nil)
                return nil;
            model.forwardItem.iconURL = [forwardUser objectForKey:@"profile_image_url"];
            model.forwardItem.largeIconURL = [forwardUser objectForKey:@"avatar_large"];
            model.forwardItem.title = [forwardUser objectForKey:@"name"];
            model.forwardItem.content = [forward objectForKey:@"text"];
            // TODO: confirm gif format can show well
            model.forwardItem.imageURL = [forward objectForKey:@"thumbnail_pic"];
            model.forwardItem.midImageURL = [forward objectForKey:@"bmiddle_pic"];
            model.forwardItem.fullImageURL = [forward objectForKey:@"original_pic"];
            model.forwardItem.time = [self convertSinaWeiboDateStringToDate:[forward objectForKey:@"created_at"]];
            model.forwardItem.ID = [forward objectForKey:@"id"];
            model.forwardItem.type = EntryType_SinaWeibo;
            model.forwardItem.sharedCount = [[forward objectForKey:@"reposts_count"] stringValue];
            model.forwardItem.commentCount = [[forward objectForKey:@"comments_count"] stringValue];
        }
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}

+(PictureItemViewModel*) convertPictureToCommon:(id)status
{
    PictureItemViewModel* model = [[PictureItemViewModel alloc] init];
    model.size = CGSizeZero;
    if(model == nil)
        return nil;
    @try {
        // 先判断是否有转发图片
        id forward = [status objectForKey:@"retweeted_status"];
        if(forward != nil)
        {
            return [self convertPictureToCommon:forward];
        }
        model.smallURL = [status objectForKey:@"thumbnail_pic"];
        model.middleURL = [status objectForKey:@"bmiddle_pic"];
        model.largeURL = [status objectForKey:@"original_pic"];
        model.ID = [status objectForKey:@"id"];
        model.description = [status objectForKey:@"text"];
        id rawTime = [status objectForKey:@"created_at"];
        model.time = [self convertSinaWeiboDateStringToDate:rawTime];
        
        id user = [status objectForKey:@"user"];
        if(user != nil)
        {
            model.title = [user objectForKey:@"[name"];;
        }
        if(model.smallURL.length)
        {
            [[MainViewModel sharedInstance].sinaWeiboPictureItems addObject:model];
        }
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
    
}


// 新浪的祼格式是这样的
// Fri Oct 05 11:38:16 +0800 2012
+ (NSDate*) convertSinaWeiboDateStringToDate:(NSString*) plainDate
{    
    if(plainDate == nil)
        return [NSDate date];
    
    NSDate *date = nil;
    @try
    {
        //plainDate = @"Mon Nov 26 00:17:07 2012";
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss zzz yyyy"];
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
