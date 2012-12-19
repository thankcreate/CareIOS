//
//  LabTimeSpanViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabShareBaseViewController.h"
@class PCLineChartView;

@interface LabTimeSpanViewController : LabShareBaseViewController
{
    int var1;
    int var2;
    int var3;
    int var4;
}

@property (strong, nonatomic) PCLineChartView* lineChart;

@end
