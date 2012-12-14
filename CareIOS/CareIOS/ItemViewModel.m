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
@synthesize contentWithTitle;
@synthesize commentCount = _commentCount;
-(NSString*)fromText
{
    if(self.type == EntryType_SinaWeibo)
    {
        return @"来自新浪微博"; 
    }
    else if(self.type == EntryType_Renren)
    {
        return @"来自人人网";
    }
    else if(self.type == EntryType_Douban)
    {
        return @"来自豆瓣";
    }
    else if(self.type == EntryType_RSS)
    {
        return @"来自RSS订阅";
    }
    
    
    return @"来自火星";
}

-(NSString*)commentCount
{
    if(_commentCount == nil)
        return @"0";
    else
        return _commentCount;
}


-(NSString*)timeText
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString* strTime = [formatter stringFromDate:self.time];
    return strTime;
}

-(NSString*)contentWithTitle
{
    NSString* firstPart = self.title;
    if(firstPart == nil)
        firstPart = @"";
    NSString* secondPart = self.content;
    if(secondPart == nil)
        secondPart = @"";
    return [NSString stringWithFormat:@"%@: %@",firstPart, secondPart];
}

@end
