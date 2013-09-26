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
#import "DOUAPIEngine.h"
#import "NSString+RenrenSBJSON.h"

#import "UIView+FindUIViewController.h"

#define LEFT_RIGHT_MARGIN 10

@implementation TTTableCommentItemCell
@synthesize iconImage;
@synthesize titleLabel;
@synthesize contentLabel;
@synthesize timeLabel;
@synthesize commentImage;
@synthesize itemViewModel;

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

-(void)updateCommentListOfTable
{
    id table = [self superview];
    UIView* test2 = [table superview];
    UIViewController* viewController = [test2 firstAvailableUIViewController];
    // viewController is TTCommentViewController in fact
    if([viewController respondsToSelector:@selector(fetchComments)])
    {
        [viewController performSelector:@selector(fetchComments) withObject:nil afterDelay:0.5];
    }
}

#pragma mark UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat top = 0;
    CGFloat left = 0;
    CGFloat width = self.contentView.width;
    
    CGFloat topMargin = 5;
    CGFloat leftMargin = LEFT_RIGHT_MARGIN;
    CGFloat rightMargin = LEFT_RIGHT_MARGIN;
    top += topMargin;
    left += leftMargin;
    width -= (leftMargin + rightMargin);
    
    // 1.头像
    _iconImage.frame = CGRectMake(left, top, 35, 35);
    _iconImage.layer.cornerRadius = 3.0;
    _iconImage.layer.masksToBounds = YES;
    left += _iconImage.frame.origin.x +  _iconImage.frame.size.width + 5;
    
    
    
    // 2.右侧
    // 2.1.1 标题
    CGFloat rightWidth = width -  _iconImage.frame.size.width - 10;
    CGSize maximumLabelSize = CGSizeMake(rightWidth,9999);
    CGSize expectedLabelSize = [_titleLabel.text sizeWithFont:_titleLabel.font
                                                     constrainedToSize:maximumLabelSize
                                                         lineBreakMode:_titleLabel.lineBreakMode];

    _titleLabel.frame = CGRectMake(left, top, expectedLabelSize.width, expectedLabelSize.height);
    
//    // 2.1.2 评论按钮
//    if(self.commentViewModel)
//    {
//        _commentImage.frame = CGRectMake(width - 30, top - 7, 30, 30);
//    }
//    else
//    {
//        _commentImage.frame = CGRectZero;
//    }
    
    top += expectedLabelSize.height;

    
    // 2.2 正文
    maximumLabelSize = CGSizeMake(rightWidth,9999);
    expectedLabelSize = [_contentLabel.text sizeWithFont:_contentLabel.font
                                            constrainedToSize:maximumLabelSize
                                                lineBreakMode:_contentLabel.lineBreakMode];
    _contentLabel.frame = CGRectMake(left, top + 3, rightWidth, expectedLabelSize.height);
    top += expectedLabelSize.height;
    
    // 2.2 时间
    maximumLabelSize = CGSizeMake(rightWidth,9999);
    expectedLabelSize = [_timeLabel.text sizeWithFont:_timeLabel.font
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:_timeLabel.lineBreakMode];
    _timeLabel.frame = CGRectMake(left, top + 7, width, expectedLabelSize.height);
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
    height += 5;
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
        //[self.contentView addSubview:_commentImage];
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
        _titleLabel.backgroundColor = [UIColor clearColor];
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
        _contentLabel.backgroundColor = [UIColor clearColor];
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
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.highlightedTextColor = [UIColor whiteColor];
        _timeLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

//#pragma mark - event
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch = [touches anyObject];    
//   
//    //if ([touch view] == _commentImage)
//    {
//        NSString* preText;
//        if(itemViewModel.type == EntryType_SinaWeibo)
//        {
//            preText = [[NSString alloc]initWithFormat:@"回复@%@: ", self.commentViewModel.title];
//        }
//        else if(itemViewModel.type == EntryType_Renren)
//        {
//            preText = [[NSString alloc]initWithFormat:@"回复%@: ", self.commentViewModel.title];
//        }
//        else if(itemViewModel.type == EntryType_Douban)
//        {
//            // 豆瓣很非主流，搞了个doubanUID，实际上就是以昵称的方式起作用的主键
//            preText = [[NSString alloc]initWithFormat:@"@%@: ", self.commentViewModel.doubanUID];
//        }
//
//        TTPostController* controller = [[TTPostController alloc] initWithNavigatorURL:nil
//                                                                                 query:[NSDictionary dictionaryWithObjectsAndKeys:preText, @"text", nil]];
//        controller.originView = _commentImage;
//        controller.delegate = self;
//        controller.title = @"评论";
//        [controller showInView:self.contentView animated:YES];
//    }
//}

#pragma mark - TTPostControllerDelegate
- (BOOL)postController:(TTPostController*)postController willPostText:(NSString*)text
{
    int length = text.length;
    if(length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"呃～是智商要超过250才能看到您写的字么？" delegate:nil
                                              cancelButtonTitle:@"寡人知之矣" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }
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
    
    if(itemViewModel.type == EntryType_SinaWeibo)
    {
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
    }    
    else if(itemViewModel.type == EntryType_Renren)
    {
        CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
        Renren* renren = appDelegate.renren;
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if(itemViewModel.renrenFeedType == RenrenNews_TextStatus)
        {
            [dic setObject:@"status.addComment" forKey:@"method"];
            [dic setObject:itemViewModel.ID forKey:@"status_id"];
            [dic setObject:itemViewModel.ownerID forKey:@"owner_id"];
            [dic setObject:text forKey:@"content"];
        }
        else if(itemViewModel.renrenFeedType == RenrenNews_UploadPhoto)
        {
            [dic setObject:@"photos.addComment" forKey:@"method"];
            [dic setObject:itemViewModel.ID forKey:@"pid"];
            [dic setObject:itemViewModel.ownerID forKey:@"uid"];
            [dic setObject:text forKey:@"content"];
        }
        else if(itemViewModel.renrenFeedType == RenrenNews_SharePhoto)
        {
            [dic setObject:@"share.addComment" forKey:@"method"];
            [dic setObject:itemViewModel.ID forKey:@"share_id"];
            [dic setObject:itemViewModel.ownerID forKey:@"user_id"];
            [dic setObject:text forKey:@"content"];
        }
        [renren requestWithParams:dic andDelegate:self];
    }
    else if(itemViewModel.type == EntryType_Douban)
    {
        DOUService *service = [DOUService sharedInstance];
        if(![service isValid])
            return FALSE;
        
        // 这个地方很搞人，豆瓣对某条转发的评论其实是对原广播的评论
        NSString* finalID = itemViewModel.ID;
        if(itemViewModel.forwardItem != nil)
            finalID = itemViewModel.forwardItem.ID;

        NSString* subPath = [NSString stringWithFormat:@"/shuo/v2/statuses/%@/comments", finalID];
        DOUQuery* query = [[DOUQuery alloc] initWithSubPath:subPath
                                                 parameters:[NSDictionary dictionaryWithObjectsAndKeys:text,@"text",
                                                             [CareConstants doubanAppKey], @"source",nil]];
        
        DOUReqBlock completionBlock = ^(DOUHttpRequest *req){
            NSError *error = [req error];
            NSLog(@"str:%@", [req responseString]);
            
            if (!error) {
                [self updateCommentListOfTable];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                                message:@"发送成功" delegate:nil
                                                      cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
                [alert show];

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                                message:@"由于未知原因，发送失败" delegate:nil
                                                      cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
                [alert show];
            }
        };
        
        service.apiBaseUrlString = [CareConstants doubanBaseAPI];
        

        [service post:query postBody:nil callback:completionBlock];
    }
    return TRUE;
}

#pragma mark - SinaWeiboRequest Delegate
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"comments/create.json"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因，发送失败， 请确保网络畅通" delegate:nil
                                              cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    if ([request.url hasSuffix:@"comments/create.json"])
    {
        [self updateCommentListOfTable];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                        message:@"发送成功" delegate:nil
                                              cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
        [alert show];
    }
}



#pragma mark  Renren Delegate
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    [self updateCommentListOfTable];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                    message:@"发送成功" delegate:nil
                                          cancelButtonTitle:@"嗯嗯，朕知道了～" otherButtonTitles:nil];
    [alert show];
}

- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"由于未知原因，发送失败，请确保网络畅通" delegate:nil
                                          cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
    [alert show];
}



@end
