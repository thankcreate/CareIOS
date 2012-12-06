//
//  ItemViewModel.h
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CareConstants.h"


@interface ItemViewModel : NSObject
@property (strong, nonatomic) NSString* iconURL;
@property (strong, nonatomic) NSString* largeIconURL;

@property (strong, nonatomic) NSString* imageURL;
@property (strong, nonatomic) NSString* midImageURL;
@property (strong, nonatomic) NSString* fullImageURL;

@property (strong, nonatomic) NSDate* time;

@property (nonatomic) EntryType type;

@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* rssSummary;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* originalURL;
@property (strong, nonatomic) NSString* description;
@property (strong, nonatomic) NSString* ownerID;
@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSString* commentCount;
@property (strong, nonatomic) NSString* sharedCount;

@property (strong, nonatomic) NSString* renrenFeedType;
@property (strong, nonatomic) ItemViewModel* forwardItem;
@end
