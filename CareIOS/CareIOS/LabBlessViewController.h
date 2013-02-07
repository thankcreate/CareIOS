//
//  LabBlessViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-7.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "BlessHelper.h"

@interface LabBlessViewController : TTTableViewController<BlessItemFetchDelegate>
@property (strong, nonatomic) NSMutableArray* blessList;
@property (strong, nonatomic) BlessHelper* blessHelper;
@end
