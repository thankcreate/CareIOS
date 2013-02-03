//
//  RenrenConverter.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-11.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "RenrenConverter.h"
#import "ItemViewModel.h"
#import "PictureItemViewModel.h"
#import "MiscTool.h"
#import "MainViewModel.h"
#import "CommentViewModel.h"
#import "FriendViewModel.h"
#import "CareConstants.h"
@implementation RenrenConverter

+(FriendViewModel*) convertFrendToCommon:(ROFriendResponseItem*)afriend
{
    FriendViewModel* model = [[FriendViewModel alloc] init];
    @try {
        model.name = afriend.name;
        model.description = @"";
        model.avatar = afriend.tinyUrl;
        model.avatar2 = afriend.headUrl;
        model.ID = afriend.userId;
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
    @try {
        if(status == nil)
           return nil;
        NSNumber* type = [status objectForKey:@"feed_type"];
        if(type == nil)
            return nil;
        int tp = [type integerValue];
        if(tp == RenrenNews_TextStatus)
        {
            return [self convertTextStatus:status];
        }
        else if(tp == RenrenNews_UploadPhoto)
        {
            return [self convertTextUploadPhoto:status];
        }
        else if(tp == RenrenNews_SharePhoto)
        {
            return [self convertTextSharePhoto:status];   
        }
        return nil;
    }
    @catch (NSException *exception) {
        return nil;
    }
}

+(ItemViewModel*)convertTextStatus:(id)status
{
    ItemViewModel* model = [[ItemViewModel alloc] init];
    @try {
        if(status == nil)
            return nil;
        model.iconURL = [status objectForKey:@"headurl"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        model.largeIconURL = [defaults objectForKey:@"Renren_FollowerAvatar2"];
        
        model.title = [status objectForKey:@"name"];
        // remove html tag
        model.content = [status objectForKey:@"prefix"];
        
        NSString* plainTime = [status objectForKey:@"update_time"];
        model.time = [self convertRenrenDateStringToDate:plainTime];
        
        model.type = EntryType_Renren;
        model.ID = [[status objectForKey:@"source_id"] stringValue];
        model.ownerID = [[status objectForKey:@"actor_id"] stringValue];
        model.renrenFeedType = RenrenNews_TextStatus;
        
        id comments = [status objectForKey:@"comments"];
        model.commentCount = [[comments objectForKey:@"count"] stringValue];
        model.sharedCount = @"";
        
        id attachment = [status objectForKey:@"attachment"];
        // 检查转发
        if(attachment)
        {
            for(id attach in attachment)
            {
                NSString* attachType = [attach objectForKey:@"media_type"];
                if([attachType compare:@"status"] == NSOrderedSame)
                {
                    model.forwardItem = [[ItemViewModel alloc] init];
                    model.forwardItem.title = [attach objectForKey:@"owner_name"];
                    model.forwardItem.content = [attach objectForKey:@"content"];
                }
            }
        }

    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}


+(ItemViewModel*)convertTextUploadPhoto:(id)status
{
    ItemViewModel* model = [[ItemViewModel alloc] init];
    @try {
        if(status == nil)
            return nil;
        id attachment = [status objectForKey:@"attachment"];
        if(attachment == nil)
            return nil;        
        
        model.iconURL = [status objectForKey:@"headurl"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        model.largeIconURL = [defaults objectForKey:@"Renren_FollowerAvatar2"];
        model.title = [status objectForKey:@"name"];
        
        NSString* plainTime = [status objectForKey:@"update_time"];
        model.time = [self convertRenrenDateStringToDate:plainTime];
        model.type = EntryType_Renren;
        
        model.ownerID = [[status objectForKey:@"actor_id"] stringValue];
        
        model.renrenFeedType = RenrenNews_UploadPhoto;
        id comments = [status objectForKey:@"comments"];
        model.commentCount = [[comments objectForKey:@"count"] stringValue];
        model.sharedCount = @"";
        
        for(id attach in attachment)
        {
            NSString* attachType = [attach objectForKey:@"media_type"];
            if([attachType compare:@"photo"] == NSOrderedSame)
            {
                model.content = [MiscTool removeHTMLTag:[attach objectForKey:@"content"]];
                model.imageURL = [attach objectForKey:@"src"];
                model.midImageURL = [attach objectForKey:@"src"];
                model.fullImageURL = [attach objectForKey:@"raw_src"];
                model.ID = [[attach objectForKey:@"media_id"] stringValue];
                
                PictureItemViewModel* pic = [[PictureItemViewModel alloc] init];
                pic.smallURL = model.imageURL;
                pic.middleURL = model.midImageURL;
                pic.largeURL = model.fullImageURL;
                pic.ID = model.ID;
                pic.title = model.title;
                pic.description = model.content;
                pic.time = model.time;
                pic.type = EntryType_Renren;
                [[MainViewModel sharedInstance].renrenPictureItems addObject:pic];
            }
        }

    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}


+(ItemViewModel*)convertTextSharePhoto:(id)status
{
    
    ItemViewModel* model = [[ItemViewModel alloc] init];
    @try {
        if(status == nil)
            return nil;
        id attachment = [status objectForKey:@"attachment"];
        if(attachment == nil)
            return nil;
        
        model.iconURL = [status objectForKey:@"headurl"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        model.largeIconURL = [defaults objectForKey:@"Renren_FollowerAvatar2"];
        model.title = [status objectForKey:@"name"];

        model.content = [MiscTool removeHTMLTag:[status objectForKey:@"message"]];
        NSString* plainTime = [status objectForKey:@"update_time"];
        model.time = [self convertRenrenDateStringToDate:plainTime];
        model.type = EntryType_Renren;
        
        model.ID = [[status objectForKey:@"source_id"] stringValue];
        model.ownerID = [[status objectForKey:@"actor_id"] stringValue];
        
        model.renrenFeedType = RenrenNews_SharePhoto;
        id comments = [status objectForKey:@"comments"];
        model.commentCount = [[comments objectForKey:@"count"] stringValue];
        model.sharedCount = @"";

        for(id attach in attachment)
        {
            NSString* attachType = [attach objectForKey:@"media_type"];
            if([attachType compare:@"photo"] == NSOrderedSame)
            {
                model.forwardItem = [[ItemViewModel alloc] init];
                model.forwardItem.title = [attach objectForKey:@"owner_name"];

                model.forwardItem.content = [MiscTool removeHTMLTag:[status objectForKey:@"description"]];
                
                model.forwardItem.imageURL = [attach objectForKey:@"src"];
                model.forwardItem.midImageURL = [attach objectForKey:@"src"];
                model.forwardItem.fullImageURL = [attach objectForKey:@"raw_src"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString* useFowardPicture = [defaults objectForKey:@"Global_NeedFetchImageInRetweet"];
                if(useFowardPicture == nil || [useFowardPicture compare:@"YES"] == NSOrderedSame)
                {
                    PictureItemViewModel* pic = [[PictureItemViewModel alloc] init];
                    pic.smallURL = model.forwardItem.imageURL;
                    pic.middleURL = model.forwardItem.midImageURL;
                    pic.largeURL = model.forwardItem.fullImageURL;
                    pic.ID = model.ID;
                    pic.title = model.title;
                    pic.description = model.content;
                    pic.time = model.time;
                    pic.type = EntryType_Renren;
                    
                    [[MainViewModel sharedInstance].renrenPictureItems addObject:pic];
                }
            }
        }
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}

+(CommentViewModel*) convertCommentToCommon:(id)comment renrenType:(RenrenNewsType)renrenType
{
    CommentViewModel* model = [[CommentViewModel alloc] init];
    @try {
        if(renrenType == RenrenNews_TextStatus)
        {
            model.title = [comment objectForKey:@"name"];
            model.iconURL = [comment objectForKey:@"tinyurl"];
            model.content = [comment objectForKey:@"text"];
            model.ID = [comment objectForKey:@"comment_id"];
            NSString* plainTime = [comment objectForKey:@"time"];
            model.time = [self convertRenrenDateStringToDate:plainTime];
        }
        else if (renrenType == RenrenNews_UploadPhoto)
        {
            model.title = [comment objectForKey:@"name"];
            model.iconURL = [comment objectForKey:@"headurl"];
            model.content = [comment objectForKey:@"text"];
            model.ID = [comment objectForKey:@"comment_id"];
            NSString* plainTime = [comment objectForKey:@"time"];
            model.time = [self convertRenrenDateStringToDate:plainTime];
        }
        else if (renrenType == RenrenNews_SharePhoto)
        {
            model.title = [comment objectForKey:@"name"];
            model.iconURL = [comment objectForKey:@"headurl"];
            model.content = [comment objectForKey:@"content"];
            model.ID = [comment objectForKey:@"id"];
            NSString* plainTime = [comment objectForKey:@"time"];
            model.time = [self convertRenrenDateStringToDate:plainTime];
        }
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
}


// 人人的祼格式是这样的
// 2012-12-07 20:37:36
+ (NSDate*) convertRenrenDateStringToDate:(NSString*) plainDate
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
