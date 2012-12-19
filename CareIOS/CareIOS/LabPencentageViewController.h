//
//  LabPencentageViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabShareBaseViewController.h"

@interface LabPencentageViewController : LabShareBaseViewController<UIPickerViewDelegate, UIPickerViewDataSource>
{
    int var;
}

@property (strong, nonatomic) NSArray *col1;
@property (strong, nonatomic) NSArray *col2;

@end
