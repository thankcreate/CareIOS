//
//  RSSFeedConverter.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "RSSFeedConverter.h"
#import "ItemViewModel.h"
#import "MWFeedParser.h"

@implementation RSSFeedConverter

+(ItemViewModel*) convertFeedToCommon:(MWFeedItem*)item
{
    ItemViewModel* model = [[ItemViewModel alloc] init];
    @try {
        model.title = item.title;
        model.time = item.date;
        model.rssSummary = item.summary;
        // 因为在timeline上不方便显示太多内容，所以把content设为summary的前面一部分
        model.content = [self getFirst50:item.summary];
        model.ID = item.identifier;
        model.originalURL = item.link;
        model.type = EntryType_RSS;
    }
    @catch (NSException *exception) {
        model = nil;
    }
    @finally {
        return model;
    }
    

}

+(NSString*)getFirst50:(NSString*)input
{
    NSString* res = [MiscTool removeHTMLTag:input];
    if(res == nil)
        return nil;
    if(res.length < 85)
        return res;
    res =  [NSString stringWithFormat:@"%@...",[res substringToIndex:85]];
    return res;
}

@end
