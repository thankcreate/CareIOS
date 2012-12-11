//
//  TTCommentViewController.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-10.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "SinaWeibo.h"
@class ItemViewModel;
@interface TTCommentViewController : TTTableViewController<SinaWeiboRequestDelegate, TTPostControllerDelegate>
@property (strong, nonatomic) ItemViewModel* itemViewModel;

@end


//@interface TTSectionedDataSource(CommentSource)
//- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object;
//@end
