//
//  DoubanConverter.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-12.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriendViewModel;
@class ItemViewModel;
@class CommentViewModel;

@interface DoubanConverter : NSObject
+(FriendViewModel*) convertFrendToCommon:(ROFriendResponseItem*)afriend;
+(ItemViewModel*) convertStatusUnion:(id)status;
+(ItemViewModel*) convertStatusToCommon:(id)status;
+(CommentViewModel*) convertCommentToCommon:(id)comment;
@end
