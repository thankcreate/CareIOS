//
//  DoubanFetcher.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-12.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "BaseFetcher.h"
#import "TaskHelper.h"

@interface DoubanFetcher :  BaseFetcher<TaskCompleteDelegate>

-(id)initWithDelegate:(id<FetcherDelegate>)del;


@property (strong, atomic) TaskHelper* taskHelper;
@property (strong, atomic) NSMutableArray* resultMenList;
@end
