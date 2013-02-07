//
//  BlessItemViewModel.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-4.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "BlessItemViewModel.h"

@implementation BlessItemViewModel
@synthesize time;
@synthesize title;
@synthesize content;
@synthesize isPassed;


static NSString * const kTitle = @"kTitle";
static NSString * const kContent = @"kContent";
static NSString * const kTime = @"kTime";
static NSString * const kIsPassed = @"kIsPassed";


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:content forKey:kContent];
    [encoder encodeObject:title forKey:kTitle];
    [encoder encodeObject:time forKey:kTime];
    
    NSNumber* numIsPassed = [NSNumber numberWithInt:isPassed];
    [encoder encodeObject:numIsPassed forKey:kIsPassed];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
       
        time = [decoder decodeObjectForKey:kTime];
        content = [decoder decodeObjectForKey:kContent];
        title = [decoder decodeObjectForKey:kTitle];
        
        NSNumber* numIsPassed = [decoder decodeObjectForKey:kIsPassed];
        isPassed = [numIsPassed intValue];
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    BlessItemViewModel *copy = [[[self class] allocWithZone: zone] init];
    copy.time = [self.time copyWithZone:zone];
    copy.isPassed = self.isPassed;
    copy.content = [self.content copyWithZone:zone];
    copy.title = [self.title copyWithZone:zone];
    return copy;
}
@end
