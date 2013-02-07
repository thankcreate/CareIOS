//
//  BlessItemViewModel.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-4.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlessItemViewModel : NSObject
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSString* content;
@property (copy, nonatomic) NSDate* time;
@property (nonatomic) NSInteger isPassed;
@end
