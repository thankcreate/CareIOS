//
//  LabEnemyViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LabEnemyViewController.h"
#import "PCLineChartView.h"
#import "MainViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MiscTool.h"
#import "CareConstants.h"
#import "SinaWeiboFetcher.h"
#import "RenrenFetcher.h"
#import "DoubanFetcher.h"
#import "CareAppDelegate.h"
#import "DOUAPIEngine.h"
#import "MobClick.h"

@interface LabEnemyViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *segBar;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;


@property (strong, nonatomic) UIImageView* avatarImage;
@property (strong, nonatomic) UILabel* lblName;
@property (strong, nonatomic) PCLineChartView* lineChart;
@end

@implementation LabEnemyViewController
@synthesize lineChart;
@synthesize avatarImage;
@synthesize lblName;

@synthesize fetcher;

@synthesize herID;

@synthesize name1;
@synthesize name2;
@synthesize name3;

@synthesize var1;
@synthesize var2;
@synthesize var3;

@synthesize id1;
@synthesize id2;
@synthesize id3;

@synthesize mapManToCount;
@synthesize mapManToID;
@synthesize type;

@synthesize toolBar;
@synthesize segBar;

@synthesize indicatorAlert;
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

    //[self.view bringSubviewToFront:self.toolBar];

    [MobClick event:@"LabEnemyViewController"];
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile2.png"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 先做初始化
    mapManToCount = [NSMutableDictionary dictionaryWithCapacity:20];
    mapManToID = [NSMutableDictionary dictionaryWithCapacity:20];
    
    
	UIColor* myGreen = [UIColor colorWithRed:0.0f green:0.5 blue:0.0f alpha:1.0f ];
    // 1 header部分
    // 1.1 头像
    CGFloat top = 10;
    CGFloat left = 10;
    avatarImage = [[UIImageView alloc] init];
    avatarImage.contentMode = UIViewContentModeScaleAspectFill;
    
    CGRect imgPos = CGRectMake(left ,top , 60.0f, 60.0f);
    avatarImage.frame = imgPos;
    NSURL* url = [NSURL URLWithString:[MiscTool getHerIcon]];
    [avatarImage setImageWithURL:url];
    
    top += avatarImage.frame.size.height;
    
    avatarImage.layer.cornerRadius = 9.0;
    avatarImage.layer.masksToBounds = YES;
    avatarImage.layer.borderColor = myGreen.CGColor;
    avatarImage.layer.borderWidth = 0.0;
    [self.rootScrollView addSubview:avatarImage];
    
    
    // 1.2 关注者姓名
    lblName = [[UILabel alloc] init];
    lblName.text = [MiscTool getHerName];
    lblName.Font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    lblName.textColor = [CareConstants labPink];
    lblName.backgroundColor = [UIColor clearColor];
    CGSize maximumLabelSize = CGSizeMake([self.view bounds].size.width - left  - avatarImage.frame.size.width - 10 ,9999);
    CGSize expectedLabelSize = [lblName.text sizeWithFont:lblName.font
                                        constrainedToSize:maximumLabelSize
                                            lineBreakMode:lblName.lineBreakMode];
    
    CGRect lblNamePos = CGRectMake(left + avatarImage.frame.size.width + 10
                                   , top - expectedLabelSize.height,
                                   expectedLabelSize.width,
                                   expectedLabelSize.height);
    lblName.frame = lblNamePos;
    [self.rootScrollView addSubview:lblName];
    
    // 1.3 "分析对象"字样
    UILabel* lblAnalysis = [[UILabel alloc] init];
    lblAnalysis.text = @"分析对象:";
    lblAnalysis.Font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblAnalysis.textColor = [CareConstants labPink];
    lblAnalysis.backgroundColor = [UIColor clearColor];
    CGSize maximumLabelSize2 = CGSizeMake([self.view bounds].size.width - left  - avatarImage.frame.size.width - 10 ,9999);
    CGSize expectedLabelSize2 = [lblAnalysis.text sizeWithFont:lblAnalysis.font
                                             constrainedToSize:maximumLabelSize2
                                                 lineBreakMode:lblAnalysis.lineBreakMode];
    
    CGRect lblAnalysisPos = CGRectMake(lblName.frame.origin.x
                                       , lblName.frame.origin.y - expectedLabelSize.height + 10,
                                       expectedLabelSize2.width,
                                       expectedLabelSize2.height);
    lblAnalysis.frame = lblAnalysisPos;
    [self.rootScrollView addSubview:lblAnalysis];
    
    CGFloat screenHeight = [ UIScreen mainScreen ].bounds.size.height;
    lineChart = [[PCLineChartView alloc] initWithFrame:CGRectMake(left, top,
                                                                  [self.view bounds].size.width - 20,
                                                                  screenHeight - 64 - top - 44 )];
    [lineChart setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self.rootScrollView addSubview:lineChart];
    
    [MiscTool setHeader:self];
    // 开始抓数据
    
    [self analysisEnemy:EntryType_NotSet];
}

-(BaseFetcher*)defaultFetcher
{
    BaseFetcher* resFetcher;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    CareAppDelegate *delegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo* sinaweibo = delegate.sinaweibo;
    Renren* renren = delegate.renren;
    
    if(sinaweibo.isAuthValid && [defaults objectForKey:@"SinaWeibo_FollowerID"])
    {
        resFetcher = [[SinaWeiboFetcher alloc] initWithDelegate:self];
        NSURL* url = [NSURL URLWithString:[MiscTool getHerSinaWeiboIcon]];
        [avatarImage setImageWithURL:url];
        lblName.text = [defaults objectForKey:@"SinaWeibo_FollowerNickName"];
        [lblName sizeToFit];        
        herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
        segBar.selectedSegmentIndex = 0;
        type = EntryType_SinaWeibo;
    }
    else if(renren.isSessionValid && [defaults objectForKey:@"Renren_FollowerID"])
    {
        resFetcher = [[RenrenFetcher alloc] initWithDelegate:self];
        NSURL* url = [NSURL URLWithString:[MiscTool getHerRenrenIcon]];
        [avatarImage setImageWithURL:url];
        lblName.text = [defaults objectForKey:@"Renren_FollowerNickName"];
        [lblName sizeToFit];        
        herID = [defaults objectForKey:@"Renren_FollowerID"];
        segBar.selectedSegmentIndex = 1;
        type = EntryType_Renren;
    }
    else if(TRUE)
    {
        resFetcher = [[DoubanFetcher alloc] initWithDelegate:self];
        NSURL* url = [NSURL URLWithString:[MiscTool getHerDoubanIcon]];
        [avatarImage setImageWithURL:url];
        lblName.text = [defaults objectForKey:@"Douban_FollowerNickName"];
        [lblName sizeToFit];
        herID = [defaults objectForKey:@"Douban_FollowerID"];
        segBar.selectedSegmentIndex = 2;
        type = EntryType_Douban;
    }
    return resFetcher;

}

- (void)analysisEnemy:(EntryType)tp
{
    name1 = @" ";
    name2 = @" ";
    name3 = @" ";
    
    var1 = [NSNumber numberWithInt:0];
    var2 = [NSNumber numberWithInt:0];
    var3 = [NSNumber numberWithInt:0];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (tp) {
        case EntryType_SinaWeibo:
        {
            fetcher = [[SinaWeiboFetcher alloc] initWithDelegate:self];
            NSURL* url = [NSURL URLWithString:[MiscTool getHerSinaWeiboIcon]];
            [avatarImage setImageWithURL:url];
            lblName.text = [defaults objectForKey:@"SinaWeibo_FollowerNickName"];
            [lblName sizeToFit];
            herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
            break;
        }
        case EntryType_Renren:
        {
            fetcher = [[RenrenFetcher alloc] initWithDelegate:self];
            NSURL* url = [NSURL URLWithString:[MiscTool getHerRenrenIcon]];
            [avatarImage setImageWithURL:url];
            lblName.text = [defaults objectForKey:@"Renren_FollowerNickName"];
            [lblName sizeToFit];
            herID = [defaults objectForKey:@"Renren_FollowerID"];
            break;
        }
        case EntryType_Douban:
        {
            fetcher = [[DoubanFetcher alloc] initWithDelegate:self];
            NSURL* url = [NSURL URLWithString:[MiscTool getHerDoubanIcon]];
            [avatarImage setImageWithURL:url];
            lblName.text = [defaults objectForKey:@"Douban_FollowerNickName"];
            [lblName sizeToFit];
            herID = [defaults objectForKey:@"Douban_FollowerID"];
            break;
        }
        default:
        {
            fetcher = [self defaultFetcher];
            break;
        }
    
    }    
    [fetcher startFetchCommentMan];
    
    lineChart.xLabels = nil;
    lineChart.components = nil;
    [lineChart setNeedsDisplay];


    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    indicatorAlert = [[UIAlertView alloc] initWithTitle:@"@_@" message:@"正在解析，请稍候喵～" delegate:self cancelButtonTitle:@"朕知道了～" otherButtonTitles: nil];
    [indicatorAlert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    CGFloat width = indicator.frame.size.width + 5;
    CGFloat height =  indicator.frame.size.height + 5;
    indicator.center = CGPointMake(width,  height);
    [indicator startAnimating];
    [indicatorAlert addSubview:indicator];   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Fetcher delegate
- (void)fetchComplete:(NSArray*)result
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if(indicatorAlert != nil)
        [indicatorAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    [mapManToCount removeAllObjects];
    [mapManToID removeAllObjects];
    if(result == nil || result.count == 0)
        return;
    for(CommentMan* man in result)
    {
        // 1.先计数
        NSNumber* count = [mapManToCount objectForKey:man.name];
        if(count)
        {
            int nCount = [count intValue];
            nCount ++;
            [mapManToCount setObject:[NSNumber numberWithInt:nCount] forKey:man.name];
        }
        else
        {
            [mapManToCount setObject:[NSNumber numberWithInt:1] forKey:man.name];
        }
        // 2.再存Name-ID对
        if(![mapManToID objectForKey:man.name])
        {
            [mapManToID setObject:man.ID forKey:man.name];
        }
    }
    
    NSMutableArray* sortList = [NSMutableArray arrayWithCapacity:100];
    NSArray* keys = [mapManToCount allKeys];
    for(NSString* name in keys)
    {
        NSNumber* count = [mapManToCount objectForKey:name];
        ManToCountPair* pair = [[ManToCountPair alloc] init];
        pair.name = name;
        pair.count = count;
        [sortList addObject:pair];
    }
    
    NSArray* sortResult = [sortList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber* count1 = ((ManToCountPair*)(obj1)).count;
        NSNumber* count2 = ((ManToCountPair*)(obj2)).count;
        NSComparisonResult res =  [count1 compare:count2];
        return -res;
    }];
    
    if(sortResult.count >= 3)
    {
        ManToCountPair* pair1 = [sortResult objectAtIndex:0];
        ManToCountPair* pair2 = [sortResult objectAtIndex:1];
        ManToCountPair* pair3 = [sortResult objectAtIndex:2];
        
        name1 = pair1.name;
        name2 = pair2.name;
        name3 = pair3.name;
        
        var1 = pair1.count;
        var2 = pair2.count;
        var3 = pair3.count;
        
        id1 = [mapManToID objectForKey:name1];
        id2 = [mapManToID objectForKey:name2];
        id3 = [mapManToID objectForKey:name3];
    }
    if(sortResult.count == 2)
    {
        ManToCountPair* pair1 = [sortResult objectAtIndex:0];
        ManToCountPair* pair2 = [sortResult objectAtIndex:1];

        name1 = pair1.name;
        name2 = pair2.name;

        
        var1 = pair1.count;
        var2 = pair2.count;
        
        id1 = [mapManToID objectForKey:name1];
        id2 = [mapManToID objectForKey:name2];
    }
    if(sortResult.count == 1)
    {
        ManToCountPair* pair1 = [sortResult objectAtIndex:0];
        
        name1 = pair1.name;
        
        var1 = pair1.count;
        
        id1 = [mapManToID objectForKey:name1];
    }
    [self refreshChart];
}

-(void)refreshChart
{
    NSMutableArray *components = [NSMutableArray array];

    int countMax = [var1 intValue];
    
    lineChart.minValue = 0;
    lineChart.maxValue = (countMax / 10 + 1) * 10;
    lineChart.interval = countMax < 46 ? 5 : 10;
    
    if(countMax <= 5)
    {
        lineChart.maxValue = 5;
        lineChart.interval = 1;
    }
    

    NSMutableArray *ar = [NSMutableArray arrayWithObjects:var2,
                          var1,
                          var3, nil];
    NSMutableArray *lb = [NSMutableArray arrayWithObjects:name2,
                          name1,
                          name3,nil];



    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    [component setTitle:@""];
    [component setPoints:ar];
    [component setShouldLabelValues:NO];
    [component setColour:PCColorOrange];
    [components addObject:component];
    lineChart.xLabels = lb;
    lineChart.components = components;
    [lineChart setNeedsDisplay];
}

#pragma mark - Event
- (IBAction)btnChoosePlatformClicked:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择数据来源"
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"新浪微博", @"人人网", @"豆瓣社区", nil];
  	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	[actionSheet showFromTabBar:self.tabBarController.tabBar];

}

- (IBAction)segValueChanged:(id)sender
{
    int buttonIndex = segBar.selectedSegmentIndex;
    // Sina
    if(buttonIndex == 0)
    {
        CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
        SinaWeibo* sinaweibo = appDelegate.sinaweibo;
        
        if( ![sinaweibo isAuthValid])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"新浪帐号尚未登陆或已过期" delegate:nil
                                                  cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [self analysisEnemy:EntryType_SinaWeibo];
    }
    // Renren
    else if(buttonIndex == 1)
    {
        CareAppDelegate *appDelegate = (CareAppDelegate *)[UIApplication sharedApplication].delegate;
        Renren* renren = appDelegate.renren;
        
        if( ![renren isSessionValid])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"人人帐号尚未登陆或已过期" delegate:nil
                                                  cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [self analysisEnemy:EntryType_Renren];
    }
    // Douban
    else if(buttonIndex == 2)
    {
        DOUService *service = [DOUService sharedInstance];
        if(![service isValid])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"豆瓣帐号尚未登陆或已过期" delegate:nil
                                                  cancelButtonTitle:@"喵了个咪的～" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [self analysisEnemy:EntryType_Douban];
    }
}


-(NSString*)preLoadShareString
{
    NSString* result = @"";
    if(lastSelectPostType == EntryType_SinaWeibo)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* herName = [defaults objectForKey:@"Renren_FollowerNickName"];

        result = [NSString stringWithFormat:@"收取了可观小的小费后，酒馆老板小声道:看在你对 @%@ 一片痴情的份上，我可以告诉你,你的头号情敌是 @%@ ，@%@ 也不可小觑，必要时还得留意一下 @%@"
                  ,herName, name1, name2, name3];
    }
    else if(lastSelectPostType == EntryType_Renren)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* herName = [defaults objectForKey:@"Renren_FollowerNickName"];
        
        result = [NSString stringWithFormat:@"收取了可观小的小费后，酒馆老板小声道:看在你对 @%@(%@) 一片痴情的份上，我可以告诉你,你的头号情敌是 @%@(%@) ，@%@(%@) 也不可小觑，必要时还得留意一下 @%@(%@)"
                  , herName, herID, name1, id1, name2, id2, name3, id3];
    }
    else if(lastSelectPostType == EntryType_Douban)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* herName = [defaults objectForKey:@"Douban_FollowerNickName"];
        
        result = [NSString stringWithFormat:@"收取了可观小的小费后，酒馆老板小声道:看在你对 @%@ 一片痴情的份上，我可以告诉你,你的头号情敌是 @%@ ，@%@ 也不可小觑，必要时还得留意一下 @%@"
                  ,herName, name1, name2, name3];
    }
    return result;
}


@end

@implementation ManToCountPair

@synthesize name;
@synthesize count;

@end
