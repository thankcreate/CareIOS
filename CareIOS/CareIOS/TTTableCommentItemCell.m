//
//  TTTableCommentItemCell.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-10.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTTableCommentItemCell.h"
#import "TTTableCommentItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20UI/TTPostController.h"
#import "CareAppDelegate.h"

#import "ItemViewModel.h"
#import "CommentViewModel.h"


@implementation TTTableCommentItemCell
@synthesize iconImage;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize commentImage;

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
    
    CGFloat top = 0;
    CGFloat left = 0;
    CGFloat width = self.contentView.width;
    
    CGFloat topMargin = 5;
    CGFloat leftMargin = 5;
    CGFloat rightMargin = 5;
    top += topMargin;
    left += leftMargin;
    width -= (leftMargin + rightMargin);
    
    // 1.头像
    _iconImage.frame = CGRectMake(left, top, 35, 35);

    left += _iconImage.frame.origin.x +  _iconImage.frame.size.width + 5;
    
    
    
    // 2.右侧
    // 2.1.1 标题
    CGFloat rightWidth = width -  _iconImage.frame.size.width - 10;
    CGSize maximumLabelSize = CGSizeMake(rightWidth,9999);
    CGSize expectedLabelSize = [_titleLabel.text sizeWithFont:_titleLabel.font
                                                     constrainedToSize:maximumLabelSize
                                                         lineBreakMode:_titleLabel.lineBreakMode];

    _titleLabel.frame = CGRectMake(left, top, expectedLabelSize.width, expectedLabelSize.height);
    
    // 2.1.2 评论按钮
    if(self.commentViewModel)
    {
        _commentImage.frame = CGRectMake(width - 20, top, 20, 20);
    }
    else
    {
        _commentImage.frame = CGRectZero;
    }
    
    top += expectedLabelSize.height;

    
    // 2.2 正文
    maximumLabelSize = CGSizeMake(rightWidth,9999);
    expectedLabelSize = [_contentLabel.text sizeWithFont:_contentLabel.font
                                            constrainedToSize:maximumLabelSize
                                                lineBreakMode:_contentLabel.lineBreakMode];
    _contentLabel.frame = CGRectMake(left, top, rightWidth, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
    // 2.2 时间
    maximumLabelSize = CGSizeMake(rightWidth,9999);
    expectedLabelSize = [_timeLabel.text sizeWithFont:_timeLabel.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:_timeLabel.lineBreakMode];
    _timeLabel.frame = CGRectMake(left, top, width, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_commentImage unsetImage];
    [_iconImage unsetImage];
    
    _titleLabel.text = nil;
    _timeLabel.text = nil;
    _contentLabel.text = nil;
}



#pragma mark TTTableViewCell class public
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    TTTableCommentItem* item = (TTTableCommentItem*)object;
    CGFloat height = 0;
    // margin
    height += 5;
    // 1. 标题
    height += 20;
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
    height +=5;
    return height;    
}

- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        TTTableCommentItem* item = object;
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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MessageEdit" ofType:@"png"];
        self.commentImage.defaultImage = [UIImage imageWithContentsOfFile:path];
        
        self.commentViewModel = item.commentViewModel;
        self.itemViewModel = item.itemViewModel;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)iconImage {
    if (!_iconImage) {
        _iconImage = [[TTImageView alloc] init];
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //_iconImage.style = TTSTYLE(rounded);
        [self.contentView addSubview:_iconImage];
    }
    return _iconImage;
}

- (TTImageView*)commentImage {
    if (!_commentImage) {
        _commentImage = [[TTImageView alloc] init];
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //_iconImage.style = TTSTYLE(rounded);
        [self.contentView addSubview:_commentImage];
    }
    return _commentImage;
}

+ (UIFont*)titleFont
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:18];
}
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.font = [TTTableCommentItemCell titleFont];
        _titleLabel.contentMode = UIViewContentModeTopLeft;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 100;     
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

+ (UIFont*)contentFont
{
    return [UIFont fontWithName:@"Helvetica" size:13];
}
- (UILabel*)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.highlightedTextColor = [UIColor whiteColor];
        _contentLabel.font = [TTTableCommentItemCell contentFont];
        _contentLabel.contentMode = UIViewContentModeTopLeft;
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.numberOfLines = 100;     
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font =  [UIFont fontWithName:@"Helvetica" size:13];
        _timeLabel.textColor = RGBCOLOR(150, 150, 150);
        _timeLabel.highlightedTextColor = [UIColor whiteColor];
        _timeLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];    
   
    if ([touch view] == _commentImage)
    {
        NSString* preText = [[NSString alloc]initWithFormat:@"回复@%@: ", self.commentViewModel.title];
        TTPostController* controller = [[TTPostController alloc] initWithNavigatorURL:nil
                                                                                 query:[NSDictionary dictionaryWithObjectsAndKeys:preText, @"text", nil]];
        controller.originView = _commentImage;
        controller.delegate = self;
        [controller showInView:self.contentView animated:YES];
    }
}

- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
    int length = text.length;
    int nLeft = length - 140;
    if(length > 140)
    {
        NSString* preText = [[NSString alloc]initWithFormat:@"内容超长了%d个 ", nLeft];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:preText         delegate:nil
                                              cancelButtonTitle:@"嗯嗯" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
    CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo* sinaweibo = appDelegate.sinaweibo;
    
    if( ![sinaweibo isAuthValid])
        return FALSE;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:text forKey:@"comment"];
    [dic setObject:self.itemViewModel.ID forKey:@"id"];
    
    [sinaweibo requestWithURL:@"comments/create.json"
                       params:dic
                   httpMethod:@"POST"
                     delegate:self];
    return TRUE;
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"comments/create.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因，发送失败" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    if ([request.url hasSuffix:@"comments/create.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                        message:@"发送成功" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
        [alert show];
    }
}



@end
