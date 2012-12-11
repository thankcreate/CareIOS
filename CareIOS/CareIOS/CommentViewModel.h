//
//  CommentViewModel.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-10.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CareConstants.h"
@interface CommentViewModel : NSObject

@property (strong, nonatomic) NSString* iconURL;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* ID;
@property (strong, nonatomic) NSDate* time;

// 豆瓣用户两个ID标识，一个数字ID，一个字符串的ID
@property (strong, nonatomic) NSString* uid;
@property (strong, nonatomic) NSString* doubanUID;

@property (nonatomic) EntryType type;
@end
