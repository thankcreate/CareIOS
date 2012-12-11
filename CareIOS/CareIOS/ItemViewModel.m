//
//  ItemViewModel.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "ItemViewModel.h"

@implementation ItemViewModel

@synthesize fromText;
@synthesize timeText;

-(NSString*)fromText
{
    if(self.type == EntryType_SinaWeibo)
    {
        return @"来自新浪微博"; 
    }
    if(self.type == EntryType_Renren)
    {
        return @"来自人人网";
    }
    if(self.type == EntryType_Douban)
    {
        return @"来自豆瓣";
    }
    return @"来自火星";
}


-(NSString*)timeText
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString* strTime = [formatter stringFromDate:self.time];
    return strTime;
}
@end
