//
//  PasswordViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-13.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController
@property (strong, atomic) NSString* input;
@property (strong, atomic) NSString* realPassword;

@property (atomic) BOOL isEnterForegroundMode;
@end
