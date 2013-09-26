//
//  TTTableBlessItem.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-7.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>
@class BlessItemViewModel;
@interface TTTableBlessItem : TTTableTextItem
@property (nonatomic, copy)   NSString* name;
@property (nonatomic, copy)   NSString* content;
@property (nonatomic, copy)   NSDate* time;
@property (nonatomic)   NSInteger index;  // index 仅用来判断左右


+ (id)itemWithBlessItemViewModel:(BlessItemViewModel*)model;
@end
