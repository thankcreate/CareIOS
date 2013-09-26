//
//  TTTableStatusItemCell.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTTableStatusItemCell.h"

#import "Three20UI/TTTableMessageItemCell.h"

// UI
#import "Three20UI/TTImageView.h"
#import "Three20UI/TTTableMessageItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/NSDateAdditions.h"

#import "Three20Style/TTSolidBorderStyle.h"
#import "Three20Style/TTShapeStyle.h"
#import "Three20Style/TTRoundedRectangleShape.h"
#import "Three20Style/TTContentStyle.h"
#import "Three20Style/TTSpeechBubbleShape.h"
#import "Three20Style/TTSolidFillStyle.h"
#import "TTTableStatusItem.h"

#import "TTStatusTImeLineViewController.h"
#import "UIView+FindUIViewController.h"
#import "ItemViewModel.h"

#import "UIDashView.h"
// 下面这一行我现在不管了
static const NSInteger  kMessageTextLineCount       = 3;
static const CGFloat    kDefaultMessageImageWidth   = 45.0f;
static const CGFloat    kDefaultMessageImageHeight  = 45.0f;


#define EXIST 10
#define NOT_EXIST 11
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TTTableStatusItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) {
        self.textLabel.font = TTSTYLEVAR(font);
        self.textLabel.textColor = TTSTYLEVAR(textColor);
        self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.textLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.contentMode = UIViewContentModeTopLeft;
        
        self.detailTextLabel.font = TTSTYLEVAR(font);
        self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.detailTextLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        self.detailTextLabel.contentMode = UIViewContentModeTopLeft;
        self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.detailTextLabel.numberOfLines = 100;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    // XXXjoe Compute height based on font sizes
    TTTableStatusItem* item = object;
    CGFloat height = kTableCellVPadding*1.5;
    if (item.title)
    {
        height += TTSTYLEVAR(font).ttLineHeight;
    }
    if (item.text)
    {
        UIFont *myTextFont = TTSTYLEVAR(font);
        CGSize maximumLabelSize = CGSizeMake(236,9999);
        CGSize linesSize = [item.text sizeWithFont:myTextFont
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:UILineBreakModeWordWrap];
        height += linesSize.height;
    }
    if(item.thumbImageURL)
    {
        height += 80;
    }
    // 针对有转发的情况
    if(item.forwardItem)
    {
        // 转发部分不要标题了，与转发正文合并显示
        if (item.forwardItem.title.length)
        {
            height += TTSTYLEVAR(font).ttLineHeight;
        }
        if (item.forwardItem.text)
        {
            UIFont *myTextFont = TTSTYLEVAR(tableTimestampFont);
            CGSize maximumLabelSize = CGSizeMake(212,9999);
            CGSize linesSize = [item.forwardItem.text sizeWithFont:myTextFont
                                                 constrainedToSize:maximumLabelSize
                                                     lineBreakMode:UILineBreakModeWordWrap];
            height += linesSize.height;
        }
        if(item.forwardItem.thumbImageURL)
        {
            height += 85;
        }
        height += 14;
    }
    else
    {
        height -= 4;
    }
    if(item.commentCount)
    {
        height += TTSTYLEVAR(font).ttLineHeight;
    }
    if (item.from)
    {
        height += TTSTYLEVAR(font).ttLineHeight;
    }
    if (item.imageURL)
    {
        height = height > kDefaultMessageImageHeight ? height : kDefaultMessageImageHeight;
    }
    int weitiao = 9;
    height += weitiao;
    return height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    [_iconImageBkg unsetImage];
    [_iconImage unsetImage];
    [_thumbImage unsetImage];
    // _thumbImage.urlPath = nil;
    //_forwardView.tag = NOT_EXIST;
    _titleLabel.text = nil;
    _timestampLabel.text = nil;
    _dashView.tag = NOT_EXIST;
    _forwardView.tag = 0;
    _forwardTextLabel.text = nil;
    _forwardTitleLabel.text = nil;
    _fromLabel.text = nil;
    _commentCountLabel.text = nil;
    [_forwardThumbImage unsetImage];
    self.captionLabel.text = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    @synchronized(self){
      
        
        CGFloat left = 0.0f;
        // 1 左侧是一个头像
        if(_iconImageBkg){
            _iconImageBkg.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                          kDefaultMessageImageWidth, kDefaultMessageImageHeight);
            left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
            _iconImage.frame = CGRectMake(3, 3,
                                          kDefaultMessageImageWidth-7, kDefaultMessageImageHeight-7);
        }
        else
        {
            left = kTableCellMargin;
        }
        
//        if (_iconImage) {
//            _iconImage.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
//                                          kDefaultMessageImageWidth, kDefaultMessageImageHeight);
//            left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;
//        }
//        else
//        {
//            left = kTableCellMargin;
//        }
        // 2 开始右侧部分
        CGFloat bubbleLeft = left;
        CGFloat buubleTop = 8;
        CGFloat bubbleLeftPadding = 15;
        CGFloat bubbleTopPadding = 3;
        CGFloat bubbleRightMargin = 3;
        CGFloat bubbleWidth = self.contentView.width - left - bubbleRightMargin; 
        CGFloat width = bubbleWidth - bubbleLeftPadding - bubbleRightMargin ; // 右侧实际内容的总宽度
        CGFloat top = kTableCellSmallMargin;
        left += bubbleLeftPadding;
        top += bubbleTopPadding;
        // 2.1 标题，目前就是状态来源的昵称 转发部分不要标题了，与2.4.2合并显示
        if (_titleLabel.text.length) {
            _titleLabel.frame = CGRectMake(left + 3, top, width, _titleLabel.font.ttLineHeight);
            top += _titleLabel.height;
        }
        else
        {
            _titleLabel.frame = CGRectZero;
        }
        // 2.2 正文
        top += 3;
        if (self.detailTextLabel.text.length) {
            CGSize maximumLabelSize = CGSizeMake(236,9999);
            CGSize expectedLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                             constrainedToSize:maximumLabelSize
                                                                 lineBreakMode:self.detailTextLabel.lineBreakMode];
            self.detailTextLabel.frame = CGRectMake(left + 3, top, 236, expectedLabelSize.height);
            self.detailTextLabel.textColor = [UIColor blackColor];
            top += expectedLabelSize.height;
        }
        else
        {
            self.detailTextLabel.frame = CGRectZero;
        }
        // 2.3 正文附图
        if(_thumbImage.urlPath != nil)
        {
            self.thumbImage.frame = CGRectMake(left + 10, top + 5, 75, 75);
            self.thumbImage.contentMode = UIViewContentModeScaleAspectFit;
            
            self.thumbImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbImageClicked)];
            [self.thumbImage addGestureRecognizer:singleTap];
            // TTSolidBorderStyle* st = [TTSolidBorderStyle styleWithColor:[UIColor blackColor]
            //                                                       width:4
            //                                                       next:nil];
            // [self.thumbImage.style addStyle:st];
            // self.thumbImage.backgroundColor = [UIColor blackColor];
            //        self.thumbImage.style =   [TTShapeStyle styleWithShape: st];
            top += 80;
        }
        else
        {
            self.thumbImage.frame = CGRectZero;
        }
        // 2.4 转发部分
        if(_dashView.tag == EXIST )
        {            
            CGFloat forwardWidth = width - 30;
            CGFloat forwardLeft = left + 13;
            
            
            // forwardView现在不用了，取而代之的是一行虚线
            /*
            _forwardView.frame = CGRectMake(left, top, width-10, 200);
            UIColor* black = RGBCOLOR(158, 163, 172);
            TTStyle* style = [TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:5
                                                                                 pointLocation:60
                                                                                    pointAngle:90
                                                                                     pointSize:CGSizeMake(10,5)] next:
                              [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
                               [TTSolidBorderStyle styleWithColor:black width:1 next:nil]]];
            _forwardView.backgroundColor = [UIColor clearColor];
            _forwardView.style = style;
            */
            top += 5;
            _dashView.frame = CGRectMake(forwardLeft, top, forwardWidth , 3);
            top+= 5;
            
            // 2.4.1 转发部分标题
            if (_forwardTitleLabel.text.length)
            {
                _forwardTitleLabel.frame = CGRectMake(forwardLeft, top, forwardWidth, _forwardTitleLabel.font.ttLineHeight);
                top += _forwardTitleLabel.height;
            }
            else
            {
                _forwardTitleLabel.frame = CGRectZero;
            }
            // 2.4.2 转发部分正文
            if (_forwardTextLabel.text.length) {
                CGSize maximumLabelSize = CGSizeMake(forwardWidth,9999);
                CGSize expectedLabelSize = [_forwardTextLabel.text sizeWithFont:_forwardTextLabel.font
                                                              constrainedToSize:maximumLabelSize
                                                                  lineBreakMode:_forwardTextLabel.lineBreakMode];
                _forwardTextLabel.frame = CGRectMake(forwardLeft, top, forwardWidth, expectedLabelSize.height);
                top += expectedLabelSize.height;             
            }
            else
            {
                _forwardTextLabel.frame = CGRectZero;
            }
            // 2.4.3 转发部分图片
            if(_forwardThumbImage.urlPath != nil)
            {
                self.forwardThumbImage.frame = CGRectMake(forwardLeft, top + 5, 75, 75);
                self.forwardThumbImage.contentMode = UIViewContentModeScaleAspectFit;
                
                self.forwardThumbImage.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardThumbImageClicked)];
                [self.forwardThumbImage addGestureRecognizer:singleTap];
                
                top += 5 + 75;  // size height               
            }
            else
            {
                self.forwardThumbImage.frame = CGRectZero;
            }
            
            CGRect rec = _forwardView.frame;
            CGFloat newHeight = _forwardTitleLabel.frame.size.height
            + _forwardTextLabel.frame.size.height
            + _forwardThumbImage.frame.size.height
            + 17;
            
            // 如果有转发图的话，要额外再给它加点下边距会好看点 ^_^
            if(_forwardThumbImage.frame.size.height != 0)
                newHeight += 4;
            // _forwardView.frame = CGRectMake(rec.origin.x, rec.origin.y, rec.size.width, newHeight);
        }
        else
        {
            _dashView.frame = CGRectZero;
            //_forwardView.frame = CGRectZero;
            _forwardTitleLabel.frame = CGRectZero;
            _forwardTextLabel.frame = CGRectZero;
            _forwardThumbImage.frame = CGRectZero;
        }
        
        
        // 2.5 评论数
        if (_commentCountLabel.text.length) {
            top += 3;
            
            
            CGSize maximumLabelSize = CGSizeMake(width,9999);
            CGSize expectedLabelSize = [_commentCountLabel.text sizeWithFont:_commentCountLabel.font
                                                   constrainedToSize:maximumLabelSize
                                                       lineBreakMode:_commentCountLabel.lineBreakMode];
            _commentCountLabel.alpha = !self.showingDeleteConfirmation;
            [_commentCountLabel sizeToFit];
            _commentCountLabel.left = self.contentView.width -  (_commentCountLabel.width + kTableCellSmallMargin) - 4;
            _commentCountLabel.top = top;
            _commentCountLabel.backgroundColor = [UIColor clearColor];
            top += expectedLabelSize.height;
        }
        else
        {
            _commentCountLabel.frame = CGRectZero;
        }        
        
        // 2.6.1 信息来源
        if (_fromLabel.text.length) {
            CGSize maximumLabelSize = CGSizeMake(width,9999);
            CGSize expectedLabelSize = [_fromLabel.text sizeWithFont:_fromLabel.font
                                                   constrainedToSize:maximumLabelSize
                                                       lineBreakMode:_fromLabel.lineBreakMode];
            _fromLabel.frame = CGRectMake(left, top, expectedLabelSize.width, expectedLabelSize.height);
            top += expectedLabelSize.height;
        }
        else
        {
            _fromLabel.frame = CGRectZero;
        }
        
        // 2.6.2 时间
        if (_timestampLabel.text.length)
        {
            _timestampLabel.alpha = !self.showingDeleteConfirmation;
            [_timestampLabel sizeToFit];
            _timestampLabel.left = self.contentView.width -
            (_timestampLabel.width + kTableCellSmallMargin) - 4;
            _timestampLabel.top = _fromLabel.top;            
        }
        else
        {
            _timestampLabel.frame = CGRectZero;
        }
        
        self.bubbleImage.frame = CGRectMake(bubbleLeft, buubleTop, bubbleWidth, _timestampLabel.frame.origin.y + _timestampLabel.frame.size.height);
        [self.contentView sendSubviewToBack:self.bubbleImage];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        _iconImage.backgroundColor = self.backgroundColor;
        _thumbImage.backgroundColor = self.backgroundColor;
        _titleLabel.backgroundColor = self.backgroundColor;
        _timestampLabel.backgroundColor = self.backgroundColor;
        _forwardView.backgroundColor =  self.backgroundColor;
        _forwardTitleLabel.backgroundColor = self.backgroundColor;
        _forwardTextLabel.backgroundColor = self.backgroundColor;
        _forwardThumbImage.backgroundColor = self.backgroundColor;
        _fromLabel.backgroundColor = self.backgroundColor;
        _commentCountLabel.backgroundColor = self.backgroundColor;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];
        TTTableStatusItem* item = object;
        if (item.title.length) {
            self.titleLabel.text = item.title;
        }
        if (item.caption.length) {
            self.captionLabel.text = item.caption;
        }
        if (item.text.length) {
            self.detailTextLabel.text = item.text;
        }
        if (item.timestamp) {
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            NSString* strTime = [formatter stringFromDate:item.timestamp];
            self.timestampLabel.text = strTime;
        }
        //if (item.imageURL.length) {
        self.iconImage.urlPath = item.imageURL;
        if(item.itemViewModel.type == EntryType_RSS)
        {
            NSString *defaultpath = [[NSBundle mainBundle] pathForResource:@"RSSLogo" ofType:@"png"];
            UIImage* rssImage = [UIImage imageWithContentsOfFile:defaultpath];
            _iconImage.defaultImage = rssImage;
        }
        //}
        if (item.thumbImageURL) {
            self.thumbImage.urlPath = item.thumbImageURL;
        }
        if (item.from.length) {
            self.fromLabel.text = item.from;
        }
        if(item.commentCount.length)
        {
            self.commentCountLabel.text = [NSString stringWithFormat:@"评论:%@",item.commentCount];
        }
        if (item.forwardItem){
            self.dashView.tag = EXIST;
            self.forwardView.tag = EXIST;
            if( item.forwardItem.title.length )
            {
                self.forwardTitleLabel.text = item.forwardItem.title;
            }
            if(item.forwardItem.text.length)
            {
                self.forwardTextLabel.text = item.forwardItem.text;
            }
            if(item.forwardItem.thumbImageURL.length)
            {
                self.forwardThumbImage.urlPath = item.forwardItem.thumbImageURL;
            }
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBCOLOR(36, 112, 216);
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.font = TTSTYLEVAR(tableFont);
        _titleLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)captionLabel {
    return self.textLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.font = TTSTYLEVAR(tableTimestampFont);
        _timestampLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _timestampLabel.highlightedTextColor = [UIColor whiteColor];
        _timestampLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_timestampLabel];
    }
    return _timestampLabel;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)iconImageBkg {
    if (!_iconImageBkg) {
        _iconImageBkg = [[TTImageView alloc] init];
        _iconImageBkg.defaultImage = [UIImage imageNamed:@"bubble_rect.png"];
        [self.contentView addSubview:_iconImageBkg];
    }
    return _iconImageBkg;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)iconImage {
    if (!_iconImage) {
        _iconImage = [[TTImageView alloc] init];
        _iconImage.style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:5.0f] next:
                            [TTContentStyle styleWithNext:nil]];
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //_iconImage.style = TTSTYLE(rounded);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Cydia" ofType:@"png"];
        _iconImage.defaultImage = [UIImage imageWithContentsOfFile:path];
        [self.iconImageBkg addSubview:_iconImage];
    }
    return _iconImage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImageView*)bubbleImage {
    if (!_bubbleImage) {
        _bubbleImage = [[UIImageView alloc] init];
        UIImage* bubbleImageInner =  [UIImage imageNamed:@"bubble_left.png"];
        bubbleImageInner = [bubbleImageInner resizableImageWithCapInsets:UIEdgeInsetsMake(40,20,15,10)];
        _bubbleImage.image = bubbleImageInner;
        [self.contentView addSubview:_bubbleImage];
    }
    return _bubbleImage;
}

-(UIColor*)myGray
{
    return [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1.0f ];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)thumbImage {
    if (!_thumbImage) {
        _thumbImage = [[TTImageView alloc] init];
        _thumbImage.defaultImage = [UIImage imageNamed:@"DefaultPicture.png"];
        _thumbImage.layer.borderColor = [self myGray].CGColor;
        _thumbImage.layer.borderWidth = 1.0;
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //_thumbImage.style = TTSTYLE(rounded);
        [self.contentView addSubview:_thumbImage];
    }
    return _thumbImage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)forwardThumbImage {
    if (!_forwardThumbImage) {
        _forwardThumbImage = [[TTImageView alloc] init];
        _forwardThumbImage.defaultImage = [UIImage imageNamed:@"DefaultPicture.png"];
        _forwardThumbImage.layer.borderColor = [self myGray].CGColor;
        _forwardThumbImage.layer.borderWidth = 1.0;
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //_thumbImage.style = TTSTYLE(rounded);
        [self.contentView addSubview:_forwardThumbImage];
    }
    return _forwardThumbImage;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)forwardTitleLabel {
    if (!_forwardTitleLabel) {
        _forwardTitleLabel = [[UILabel alloc] init];
        _forwardTitleLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _forwardTitleLabel.highlightedTextColor = [UIColor whiteColor];
        _forwardTitleLabel.font = TTSTYLEVAR(font);
        _forwardTitleLabel.backgroundColor = [UIColor clearColor];
        _forwardTitleLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_forwardTitleLabel];
    }
    return _forwardTitleLabel;
}

- (UILabel*)forwardTextLabel {
    if (!_forwardTextLabel) {
        _forwardTextLabel = [[UILabel alloc] init];
        _forwardTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _forwardTextLabel.highlightedTextColor = [UIColor whiteColor];
        _forwardTextLabel.backgroundColor = [UIColor clearColor];
        _forwardTextLabel.font = TTSTYLEVAR(tableTimestampFont);
        _forwardTextLabel.contentMode = UIViewContentModeLeft;
        _forwardTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _forwardTextLabel.numberOfLines = 100;
        
        [self.contentView addSubview:_forwardTextLabel];
    }
    return _forwardTextLabel;
}

- (UILabel*)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [[UILabel alloc] init];
        _fromLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _fromLabel.highlightedTextColor = [UIColor whiteColor];
        _fromLabel.font = TTSTYLEVAR(tableTimestampFont);
        _fromLabel.contentMode = UIViewContentModeLeft;
        _fromLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _fromLabel.numberOfLines = 100;
        _fromLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_fromLabel];
    }
    return _fromLabel;
}


- (UILabel*)commentCountLabel {
    if (!_commentCountLabel) {
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        _commentCountLabel.highlightedTextColor = [UIColor whiteColor];
        _commentCountLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _commentCountLabel.contentMode = UIViewContentModeLeft;
        _commentCountLabel.lineBreakMode = UILineBreakModeTailTruncation;
        _commentCountLabel.numberOfLines = 1;
        _commentCountLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_commentCountLabel];
    }
    return _commentCountLabel;
}

- (TTView*)forwardView {
    if (!_forwardView) {
        _forwardView = [[TTView alloc] init];
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //_thumbImage.style = TTSTYLE(rounded);
       //[self.contentView addSubview:_forwardView];
    }
    return _forwardView;
}

-(UIDashView*)dashView
{
    if(!_dashView)
    {
        _dashView = [[UIDashView alloc]init];
        _dashView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_dashView];
    }
    return _dashView;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)rounded {
    return
    [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:1] next:
     //[TTSolidBorderStyle styleWithColor:[UIColor blackColor] width:4 next:
     [TTContentStyle styleWithNext:nil]];
}
#pragma warning restore

# pragma mark - Event handler
-(void)thumbImageClicked
{
    TTTableStatusItem* statusItem = (TTTableStatusItem*)_item;
    [self gotoPhotoViewerWithURL:statusItem.itemViewModel.fullImageURL];
}

-(void)forwardThumbImageClicked
{
    TTTableStatusItem* statusItem = (TTTableStatusItem*)_item;
    [self gotoPhotoViewerWithURL:statusItem.itemViewModel.forwardItem.fullImageURL];
}

// 因为在此处不方便拿到navigationController,所以实际上是到外转的TTStatusTImeLineViewController里去做页面跳转的
-(void)gotoPhotoViewerWithURL:(NSString*)url
{
    if(url == nil || url.length == 0)
        return;
    id table = [self superview];
    UIView* test2 = [table superview];
    UIViewController* viewController = [test2 firstAvailableUIViewController];
    // viewController is TTStatusTImeLineViewController in fact
    if([viewController isKindOfClass:[TTStatusTImeLineViewController class]])
    {
        if([viewController respondsToSelector:@selector(gotoPhotoViewerWithURL:)])
        {
            [viewController performSelector:@selector(gotoPhotoViewerWithURL:) withObject:url];
        }
    }
}

@end
