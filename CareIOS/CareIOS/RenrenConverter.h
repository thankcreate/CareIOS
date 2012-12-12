//
//  RenrenConverter.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-11.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CareConstants.h"
@class FriendViewModel;
@class ItemViewModel;
@class CommentViewModel;

@interface RenrenConverter : NSObject
+(FriendViewModel*) convertFrendToCommon:(ROFriendResponseItem*)afriend;
+(ItemViewModel*) convertStatusToCommon:(id)status;
+(CommentViewModel*) convertCommentToCommon:(id)comment renrenType:(RenrenNewsType)renrenType;
@end
