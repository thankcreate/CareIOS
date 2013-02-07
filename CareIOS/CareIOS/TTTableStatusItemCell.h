//
//  TTTableStatusItemCell.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import <Three20UI/Three20UI.h>
@class TTImageView;
@class TTView;

@interface TTTableStatusItemCell : TTTableLinkedItemCell {
    UILabel*      _titleLabel;
    UILabel*      _timestampLabel;
    TTImageView*  _iconImage;
    TTImageView*  _iconImageBkg;
    UIImageView*  _bubbleImage;
    TTImageView*  _thumbImage;
    
    TTView*       _forwardView;
    UILabel*      _forwardTitleLabel;
    UILabel*      _forwardTextLabel;

    TTImageView*  _forwardThumbImage;

    UILabel*      _commentCountLabel;
    UILabel*      _fromLabel;
}

@property (nonatomic, readonly, retain) UILabel*      titleLabel;
@property (nonatomic, readonly)         UILabel*      captionLabel;
@property (nonatomic, readonly, retain) UILabel*      timestampLabel;
@property (nonatomic, readonly, retain) TTImageView*  iconImage;
@property (nonatomic, readonly, retain) TTImageView*  iconImageBkg;
@property (nonatomic, readonly, retain) UIImageView*  bubbleImage;
@property (nonatomic, readonly, retain) TTImageView*  thumbImage;
@property (nonatomic, readonly, retain) TTView*  forwardView;

@property (nonatomic, readonly, retain) UILabel*      forwardTitleLabel;
@property (nonatomic, readonly, retain) UILabel*      forwardTextLabel;
@property (nonatomic, readonly, retain) TTImageView*  forwardThumbImage;

@property (nonatomic, readonly, retain) UILabel*      fromLabel;
@property (nonatomic, readonly, retain) UILabel*      commentCountLabel;

@end
