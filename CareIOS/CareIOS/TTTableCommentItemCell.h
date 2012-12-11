//
//  TTTableCommentItemCell.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-10.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "SinaWeibo.h"
@class CommentViewModel;
@class ItemViewModel;
@interface TTTableCommentItemCell : TTTableLinkedItemCell<SinaWeiboRequestDelegate, TTPostControllerDelegate>
{
    TTImageView*  _iconImage;
    TTImageView*  _commentImage;
    UILabel*      _titleLabel;
    UILabel*      _contentLabel;
    UILabel*      _timeLabel;
}

@property (strong,nonatomic) CommentViewModel* commentViewModel;
@property (strong,nonatomic) ItemViewModel* itemViewModel;
@property (nonatomic,  retain) TTImageView*  iconImage;
@property (nonatomic,  retain) TTImageView*  commentImage;
@property (nonatomic, readonly, retain) UILabel*  titleLabel;
@property (nonatomic, readonly, retain) UILabel*  contentLabel;
@property (nonatomic, readonly, retain) UILabel*  timeLabel;
@end
