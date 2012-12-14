//
//  RSSFeedConverter.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ItemViewModel;
@class MWFeedItem;
@interface RSSFeedConverter : NSObject
+(ItemViewModel*) convertFeedToCommon:(MWFeedItem*)item;
@end
