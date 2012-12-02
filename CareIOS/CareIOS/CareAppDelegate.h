//
//  CareAppDelegate.h
//  CareIOS
//
//  Created by 谢 创 on 12-11-30.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//



#import <UIKit/UIKit.h>




#define kAppKey             @"4105036755"
#define kAppSecret          @"d37ac7cfda8c4ae080aaddf78206c80f"
#define kAppRedirectURI     @"http://api.weibo.com/oauth2/default.html"

@class SinaWeibo;

@interface CareAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) SinaWeibo *sinaweibo;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
