//
//  Constants.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum EnumEntryType {
    EntryType_NotSet,
    EntryType_SinaWeibo,
    EntryType_Renren,
    EntryType_Douban,
    EntryType_RSS
} EntryType;


typedef enum EnumRenrenNewsType{
    RenrenNews_TextStatus = 10,
    RenrenNews_UploadPhoto = 30,
    RenrenNews_SharePhoto = 32,
} RenrenNewsType;

typedef enum EnumChatType {
    ChatType_Her = 0,
    ChatType_Me = 1,
} ChatType;

@interface CareConstants : NSObject
+(NSString*)doubanAppKey;
+(NSString*)doubanBaseAPI;
+(UIColor*)headerColor;
+(UIColor*)labPink;
@end
