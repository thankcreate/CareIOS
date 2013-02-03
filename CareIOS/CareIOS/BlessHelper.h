//
//  BlessHelper.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-3.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequestDelegate.h>
@interface BlessHelper : NSObject<ASIHTTPRequestDelegate>
@property(strong, atomic) NSMutableArray* listImagePath;
-(void)fetchListImagePath;
-(NSMutableArray*)getBlessImages;
@end
