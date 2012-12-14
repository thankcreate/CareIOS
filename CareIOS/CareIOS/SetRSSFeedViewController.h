//
//  SetRSSFeedViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWFeedParser.h"
@interface SetRSSFeedViewController : UITableViewController<MWFeedParserDelegate>

@property (strong, atomic) MWFeedParser *feedParser;

@end
