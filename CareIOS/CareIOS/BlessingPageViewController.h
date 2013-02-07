//
//  BlessingPageViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-3.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BlessHelper;

@interface BlessingPageViewController : UIViewController

@property(nonatomic, strong)UIImageView* imageView1;
@property(nonatomic, strong)UIImageView* imageView2;
@property(nonatomic, strong)UIImageView* imageViewEnter;

@property(nonatomic, strong)UILabel* txtName;
@property(nonatomic, strong)UILabel* txtContent;

@property(nonatomic, strong)BlessHelper *blessHelper;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSArray* listImages;
@property(nonatomic, strong)NSArray* listItems;

@property(nonatomic)NSInteger mBkgIndex;
@property(nonatomic)NSInteger mItemIndex;
@property(nonatomic)NSInteger activeFlag;

@end
