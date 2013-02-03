//
//  ChatItemViewModel.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "ChatItemViewModel.h"

@implementation ChatItemViewModel

@synthesize title;
@synthesize iconURL;
@synthesize content;
@synthesize time;
@synthesize type;

static NSString * const kIconURL = @"kIconURL";
static NSString * const kTitle = @"kTitle";
static NSString * const kContent = @"kContent";
static NSString * const kTime = @"kTime";
static NSString * const kType = @"kType";



#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:iconURL forKey:kIconURL];
    [encoder encodeObject:content forKey:kContent];
    [encoder encodeObject:title forKey:kTitle];
    [encoder encodeObject:time forKey:kTime];
    
    NSNumber* numType = [NSNumber numberWithInt:type];
    [encoder encodeObject:numType forKey:kType];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        iconURL = [decoder decodeObjectForKey:kIconURL];
        time = [decoder decodeObjectForKey:kTime];
        content = [decoder decodeObjectForKey:kContent];
        title = [decoder decodeObjectForKey:kTitle];
        
        NSNumber* numType = [decoder decodeObjectForKey:kType];
        type = [numType intValue];
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    ChatItemViewModel *copy = [[[self class] allocWithZone: zone] init];
    copy.iconURL = [self.iconURL copyWithZone:zone];
    copy.time = [self.time copyWithZone:zone];
    copy.type = self.type;
    copy.content = [self.content copyWithZone:zone];
    copy.title = [self.title copyWithZone:zone];    
    return copy;
}


@end
