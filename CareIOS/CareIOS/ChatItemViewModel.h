//
//  ChatItemViewModel.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatItemViewModel : NSObject<NSCoding, NSCopying>
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* content;
@property (copy, nonatomic) NSString* iconURL;
@property (nonatomic) ChatType type;
@property (copy, nonatomic) NSDate* time;
@end
