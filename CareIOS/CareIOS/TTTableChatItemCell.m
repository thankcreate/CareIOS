//
//  TTTableChatItemCell.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "TTTableChatItemCell.h"
#import "TTTableCommentItemCell.h"
#import "TTTableCommentItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20UI/TTPostController.h"
#import "CareAppDelegate.h"

#import "TTTableChatItem.h"
#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"

#import "UIView+FindUIViewController.h"

@implementation TTTableChatItemCell
@synthesize iconImage;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize type;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) {
    }
    return self;
}

#pragma mark UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat top = 0;
    CGFloat left = 0;
    CGFloat width = self.contentView.width;
    
    CGFloat topMargin = 6;
    CGFloat leftMargin = 12;
    CGFloat rightMargin = 5;
    top += topMargin;
    left += leftMargin;
    width -= (leftMargin + rightMargin);
    
    
    CGFloat bubbleWidth = 250;
    CGFloat avalaWidth = bubbleWidth - leftMargin - rightMargin;
    // 1.1.头像
    _iconImage.frame = CGRectMake(left, top + topMargin, 35, 35);
    _iconImage.contentMode = UIViewContentModeScaleAspectFill;
    _iconImage.layer.masksToBounds = YES;
    _iconImage.layer.cornerRadius = 3.0;

    // 1.2 标题
    CGFloat titleLeft  = left + _iconImage.frame.origin.x +  _iconImage.frame.size.width + 2;
    CGFloat rightWidth = width -  _iconImage.frame.size.width - 10;
    CGSize maximumLabelSize = CGSizeMake(rightWidth,9999);
    CGSize expectedLabelSize = [_titleLabel.text sizeWithFont:_titleLabel.font
                                            constrainedToSize:maximumLabelSize
                                                lineBreakMode:_titleLabel.lineBreakMode];
    
    _titleLabel.frame = CGRectMake(titleLeft,
                                   _iconImage.frame.origin.y + _iconImage.frame.size.height - expectedLabelSize.height,
                                   expectedLabelSize.width, expectedLabelSize.height);
    top += _iconImage.frame.origin.y + _iconImage.frame.size.height;
    
    // 2 正文
    CGFloat contentTopMargin = 2;
    top += contentTopMargin;
    maximumLabelSize = CGSizeMake(rightWidth,9999);
    expectedLabelSize = [_contentLabel.text sizeWithFont:_contentLabel.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:_contentLabel.lineBreakMode];
    _contentLabel.frame = CGRectMake(left, top, rightWidth, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
    // 3 时间
    CGFloat timeTopMargin = 2;
    top += timeTopMargin;
    maximumLabelSize = CGSizeMake(rightWidth,9999);
    expectedLabelSize = [_timeLabel.text sizeWithFont:_timeLabel.font
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:_timeLabel.lineBreakMode];
    _timeLabel.frame = CGRectMake(left, top, width, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
    
    CGFloat bubbleLeft = 0;
    UIImage* bubbleImage;
    if(type == ChatType_Her)
    {
        bubbleLeft = 0;
        bubbleImage = [UIImage imageNamed:@"thumb_lab_bless_bubble_left.png"];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(24,10,24,10)];
    }
    else
    {
        bubbleLeft = width - bubbleWidth + 16;
        bubbleImage = [UIImage imageNamed:@"thumb_lab_bless_bubble_right.png"];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(24,10,24,10)];
    }
    
    _bubble.image = bubbleImage;
    self.bubble.frame = CGRectMake(bubbleLeft, 0, bubbleWidth, _timeLabel.frame.origin.y + _timeLabel.frame.size.height + 8);
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_iconImage unsetImage];
    
    _titleLabel.text = nil;
    _timeLabel.text = nil;
    _contentLabel.text = nil;
}



#pragma mark TTTableViewCell class public
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    TTTableChatItem* item = (TTTableChatItem*)object;
    CGFloat height = 0;
    // margin
    height += 6;
    // 1. 标题
    height += 35;
    // 2. 正文
    CGSize maximumLabelSize = CGSizeMake(255,9999);
    CGSize linesSize = [item.content sizeWithFont:[self contentFont]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:NSLineBreakByTruncatingTail];
    height += linesSize.height;
    // 3.时间
    if(item.time)
    {
        height += 20;
    }
    // margin
    height += 25;
    return height;
}

- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        TTTableChatItem* item = object;
        if (item.title.length) {
            self.titleLabel.text = item.title;
        }
        if (item.content.length) {
            self.contentLabel.text = item.content;
        }
        if (item.time) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            NSString* strTime = [formatter stringFromDate:item.time];
            self.timeLabel.text = strTime;
        }
        if (item.imageURL.length) {
            self.iconImage.urlPath = item.imageURL;
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Cydia" ofType:@"png"];
            self.iconImage.defaultImage = [UIImage imageWithContentsOfFile:path];
        }
        self.type = item.type;
    }
}

+ (UIFont*)contentFont
{
    return [UIFont fontWithName:@"Helvetica" size:13];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)iconImage {
    if (!_iconImage) {
        _iconImage = [[TTImageView alloc] init];
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //_iconImage.style = TTSTYLE(rounded);
        [self.bubble addSubview:_iconImage];
    }
    return _iconImage;
}


+ (UIFont*)titleFont
{
    return [UIFont fontWithName:@"Helvetica" size:15];
}
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.font = [TTTableChatItemCell titleFont];
        _titleLabel.contentMode = UIViewContentModeTopLeft;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 100;
        [self.bubble addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel*)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.highlightedTextColor = [UIColor whiteColor];
        _contentLabel.font = [TTTableChatItemCell contentFont];
        _contentLabel.contentMode = UIViewContentModeTopLeft;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 100;
        [self.bubble addSubview:_contentLabel];
    }
    return _contentLabel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font =  [UIFont fontWithName:@"Helvetica" size:13];
        _timeLabel.textColor = RGBCOLOR(150, 150, 150);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.highlightedTextColor = [UIColor whiteColor];
        _timeLabel.contentMode = UIViewContentModeLeft;
        [self.bubble addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(UIImageView*)bubble{
    if(!_bubble){
        _bubble = [[UIImageView alloc]init];
        
        _bubble.alpha = 1;
        [self.contentView addSubview:_bubble];
    }
    return _bubble;
}


@end
