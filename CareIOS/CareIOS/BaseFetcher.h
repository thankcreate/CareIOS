//
//  BaseFetcher.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-7.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentMan.h"
////////////////////////////////////////////////
@protocol FetcherDelegate<NSObject>
@required
- (void)fetchComplete:(NSArray*)result;
@end


////////////////////////////////////////////////
@interface BaseFetcher : NSObject
@property(strong, nonatomic) id<FetcherDelegate> delegate;
-(void)startFetchCommentMan;
@end


