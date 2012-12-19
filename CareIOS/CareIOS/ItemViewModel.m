//
//  ItemViewModel.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "ItemViewModel.h"

static NSString * const kIconURL = @"kIconUR";
static NSString * const kLargeIconURL = @"kLargeIconURL";
static NSString * const kImageURL = @"kImageURL";
static NSString * const kMidImageURL = @"kMidImageURL";
static NSString * const kFullImageURL = @"kFullImageURL";
static NSString * const kTime = @"kTime";
static NSString * const kType = @"kType";
static NSString * const kRenrenFeedType = @"kRenrenFeedType";
static NSString * const kContent = @"kContent";
static NSString * const kRssSummary = @"kRssSummary";
static NSString * const kTitle = @"kTitle";
static NSString * const kOriginalURL = @"kOriginalURL";
static NSString * const kDescription = @"kDescription";
static NSString * const kOwnerID = @"kOwnerID";
static NSString * const kID = @"kID";
static NSString * const kCommentCount = @"kCommentCount";
static NSString * const kSharedCount = @"kSharedCount";
static NSString * const kForwardItem = @"kForwardItem";



@implementation ItemViewModel

@synthesize fromText;
@synthesize timeText;
@synthesize contentWithTitle;
@synthesize commentCount = _commentCount;

@synthesize iconURL;
@synthesize largeIconURL;
@synthesize imageURL;
@synthesize midImageURL;
@synthesize fullImageURL;
@synthesize time;
@synthesize type;
@synthesize renrenFeedType;
@synthesize content;
@synthesize rssSummary;
@synthesize title;
@synthesize originalURL;
@synthesize description;
@synthesize ownerID;
@synthesize ID;
@synthesize sharedCount;
@synthesize forwardItem;

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

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:iconURL forKey:kIconURL];
    [encoder encodeObject:largeIconURL forKey:kLargeIconURL];
    
    [encoder encodeObject:imageURL forKey:kImageURL];
    [encoder encodeObject:midImageURL forKey:kMidImageURL];
    [encoder encodeObject:fullImageURL forKey:kFullImageURL];
    
    [encoder encodeObject:time forKey:kTime];
    NSNumber* numType = [NSNumber numberWithInt:type];
    NSNumber* numRenrenFeedType = [NSNumber numberWithInt:renrenFeedType];
    [encoder encodeObject:numType forKey:kType];
    [encoder encodeObject:numRenrenFeedType forKey:kRenrenFeedType];
    [encoder encodeObject:content forKey:kContent];
    [encoder encodeObject:rssSummary forKey:kRssSummary];
    [encoder encodeObject:title forKey:kTitle];
    [encoder encodeObject:originalURL forKey:kOriginalURL];
    [encoder encodeObject:description forKey:kDescription];
    [encoder encodeObject:ownerID forKey:kOwnerID];
    [encoder encodeObject:ID forKey:kID];
    [encoder encodeObject:self.commentCount forKey:kCommentCount];
    [encoder encodeObject:sharedCount forKey:kSharedCount];
    [encoder encodeObject:forwardItem forKey:kForwardItem];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        iconURL = [decoder decodeObjectForKey:kIconURL];
        largeIconURL = [decoder decodeObjectForKey:kLargeIconURL];
        imageURL = [decoder decodeObjectForKey:kImageURL];
        midImageURL = [decoder decodeObjectForKey:kMidImageURL];
        fullImageURL = [decoder decodeObjectForKey:kFullImageURL];
        
        time = [decoder decodeObjectForKey:kTime];
        NSNumber* numType = [decoder decodeObjectForKey:kType];
        NSNumber* numRenrenFeedType = [decoder decodeObjectForKey:kRenrenFeedType];
        type = [numType intValue];
        renrenFeedType = [numRenrenFeedType intValue];
        content = [decoder decodeObjectForKey:kContent];
        rssSummary = [decoder decodeObjectForKey:kRssSummary];
        
        title = [decoder decodeObjectForKey:kTitle];
        originalURL = [decoder decodeObjectForKey:kOriginalURL];
        description = [decoder decodeObjectForKey:kDescription];
        ownerID = [decoder decodeObjectForKey:kOwnerID];
        ID = [decoder decodeObjectForKey:kID];
        
        self.commentCount = [decoder decodeObjectForKey:kCommentCount];
        sharedCount = [decoder decodeObjectForKey:kSharedCount];
        forwardItem = [decoder decodeObjectForKey:kForwardItem];
    }
    return self;
}
#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    ItemViewModel *copy = [[[self class] allocWithZone: zone] init];
    copy.iconURL = [self.iconURL copyWithZone:zone];
    copy.largeIconURL = [self.largeIconURL copyWithZone:zone];
    copy.imageURL = [self.imageURL copyWithZone:zone];
    copy.midImageURL = [self.midImageURL copyWithZone:zone];
    copy.fullImageURL = [self.fullImageURL copyWithZone:zone];
    
    copy.time = [self.time copyWithZone:zone];
    copy.type = self.type;
    copy.renrenFeedType = self.renrenFeedType;
    copy.content = [self.content copyWithZone:zone];
    copy.rssSummary = [self.rssSummary copyWithZone:zone];
    
    copy.title = [self.title copyWithZone:zone];
    copy.originalURL = [self.originalURL copyWithZone:zone];
    copy.description = [self.description copyWithZone:zone];
    copy.ownerID = [self.ownerID copyWithZone:zone];
    copy.ID = [self.ID copyWithZone:zone];
    
    copy.commentCount = [self.commentCount copyWithZone:zone];
    copy.sharedCount = [self.sharedCount copyWithZone:zone];
    copy.forwardItem = [self.forwardItem copyWithZone:zone];
    
    return copy;
}

@end
