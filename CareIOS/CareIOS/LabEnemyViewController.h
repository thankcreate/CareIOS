//
//  LabEnemyViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseFetcher.h"
@class PCLineChartView;
@interface LabEnemyViewController : UIViewController<FetcherDelegate>
{    
    int var1;
    int var2;
    int var3;
}


@property (strong, nonatomic) BaseFetcher* fetcher;
@property (strong, nonatomic) NSString* name1;
@property (strong, nonatomic) NSString* name2;
@property (strong, nonatomic) NSString* name3;
@property (strong, nonatomic) NSString* herID;
@end
