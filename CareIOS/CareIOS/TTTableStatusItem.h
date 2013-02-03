//
//  TTTableStatusItem.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>
@class ItemViewModel;
@interface TTTableStatusItem : TTTableTextItem {
    NSString* _title;
    NSString* _caption;
    NSDate*   _timestamp;
    NSString* _imageURL;
    NSString* _thumbImageURL;
    NSString* _from;
    NSString* _commentCount;
    TTTableStatusItem* _forwardItem;
}

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* caption;
@property (nonatomic, retain) NSDate*   timestamp;
@property (nonatomic, copy)   NSString* imageURL;
@property (nonatomic, copy)   NSString* thumbImageURL;
@property (nonatomic, copy)   NSString* from;
@property (nonatomic, copy)   NSString* commentCount;
@property (nonatomic, retain)   TTTableStatusItem* forwardItem;

// 这里之所以再加了一个ItemViewModel是因为一开始并没有建这个TTTableStatusItem类
// 而是直接在TTTableMessageItem的基础上改的
// 后来发现要实现点小图看大图的功能，需要更多的信息，干脆就把ItemViewModel的引用送进来了
@property (nonatomic, retain)  ItemViewModel* itemViewModel;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL;
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL;

@end
