//
//  TTTableCommentItem.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-10.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTTableCommentItem.h"

@implementation TTTableCommentItem

+ (id)itemWithTitle:(NSString*)title content:(NSString*)content
           imageURL:(NSString*)imageURL time:(NSDate*)time
   commentViewModel:(CommentViewModel*) commentViewModel
      itemViewModel:(ItemViewModel*)itemViewModel
{
    TTTableCommentItem* item = [[TTTableCommentItem alloc] init];
    item.title = title;
    item.content = content;
    item.imageURL = imageURL;
    item.time = time;
    item.commentViewModel = commentViewModel;
    item.itemViewModel = itemViewModel;
    return item;
}

@end
