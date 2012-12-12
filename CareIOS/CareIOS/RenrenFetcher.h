//
//  RenrenFetcher.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-11.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "BaseFetcher.h"


@interface RenrenFetcher :  BaseFetcher<RenrenDelegate>

-(id)initWithDelegate:(id<FetcherDelegate>)del;

@property (strong, atomic) NSMutableArray* resultMenList;
@end
