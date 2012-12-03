//
//  MainViewModel.m
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "MainViewModel.h"

static MainViewModel * sharedInstance = nil;

@implementation MainViewModel

+(MainViewModel *)sharedInstanceMethod
{
    @synchronized(self) {
        if (sharedInstance == nil)
        {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

-(id)init
{
    if(!(self = [super init]))
    {
        
        return nil;
        
    }
    self.items = [NSMutableArray arrayWithCapacity:100];
    self.sinaWeiboItems = [NSMutableArray arrayWithCapacity:50];
    self.renrenItems = [NSMutableArray arrayWithCapacity:50];
    self.doubanItems = [NSMutableArray arrayWithCapacity:50];
    
    self.pictureItems = [NSMutableArray arrayWithCapacity:100];
    self.sinaWeiboPictureItems = [NSMutableArray arrayWithCapacity:50];
    self.renrenPictureItems = [NSMutableArray arrayWithCapacity:50];
    self.doubanPictureItems = [NSMutableArray arrayWithCapacity:50];
    
    self.isChanged = true;
    return self;
}

@end
