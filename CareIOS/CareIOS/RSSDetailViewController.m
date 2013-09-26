//
//  RSSDetailViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-15.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "RSSDetailViewController.h"
#import "ItemViewModel.h"
#import <Three20UI/Three20UI.h>
#import "MobClick.h"
@interface RSSDetailViewController ()

@end

@implementation RSSDetailViewController
@synthesize itemViewModel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [MobClick event:@"RSSDetailViewController"];
    
    UIColor* myGreen = [UIColor colorWithRed:0.0f green:0.5 blue:0.0f alpha:1.0f ];
    UIColor* myPink = [UIColor colorWithRed:240 / 255.0f green:190 / 255.0f blue:173 / 255.0f alpha:1.0f ];
    UIColor* myGray = [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1.0f ];
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
    [self.view addSubview:headerBkgImage];
   // [scrollView addSubview:headerBkgImage];
    
    top += headerBkgImage.frame.size.height;
    
    // 1.2 头像
    UIImageView *avatarImg = [[UIImageView alloc] init];
    CGRect imgPos = CGRectMake(width - 72 ,top - 68 , 60.0, 60.0);
    avatarImg.frame = imgPos;
    avatarImg.contentMode = UIViewContentModeScaleAspectFill;
    NSString *defaultpath = [[NSBundle mainBundle] pathForResource:@"RSSLogo" ofType:@"png"];
    UIImage* rssImage = [UIImage imageWithContentsOfFile:defaultpath];
    [avatarImg setImage:rssImage];
    
    avatarImg.layer.cornerRadius = 9.0;
    avatarImg.layer.masksToBounds = YES;
    avatarImg.layer.borderColor = myPink.CGColor;
    avatarImg.layer.borderWidth = 5.0;

     avatarImg.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:avatarImg];
    
    // 1.3 Web View
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                           headerBkgImage.frame.origin.y + headerBkgImage.frame.size.height,
                                                           self.view.bounds.size.width,
                                                           self.view.bounds.size.height
                                                                    - self.navigationController.navigationBar.frame.size.height
                                                                    - headerBkgImage.frame.size.height)];
    //webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:itemViewModel.originalURL];
    [webView loadHTMLString:itemViewModel.rssSummary baseURL:url];
    [self.view addSubview:webView];

    
   // [scrollView addSubview:avatarImg];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event handler
- (IBAction)goToOriginalPageClick:(id)sender
{
    TTWebController* controller = [[TTWebController alloc] init];
    NSURL *url = [NSURL URLWithString:itemViewModel.originalURL];
    [self.navigationController pushViewController:controller animated:YES];
    [MiscTool setHeader:controller];
    [controller openURL:url];
}

@end
