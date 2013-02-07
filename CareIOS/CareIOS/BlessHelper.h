//
//  BlessHelper.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-3.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequestDelegate.h>

@protocol BlessItemFetchDelegate<NSObject>
@required
- (void)blessItemFetchComplete:(NSArray*)result;
@end


@protocol BlessItemPostDelegate<NSObject>
@required
- (void)blessItemPostComplete:(Boolean)isSuccess;
@end

@interface BlessHelper : NSObject<ASIHTTPRequestDelegate, BlessItemFetchDelegate>
@property(strong, atomic) NSMutableArray* listImagePath;
@property(strong, atomic) id<BlessItemFetchDelegate> fetchDelegate;
@property(strong, atomic) id<BlessItemPostDelegate> postDelegate;




-(void)cacheBlessImages;
-(void)cacheBlessPassedItems;
-(NSMutableArray*)getBlessImages;
-(NSArray*)getCachedBlessPassedItems;
-(void)fetchBlessItemWithCount:(NSInteger)count isPassed:(BOOL) isPassed  delegate:(id<BlessItemFetchDelegate>)dele;
-(void)postBlessItemWithName:(NSString*)name content:(NSString*)content delegate:(id<BlessItemPostDelegate>)dele;
@end
