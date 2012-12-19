//
//  GuideViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-16.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController<UIScrollViewDelegate>
{
    BOOL pageControlUsed;
}

@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) NSArray *listImageName;
@end
