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
@interface TTCommentViewController : TTTableViewController<SinaWeiboRequestDelegate,RenrenDelegate, TTPostControllerDelegate>
@property (strong, nonatomic) ItemViewModel* itemViewModel;
@property (strong, nonatomic) NSMutableArray* commentList;
@property (strong, nonatomic) NSArray* sortedList;

// 因为人人在回调中不能判断是来自哪个请求，所以这里我做了个独立于SDK的标记
// 调用前由自己去设一个值
// 目前的情况下有两个值
// addComment 和 getComment
@property (strong, nonatomic) NSString* lastRenrenMethod;
@end


//@interface TTSectionedDataSource(CommentSource)
//- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object;
//@end
