//
//  TTSectionedDataSource+CareCell.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTSectionedDataSource+CareCell.h"
#import "TTTableCommentItem.h"
#import "TTTableCommentItemCell.h"
#import "TTTableStatusItem.h"
#import "TTTableStatusItemCell.h"
#import "TTTableChatItem.h"
#import "TTTableChatItemCell.h"

@implementation TTSectionedDataSource (CareCell)
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[TTTableCommentItem class]])
    {
        return [TTTableCommentItemCell class];
    }
    else if([object isKindOfClass:[TTTableStatusItem class]])
    {
        return [TTTableStatusItemCell class];
    }
    else if([object isKindOfClass:[TTTableChatItem class]])
    {
        return [TTTableChatItemCell class];
    }
    else
    {
        return [super tableView:tableView cellClassForObject:object];
    }
}
@end
