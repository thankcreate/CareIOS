//
//  MainViewModel.h
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainViewModel : NSObject

// Singleton
+(MainViewModel *)sharedInstanceMethod;



// Main items
@property (strong, atomic) NSMutableArray* items;
@property (strong, atomic) NSMutableArray* sinaWeiboItems;
@property (strong, atomic) NSMutableArray* renrenItems;
@property (strong, atomic) NSMutableArray* doubanItems;

// Pic items
@property (strong, atomic) NSMutableArray* pictureItems;
@property (strong, atomic) NSMutableArray* sinaWeiboPictureItems;
@property (strong, atomic) NSMutableArray* renrenPictureItems;
@property (strong, atomic) NSMutableArray* doubanPictureItems;

@property BOOL isChanged;
@end
