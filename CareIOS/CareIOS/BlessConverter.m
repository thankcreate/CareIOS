//
//  BlessConverter.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-4.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "BlessConverter.h"
#import "BlessItemViewModel.h"
#import "MiscTool.h"
@implementation BlessConverter
+(BlessItemViewModel*) convertToViewModel:(id)item;
{
    if(item  == nil)
        return nil;
    BlessItemViewModel* model = [[BlessItemViewModel alloc] init];
    @try {
        model.title = [item objectForKey:@"name"];
        if([MiscTool isNilOrEmpty:model.title])
        {
            model.title = @"匿名";
        }
        
        model.content = [item objectForKey:@"content"];
        NSString* strTimestamp = [item objectForKey:@"time"];
        NSInteger nTimestamp = [strTimestamp intValue];
        model.time = [NSDate dateWithTimeIntervalSince1970:nTimestamp];
    }
    @catch (NSException *exception) {
        model = nil;
    }
    return model;
}
@end
