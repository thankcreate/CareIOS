//
//  MiscTool.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-4.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiscTool : NSObject
+(NSString*)convertDateToString:(NSDate*)date;
+(NSString*)getHerIcon;
+(NSString*)getHerName;
+(NSString*)getMyIcon;
+(NSString*)getMyName;

+(NSString*)getHerSinaWeiboIcon;
+(NSString*)getHerRenrenIcon;
+(NSString*)getHerDoubanIcon;

+(NSString*)getHerSinaWeiboName;
+(NSString*)getHerRenrenName;
+(NSString*)getHerDoubanName;


+(BOOL)isAnyOneFollowed;
+(NSString *)removeHTMLTag:(NSString*)input;
+(NSString *)removeDoubanScoreTag:(NSString*)input;

+(void)gotoReviewPage;

+(NSString *) getFileName:(NSString*)input;
+(BOOL) isNilOrEmpty:(NSString*)input;
@end
