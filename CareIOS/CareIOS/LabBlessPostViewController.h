//
//  LabBlessPostViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-7.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlessHelper.h"
@interface LabBlessPostViewController : UIViewController<UITextViewDelegate, BlessItemPostDelegate>
@property(nonatomic, strong)BlessHelper *blessHelper;
@end
