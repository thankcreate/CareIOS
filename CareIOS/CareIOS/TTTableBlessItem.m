//
//  TTTableBlessItem.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-7.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "TTTableBlessItem.h"
#import "BlessItemViewModel.h"
@implementation TTTableBlessItem

@synthesize name;
@synthesize content;
@synthesize time;
+ (id)itemWithBlessItemViewModel:(BlessItemViewModel*)model
{
    TTTableBlessItem* item = [[TTTableBlessItem alloc] init];
    item.name = model.title;
    item.content = model.content;
    item.time = model.time;
    return item;
}
@end
