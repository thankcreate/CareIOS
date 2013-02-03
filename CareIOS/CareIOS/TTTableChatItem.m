//
//  TTTableChatItem.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "TTTableChatItem.h"
#import "ChatItemViewModel.h"


@implementation TTTableChatItem

+ (id)itemWithChatItemViewModel:(ChatItemViewModel*)model
{
    TTTableChatItem* item = [[TTTableChatItem alloc] init];
    item.title = model.title;
    item.content = model.content;
    item.imageURL = model.iconURL;
    item.time = model.time;
    item.type = model.type;
    return item;
}
@end
