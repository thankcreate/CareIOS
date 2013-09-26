//
//  StatusDetailViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-9.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "StatusDetailViewController.h"
#import "Three20/Three20.h"
#import "UIImageView+WebCache.h"
#import "MiscTool.h"
#import "TTCommentViewController.h"
#import "MobClick.h"
@interface StatusDetailViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation StatusDetailViewController
@synthesize photos;
@synthesize scrollView;
@synthesize itemViewModel;
@synthesize lblCommentCount;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(itemViewModel != nil)
    {
        NSString* pre = @"评论:";
        NSString* combine = [pre stringByAppendingString:itemViewModel.commentCount];
        lblCommentCount.text = combine;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [MobClick event:@"StatusDetailViewController"];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile2.png"]];
    // self.view.backgroundColor = RGBCOLOR(236, 234, 224);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor* myGreen = [UIColor colorWithRed:0.0f green:0.5 blue:0.0f alpha:1.0f ];
    UIColor* myPink = [UIColor colorWithRed:240 / 255.0f green:190 / 255.0f blue:173 / 255.0f alpha:1.0f ];
    UIColor* myGray = [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1.0f ];
    UIColor* myBlue = RGBCOLOR(36, 112, 216);
    // 1 header部分
    // 1.1 背景
    CGFloat top = 0;
    CGFloat left = 0;
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = 110;
    CGRect headerBkgPos = CGRectMake(left ,top , width, height);
    UIImageView *headerBkgImage = [[UIImageView alloc] init];
    headerBkgImage.frame = headerBkgPos;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"header1" ofType:@"jpg"];
    headerBkgImage.image = [UIImage imageWithContentsOfFile:path];
    [scrollView addSubview:headerBkgImage];
    
    top += headerBkgImage.frame.size.height;
    
    // 1.2 头像    
    UIImageView *avatarImg = [[UIImageView alloc] init];
    CGRect imgPos = CGRectMake(width - 100 ,top - 50 , 80.0, 80.0);
    avatarImg.frame = imgPos;
    avatarImg.contentMode = UIViewContentModeScaleAspectFill;
    NSURL* url = [NSURL URLWithString:itemViewModel.largeIconURL];
    NSString *defaultpath = [[NSBundle mainBundle] pathForResource:@"DefaultAvatar" ofType:@"jpg"];
    UIImage* defaultImage = [UIImage imageWithContentsOfFile:defaultpath];
    [avatarImg setImageWithURL:url placeholderImage:defaultImage];
    
    avatarImg.layer.cornerRadius = 9.0;
    avatarImg.layer.masksToBounds = YES;
    avatarImg.layer.borderColor = myPink.CGColor;
    avatarImg.layer.borderWidth = 5.0;
    // avatarImg.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:avatarImg];
    
    // 1.3 名字
    CGFloat leftMargin = 10;
    CGFloat rightMargin = 10;
    left += leftMargin;
    width -= (leftMargin + rightMargin);
    
    UILabel* lblName = [[UILabel alloc] init];
    lblName.text = itemViewModel.title;
    lblName.Font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    lblName.textColor = myBlue;
    lblName.backgroundColor = [UIColor clearColor];

    CGRect namePos = CGRectMake(left ,top + 10 , avatarImg.frame.origin.x - leftMargin, 18);
    lblName.frame = namePos;
    [scrollView addSubview:lblName];
    
    top = lblName.frame.origin.y + lblName.frame.size.height + 5;
  

    // 2.1 正文
    if (itemViewModel.content.length) {
//        UILabel* lblContent = [[UILabel alloc] init];
//        lblContent.text = itemViewModel.content;
//        lblContent.Font = [UIFont fontWithName:@"Helvetica" size:15];
//        lblContent.textColor = [UIColor blackColor];
//      //  lblContent.lineBreakMode = NSLineBreakByWordWrapping;
//
//        CGSize maximumLabelSize = CGSizeMake(width,9999);
//        CGSize expectedLabelSize = [lblContent.text sizeWithFont:lblContent.font
//                                               constrainedToSize:maximumLabelSize
//                                                   lineBreakMode:lblContent.lineBreakMode];
//        lblContent.contentMode = UIViewContentModeTopLeft;
//        lblContent.lineBreakMode = NSLineBreakByTruncatingTail;
//        lblContent.numberOfLines = 100;
//        
//        lblContent.frame = CGRectMake(left, top, width, expectedLabelSize.height);
//        [scrollView addSubview:lblContent];
        
        TTNavigator* navigator = [TTNavigator navigator];
        navigator.delegate = self;
        navigator.window = [UIApplication sharedApplication].delegate.window;
        
        TTStyledTextLabel* lblContent = [[TTStyledTextLabel alloc] init];
        lblContent.text = [TTStyledText textWithURLs:itemViewModel.content lineBreaks:YES];     
        lblContent.Font = [UIFont fontWithName:@"Helvetica" size:15];
        lblContent.textColor = [UIColor blackColor];
        lblContent.backgroundColor = [UIColor clearColor];
        lblContent.contentMode = UIViewContentModeTopLeft;
        
        lblContent.frame = CGRectMake(left, top, width, 20.0f);
        [lblContent sizeToFit];
        [scrollView addSubview:lblContent];
        
        top += lblContent.frame.size.height;

    }
    
    // 2.3 正文附图
    
    if(itemViewModel.imageURL != nil)
    {
        UIImageView* thumbImage = [[UIImageView alloc] init];
        
        thumbImage.userInteractionEnabled = YES;        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbImageClicked)];        
        [thumbImage addGestureRecognizer:singleTap];       

        
        thumbImage.frame = CGRectMake(left, top + 5, 75, 75);
        thumbImage.contentMode = UIViewContentModeScaleAspectFit;

        NSURL* url = [NSURL URLWithString:itemViewModel.imageURL];
        [thumbImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"DefaultPicture.png"]];
        thumbImage.layer.cornerRadius = 0.0;
        thumbImage.layer.masksToBounds = YES;
        thumbImage.layer.borderColor = myGray.CGColor;
        thumbImage.layer.borderWidth = 1.0;
        [scrollView addSubview:thumbImage];
        top += 80;
    }

    // 2.4 转发部分
    TTView* forwardView = [[TTView alloc] init];
    if(itemViewModel.forwardItem)
    {
        CGFloat forwardWidth = width - 25;
        CGFloat forwardLeft = left + 7;
        
        forwardView.frame = CGRectMake(left, top, width-10, 200);
        UIColor* bkgColor = RGBCOLOR(255, 204, 204);
        TTStyle* style = [TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:4
                                                                             pointLocation:50
                                                                                pointAngle:90
                                                                                 pointSize:CGSizeMake(10,5)] next:
                          [TTSolidFillStyle styleWithColor:bkgColor next:
                           [TTSolidBorderStyle styleWithColor:bkgColor width:1 next:nil]]];
        forwardView.backgroundColor = [UIColor clearColor];
        forwardView.style = style;
        [scrollView addSubview:forwardView];

        top+= 10;
//        // 2.4.1 转发部分不要标题了，与2.4.2合并显示
//        UILabel* lblForwardTitle = [[UILabel alloc] init];
//        if (itemViewModel.forwardItem.title)
//        {            
//            lblForwardTitle.text = itemViewModel.forwardItem.title;
//            lblForwardTitle.Font = [UIFont fontWithName:@"Helvetica" size:13];
//            lblForwardTitle.textColor = [UIColor blackColor];
//            lblForwardTitle.backgroundColor = [UIColor clearColor]; 
//            CGSize maximumLabelSize = CGSizeMake(width,9999);
//            CGSize expectedLabelSize = [lblForwardTitle.text sizeWithFont:lblForwardTitle.font
//                                                   constrainedToSize:maximumLabelSize
//                                                       lineBreakMode:lblForwardTitle.lineBreakMode];
//            lblForwardTitle.contentMode = UIViewContentModeTopLeft;
//            lblForwardTitle.lineBreakMode = NSLineBreakByTruncatingTail;
//            lblForwardTitle.numberOfLines = 100;
//            
//            lblForwardTitle.frame = CGRectMake(forwardLeft, top, forwardWidth, expectedLabelSize.height);
//            [scrollView addSubview:lblForwardTitle];
//            top += lblForwardTitle.frame.size.height;
//        }
      
        // 2.4.2 转发部分正文
//        UILabel* lblForwardContent = [[UILabel alloc] init];
//        if (itemViewModel.forwardItem.content.length) {
//            lblForwardContent.text = itemViewModel.forwardItem.contentWithTitle;
//            lblForwardContent.Font = [UIFont fontWithName:@"Helvetica" size:13];
//            lblForwardContent.textColor = [UIColor blackColor];
//            lblForwardContent.backgroundColor = [UIColor clearColor]; 
//            
//            CGSize maximumLabelSize = CGSizeMake(width,9999);
//            CGSize expectedLabelSize = [lblForwardContent.text sizeWithFont:lblForwardContent.font
//                                                        constrainedToSize:maximumLabelSize
//                                                            lineBreakMode:lblForwardContent.lineBreakMode];
//            lblForwardContent.contentMode = UIViewContentModeTopLeft;
//            lblForwardContent.lineBreakMode = NSLineBreakByTruncatingTail;
//            lblForwardContent.numberOfLines = 100;
//            
//            lblForwardContent.frame = CGRectMake(forwardLeft, top, forwardWidth, expectedLabelSize.height);
//            [scrollView addSubview:lblForwardContent];
//            top += lblForwardContent.frame.size.height;
//        }
       
        TTStyledTextLabel* lblForwardContent = [[TTStyledTextLabel alloc] init];
        if (itemViewModel.forwardItem.content.length) {
            TTNavigator* navigator = [TTNavigator navigator];
            navigator.delegate = self;
            navigator.window = [UIApplication sharedApplication].delegate.window;
            
            lblForwardContent.text = [TTStyledText textWithURLs:itemViewModel.forwardItem.contentWithTitle lineBreaks:YES ];
            lblForwardContent.Font = [UIFont fontWithName:@"Helvetica" size:13];
            lblForwardContent.textColor = [UIColor blackColor];
            lblForwardContent.contentMode = UIViewContentModeTopLeft;
            lblForwardContent.backgroundColor = [UIColor clearColor]; 
            
            lblForwardContent.frame = CGRectMake(forwardLeft, top, forwardWidth, 20.0f);
            [lblForwardContent sizeToFit];
            [scrollView addSubview:lblForwardContent];
            
            top += lblForwardContent.frame.size.height;
        }


        // 2.4.3 转发部分图片
        UIImageView* forwardThumbImage = [[UIImageView alloc] init];
        if(itemViewModel.forwardItem.midImageURL)
        {
            NSURL* url = [NSURL URLWithString:itemViewModel.forwardItem.imageURL];
            [forwardThumbImage setImageWithURL:url  placeholderImage:[UIImage imageNamed:@"DefaultPicture.png"]];
            
            forwardThumbImage.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forwardThumbImageClicked)];
            [forwardThumbImage addGestureRecognizer:singleTap];
            
            forwardThumbImage.frame = CGRectMake(forwardLeft, top + 5, 75, 75);
            forwardThumbImage.contentMode = UIViewContentModeScaleAspectFit;
            // 没有下面一行的话，会不受frame的约束限制
            forwardThumbImage.layer.masksToBounds = YES;
            


            [scrollView addSubview:forwardThumbImage];
            top += 80;
        }


        CGRect rec = forwardView.frame;
        CGFloat newHeight = lblForwardContent.frame.size.height
        + forwardThumbImage.frame.size.height
        + 17;
        
        // 如果有转发图的话，要额外再给它加点下边距会好看点 ^_^
        if(itemViewModel.forwardItem.midImageURL)
            newHeight += 4;
        forwardView.frame = CGRectMake(rec.origin.x, rec.origin.y, rec.size.width, newHeight);
    }
    
    // 2.5评论数
    UIColor* bottomTextColor = RGBCOLOR(150, 150, 150);
    lblCommentCount = [[UILabel alloc] init];
    if (itemViewModel.timeText.length)
    {
        top += 5;
        if(itemViewModel.forwardItem)
        {
            top += 10;
        }
        lblCommentCount.Font = [UIFont fontWithName:@"Helvetica" size:13];
        lblCommentCount.textColor = bottomTextColor;
        lblCommentCount.backgroundColor = [UIColor clearColor];
        NSString* pre = @"评论:";
        NSString* combine = [pre stringByAppendingString:itemViewModel.commentCount];
        lblCommentCount.text = combine;
        
        CGSize maximumLabelSize = CGSizeMake(width,9999);
        CGSize expectedLabelSize = [lblCommentCount.text sizeWithFont:lblCommentCount.font
                                              constrainedToSize:maximumLabelSize
                                                  lineBreakMode:lblCommentCount.lineBreakMode];
        
        lblCommentCount.frame = CGRectMake(width - expectedLabelSize.width, top, expectedLabelSize.width, expectedLabelSize.height);
        [scrollView addSubview:lblCommentCount];
        top += lblCommentCount.frame.size.height;
        
    }

    
    // 2.5.1 信息来源

    UILabel* fromLabel = [[UILabel alloc] init];
    if (itemViewModel.type) {

        fromLabel.text = itemViewModel.fromText;
        fromLabel.Font = [UIFont fontWithName:@"Helvetica" size:13];
        fromLabel.textColor = bottomTextColor;
        fromLabel.backgroundColor = [UIColor clearColor];
        
        CGSize maximumLabelSize = CGSizeMake(width,9999);
        CGSize expectedLabelSize = [fromLabel.text sizeWithFont:fromLabel.font
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:fromLabel.lineBreakMode];
        fromLabel.frame = CGRectMake(left, top, expectedLabelSize.width, expectedLabelSize.height);
        top += expectedLabelSize.height;
        [scrollView addSubview:fromLabel];
        
    }

    // 2.5.2 时间
    UILabel* timeLable = [[UILabel alloc] init];
    if (itemViewModel.timeText.length)
    {
        timeLable.Font = [UIFont fontWithName:@"Helvetica" size:13];
        timeLable.textColor = bottomTextColor;
        timeLable.backgroundColor = [UIColor clearColor];
        timeLable.text = itemViewModel.timeText;
        
        CGSize maximumLabelSize = CGSizeMake(width,9999);
        CGSize expectedLabelSize = [timeLable.text sizeWithFont:timeLable.font
                                              constrainedToSize:maximumLabelSize
                                                  lineBreakMode:timeLable.lineBreakMode];

        timeLable.frame = CGRectMake(width - expectedLabelSize.width, fromLabel.frame.origin.y, expectedLabelSize.width, expectedLabelSize.height);
        [scrollView addSubview:timeLable];
        
    }
    CGFloat bottomMargin = 10.0f;
    scrollView.contentSize = CGSizeMake(320.0f, timeLable.frame.origin.y +  timeLable.frame.size.height + bottomMargin);
    scrollView.autoresizesSubviews=YES;
    

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)gotoCommentClick:(id)sender
{
    [self performSegueWithIdentifier:@"Segue_GotoCommentPage" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    id detailPage = segue.destinationViewController;
    if ([detailPage isKindOfClass:[TTCommentViewController class]])
    {
        ItemViewModel* item = itemViewModel;
        [detailPage setValue:item forKey:@"itemViewModel"];

    }
}

# pragma mark - Event handler
-(void)thumbImageClicked
{
    photos = [[NSMutableArray alloc] init];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:itemViewModel.fullImageURL]]];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

-(void)forwardThumbImageClicked
{
    photos = [[NSMutableArray alloc] init];
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:itemViewModel.forwardItem.fullImageURL]]];
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - TTNavigatorDelegate
- (BOOL)navigator: (TTBaseNavigator *)navigator shouldOpenURL:(NSURL *) URL {
    // setup a webcontroller with the URL and push it
    TTWebController *webController = [[TTWebController alloc] init];
    [webController openURL:URL];
    [self.navigationController pushViewController:webController animated:YES];
    [MiscTool setHeader:webController];

    // 返回NO以取消TTNavigate的那个跳转
    // 这是因为如果这里从TTNavigate跳转的话，webController页面会被认为是TTNavigate框架下的root页面
    // 也就没有返回按钮，这里实际上是截获url信息，然后用原生的navigationController框架下跳转
    return NO;
}



#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    if(photos == nil)
        return 0;
    return photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if(photos == nil)
        return nil;
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}


@end
