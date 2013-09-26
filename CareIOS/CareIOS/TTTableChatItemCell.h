//
//  TTTableChatItemCell.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface TTTableChatItemCell : TTTableLinkedItemCell
{
    TTImageView*  _iconImage;
    UILabel*      _titleLabel;
    UILabel*      _contentLabel;
    UILabel*      _timeLabel;
    UIImageView*  _bubble;
}

@property (nonatomic,  retain) TTImageView*  iconImage;
@property (nonatomic, readonly, retain) UILabel*  titleLabel;
@property (nonatomic, readonly, retain) UILabel*  contentLabel;
@property (nonatomic, readonly, retain) UILabel*  timeLabel;
@property (nonatomic, readonly, retain) UIImageView*  bubble;
@property (nonatomic) ChatType type;

@end
