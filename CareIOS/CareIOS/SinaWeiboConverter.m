//
//  SinaWeiboConverter.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SinaWeiboConverter.h"
#import "ItemViewModel.h"

@implementation SinaWeiboConverter

+(ItemViewModel*) convertStatusToCommon:(id)status
{
    ItemViewModel* model = [[ItemViewModel alloc] init];
    @try {
        // TODO: picture filt
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
        model.time = [status objectForKey:@"create_at"];
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
            model.forwardItem.time = [forward objectForKey:@"create_at"];
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

@end
