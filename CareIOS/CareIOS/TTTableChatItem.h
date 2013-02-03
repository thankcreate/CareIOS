//
//  TTTableChatItem.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>
@class ChatItemViewModel;
@interface TTTableChatItem : TTTableTextItem
@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* content;
@property (nonatomic, copy)   NSString* imageURL;
@property (nonatomic, copy)   NSDate* time;
@property (nonatomic) ChatType type;
+ (id)itemWithChatItemViewModel:(ChatItemViewModel*)model;
@end
