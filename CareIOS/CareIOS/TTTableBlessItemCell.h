//
//  TTTableBlessItemCell.h
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-7.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface TTTableBlessItemCell : TTTableLinkedItemCell
{
    UILabel*      _titleLabel;
    UILabel*      _contentLabel;
    UILabel*      _timeLabel;
    UIImageView*  _bubble;
}

@property (nonatomic, readonly, retain) UILabel*  titleLabel;
@property (nonatomic, readonly, retain) UILabel*  contentLabel;
@property (nonatomic, readonly, retain) UILabel*  timeLabel;
@property (nonatomic, readonly, retain) UIImageView*  bubble;
@property (nonatomic) NSInteger index;

@end
