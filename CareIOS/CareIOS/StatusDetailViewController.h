//
//  StatusDetailViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-9.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "MWPhotoBrowser.h"
#import "ItemViewModel.h"
@interface StatusDetailViewController : UIViewController<TTNavigatorDelegate, MWPhotoBrowserDelegate>
{

}
@property (strong, nonatomic) ItemViewModel* itemViewModel;
@property (strong, nonatomic) UILabel* lblCommentCount;
@property (strong, nonatomic) NSMutableArray* photos;
@end
