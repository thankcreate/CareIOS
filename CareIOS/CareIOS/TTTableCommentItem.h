//
//  TTTableCommentItem.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-10.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//
#import <Three20UI/Three20UI.h>
@class CommentViewModel;
@class ItemViewModel;
@interface TTTableCommentItem : TTTableTextItem
@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* content;
@property (nonatomic, copy)   NSString* imageURL;
@property (nonatomic, copy)   NSDate* time;

@property (nonatomic, strong) CommentViewModel* commentViewModel;
@property (nonatomic, strong) ItemViewModel* itemViewModel;

+ (id)itemWithTitle:(NSString*)title content:(NSString*)content
           imageURL:(NSString*)imageURL time:(NSDate*)time
   commentViewModel:(CommentViewModel*) commentViewModel
      itemViewModel:(ItemViewModel*)itemViewModel;
@end
