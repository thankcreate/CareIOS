//
//  LabEnemyViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFetcher.h"
#import "CareConstants.h"
@class PCLineChartView;
@interface LabEnemyViewController : UIViewController<FetcherDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) NSString* name1;
@property (strong, nonatomic) NSString* name2;
@property (strong, nonatomic) NSString* name3;

@property (strong, nonatomic) NSNumber* var1;
@property (strong, nonatomic) NSNumber* var2;
@property (strong, nonatomic) NSNumber* var3;

@property (strong, nonatomic) NSString* id1;
@property (strong, nonatomic) NSString* id2;
@property (strong, nonatomic) NSString* id3;

@property (strong, nonatomic) BaseFetcher* fetcher;

@property (nonatomic) EntryType type;
@property (strong, nonatomic) NSString* herID;

@property (strong, nonatomic) NSMutableDictionary* mapManToCount;
@property (strong, nonatomic) NSMutableDictionary* mapManToID;
@end

@interface ManToCountPair : NSObject
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSNumber* count;
@end
