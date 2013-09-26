//
//  TTTableChatItemCell.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-1-12.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "TTTableBlessItemCell.h"
#import "TTTableBlessItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20UI/TTPostController.h"
#import "CareAppDelegate.h"

#import "TTTableChatItem.h"
#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"

#import "UIView+FindUIViewController.h"

@implementation TTTableBlessItemCell

@synthesize titleLabel;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize bubble;


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
    // 2.1.1 标题

    CGSize maximumLabelSize = CGSizeMake(avalaWidth,9999);
    CGSize expectedLabelSize = [_titleLabel.text sizeWithFont:_titleLabel.font
                                            constrainedToSize:maximumLabelSize
                                                lineBreakMode:_titleLabel.lineBreakMode];
    
    _titleLabel.frame = CGRectMake(left, top, expectedLabelSize.width, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
    
    // 2.2 正文
    maximumLabelSize = CGSizeMake(avalaWidth,9999);
    expectedLabelSize = [_contentLabel.text sizeWithFont:_contentLabel.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:_contentLabel.lineBreakMode];
    _contentLabel.frame = CGRectMake(left, top, expectedLabelSize.width, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
    // 2.2 时间
    maximumLabelSize = CGSizeMake(avalaWidth,9999);
    expectedLabelSize = [_timeLabel.text sizeWithFont:_timeLabel.font
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:_timeLabel.lineBreakMode];
    _timeLabel.frame = CGRectMake(left, top, expectedLabelSize.width, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
    
    CGFloat bubbleLeft = 0;
    UIImage* bubbleImage;
    if(self.index % 2 == 0)
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
    self.bubble.frame = CGRectMake(bubbleLeft, 0, bubbleWidth, _titleLabel.frame.size.height + _contentLabel.frame.size.height + _timeLabel.frame.size.height + 13);
}

- (void)prepareForReuse {
    [super prepareForReuse];
//    _bubble = nil;
    _titleLabel.text = nil;
    _timeLabel.text = nil;
    _contentLabel.text = nil;
}



#pragma mark TTTableViewCell class public
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    CGFloat topMargin = 6;
    CGFloat leftMargin = 12;
    CGFloat rightMargin = 5;
    CGFloat bubbleWidth = 250;
    CGFloat avalaWidth = bubbleWidth - leftMargin - rightMargin;
    
    TTTableBlessItem* item = (TTTableBlessItem*)object;
    CGFloat height = 0;
    // margin
    height += 5;
    // 1. 标题
    height += 20;
    // 2. 正文
    CGSize maximumLabelSize = CGSizeMake(avalaWidth,9999);
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
    height += 8;
    return height;
}

- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];        
        TTTableBlessItem* item = object;
        self.index = item.index; // 这一步尽量早点做
        if (item.name.length) {
            self.titleLabel.text = item.name;
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
        
    }
}

+ (UIFont*)contentFont
{
    return [UIFont fontWithName:@"Helvetica" size:12];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (UIFont*)titleFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:14];
}
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.font = [TTTableBlessItemCell titleFont];
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
        _contentLabel.font = [TTTableBlessItemCell contentFont];
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
        _timeLabel.font =  [UIFont fontWithName:@"Helvetica" size:11];
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
