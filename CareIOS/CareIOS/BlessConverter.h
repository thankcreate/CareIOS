//
//  BlessConverter.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-4.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BlessItemViewModel;
@interface BlessConverter : NSObject

+(BlessItemViewModel*) convertToViewModel:(id)item;
@end
