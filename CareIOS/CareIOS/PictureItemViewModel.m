//
//  PictureItemViewModel.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "PictureItemViewModel.h"
#import "MainViewModel.h"


static NSString * const kSmallURL = @"kSmallURL";
static NSString * const kMiddleURL = @"kMiddleURL";
static NSString * const kLargeURL = @"kLargeURL";
static NSString * const kDescription = @"kDescription";
static NSString * const kTitle = @"kTitle";
static NSString * const kTime = @"kTime";
static NSString * const kID = @"kID";
static NSString * const kType = @"kType";

@implementation PictureItemViewModel
@synthesize size;

@synthesize smallURL;
@synthesize middleURL;
@synthesize largeURL;
@synthesize description;
@synthesize title;
@synthesize time;
@synthesize ID;
@synthesize type;

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTPhoto
- (NSString*)URLForVersion:(TTPhotoVersion)version {
    if (version == TTPhotoVersionLarge) {
        return self.largeURL;
    } else if (version == TTPhotoVersionMedium) {
        return self.middleURL;
    } else if (version == TTPhotoVersionSmall) {
        return self.smallURL;
    } else if (version == TTPhotoVersionThumbnail) {
        return self.smallURL;
    } else {
        return nil;
    }
}

- (id<TTPhotoSource>)photoSource
{
    return [MainViewModel sharedInstance];
}

//- (CGSize)size;
//{
//    return CGSizeZero;
//}

- (NSString*)caption
{
    return self.description;
}

- (NSInteger)index
{
    return [[MainViewModel sharedInstance].pictureItems indexOfObject:self];
}


#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:smallURL forKey:kSmallURL];
    [encoder encodeObject:middleURL forKey:kMiddleURL];
    [encoder encodeObject:largeURL forKey:kLargeURL];
    

    NSNumber* numType = [NSNumber numberWithInt:type];
    [encoder encodeObject:numType forKey:kType];
    
    [encoder encodeObject:description forKey:kDescription];
    [encoder encodeObject:title forKey:kTitle];
    [encoder encodeObject:time forKey:kTime];
    [encoder encodeObject:ID forKey:kID];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        smallURL = [decoder decodeObjectForKey:kSmallURL];
        middleURL = [decoder decodeObjectForKey:kMiddleURL];
        largeURL = [decoder decodeObjectForKey:kLargeURL];
        
        NSNumber* numType = [decoder decodeObjectForKey:kType];        
        type = [numType intValue];
        
        description = [decoder decodeObjectForKey:kDescription];
        title = [decoder decodeObjectForKey:kTime];
        time = [decoder decodeObjectForKey:kTime];
        ID = [decoder decodeObjectForKey:kID];
    }
    return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    PictureItemViewModel *copy = [[[self class] allocWithZone: zone] init];
    copy.smallURL = [self.smallURL copyWithZone:zone];
    copy.middleURL = [self.middleURL copyWithZone:zone];
    copy.largeURL = [self.largeURL copyWithZone:zone];
    
    copy.type = self.type;

    copy.description = [self.description copyWithZone:zone];
    copy.title = [self.title copyWithZone:zone];
    copy.time = [self.time copyWithZone:zone];
    copy.ID = [self.ID copyWithZone:zone];
    return copy;
}


@end
