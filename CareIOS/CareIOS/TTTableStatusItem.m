//
//  TTTableStatusItem.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTTableStatusItem.h"
// Core
#import "Three20Core/TTCorePreprocessorMacros.h"


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
// This class now belong to ThankCreate!!!
@implementation TTTableStatusItem

@synthesize title     = _title;
@synthesize caption   = _caption;
@synthesize timestamp = _timestamp;
@synthesize imageURL  = _imageURL;
@synthesize thumbImageURL  = _thumbImageURL;
@synthesize from  = _from;
@synthesize commentCount = _commentCount;


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL {
    TTTableStatusItem* item = [[self alloc] init];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.timestamp = timestamp;
    item.URL = URL;
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL {
    TTTableStatusItem* item = [[self alloc] init] ;
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.timestamp = timestamp;
    item.imageURL = imageURL;
    item.URL = URL;
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	self = [super initWithCoder:decoder];
    if (self) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.caption = [decoder decodeObjectForKey:@"caption"];
        self.timestamp = [decoder decodeObjectForKey:@"timestamp"];
        self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
        self.thumbImageURL = [decoder decodeObjectForKey:@"thumbImageURL"];
        self.forwardItem = [decoder decodeObjectForKey:@"forwardItem"];
        self.from = [decoder decodeObjectForKey:@"from"];
        self.commentCount = [decoder decodeObjectForKey:@"commentCount"];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [super encodeWithCoder:encoder];
    if (self.title) {
        [encoder encodeObject:self.title forKey:@"title"];
    }
    if (self.caption) {
        [encoder encodeObject:self.caption forKey:@"caption"];
    }
    if (self.timestamp) {
        [encoder encodeObject:self.timestamp forKey:@"timestamp"];
    }
    if (self.imageURL) {
        [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    }
    if (self.thumbImageURL) {
        [encoder encodeObject:self.imageURL forKey:@"thumbImageURL"];
    }
    if (self.forwardItem) {
        [encoder encodeObject:self.forwardItem forKey:@"forwardItem"];
    }
    if (self.from) {
        [encoder encodeObject:self.from forKey:@"from"];
    }
    if (self.commentCount){
        [encoder encodeObject:self.commentCount forKey:@"commentCount"];
    }
}


@end
