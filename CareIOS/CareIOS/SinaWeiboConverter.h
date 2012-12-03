//
//  SinaWeiboConverter.h
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ItemViewModel;

@interface SinaWeiboConverter : NSObject
+(ItemViewModel*) convertStatusToCommon:(id)status;
@end
