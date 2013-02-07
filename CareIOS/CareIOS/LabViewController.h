//
//  LabViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouMiView.h"
@interface LabViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic)UIButton* btn1;
@property (strong, nonatomic)UIButton* btn2;
@property (strong, nonatomic)UIButton* btn3;
@property (strong, nonatomic)UIButton* btn4;
@property (strong, nonatomic)UIButton* btn5;
@property (strong, nonatomic)UIButton* btn6;
@property (strong, nonatomic)UIButton* btn7;  // 妹的，我当时是不是抽风了，怎么想出这么脑残的命名

@property (strong, nonatomic)YouMiView *adView1;

@end
