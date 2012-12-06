//
//  MainViewModel.h
//  CareIOS
//
//  Created by 谢 创 on 12-12-3.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "ItemViewModel.h"
#import "PictureItemViewModel.h"
#import "RefreshViewerHelper.h"

// MainViewModel涉及到刷新操作，继承Three20的数据模型基类
@interface MainViewModel : NSObject<TTPhotoSource, TTModel, RefreshViewerDelegate>
{
    NSMutableArray* _delegates;
    BOOL _isLoading;
}

// Singleton
+(MainViewModel *)sharedInstance;

// Main items
@property (strong, atomic) NSMutableArray* items;
@property (strong, atomic) NSMutableArray* listItems;
@property (strong, atomic) NSMutableArray* sinaWeiboItems;
@property (strong, atomic) NSMutableArray* renrenItems;
@property (strong, atomic) NSMutableArray* doubanItems;

// Pic items
@property (strong, atomic) NSMutableArray* pictureItems;
@property (strong, atomic) NSMutableArray* listPictureItems;
@property (strong, atomic) NSMutableArray* sinaWeiboPictureItems;
@property (strong, atomic) NSMutableArray* renrenPictureItems;
@property (strong, atomic) NSMutableArray* doubanPictureItems;

@property BOOL isChanged;
@end
