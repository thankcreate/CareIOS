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
#import "CareAppDelegate.h"


@interface LabEnemyViewController ()

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
    
    // 先做初始化
    mapManToCount = [NSMutableDictionary dictionaryWithCapacity:20];
    mapManToID = [NSMutableDictionary dictionaryWithCapacity:20];
    
    
	UIColor* myGreen = [UIColor colorWithRed:0.0f green:0.5 blue:0.0f alpha:1.0f ];
    // 1 header部分
    // 1.1 头像
    CGFloat top = 10;
    CGFloat left = 10;
    avatarImage = [[UIImageView alloc] init];
    CGRect imgPos = CGRectMake(left ,top , 60.0f, 60.0f);
    avatarImage.frame = imgPos;
    NSURL* url = [NSURL URLWithString:[MiscTool getHerIcon]];
    [avatarImage setImageWithURL:url];
    
    top += avatarImage.frame.size.height;
    
    avatarImage.layer.cornerRadius = 9.0;
    avatarImage.layer.masksToBounds = YES;
    avatarImage.layer.borderColor = myGreen.CGColor;
    avatarImage.layer.borderWidth = 4.0;
    [self.view addSubview:avatarImage];
    
    
    // 1.2 关注者姓名
    lblName = [[UILabel alloc] init];
    lblName.text = [MiscTool getHerName];
    lblName.Font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    lblName.textColor = myGreen;
    CGSize maximumLabelSize = CGSizeMake([self.view bounds].size.width - left  - avatarImage.frame.size.width - 10 ,9999);
    CGSize expectedLabelSize = [lblName.text sizeWithFont:lblName.font
                                        constrainedToSize:maximumLabelSize
                                            lineBreakMode:lblName.lineBreakMode];
    
    CGRect lblNamePos = CGRectMake(left + avatarImage.frame.size.width + 10
                                   , top - expectedLabelSize.height,
                                   expectedLabelSize.width,
                                   expectedLabelSize.height);
    lblName.frame = lblNamePos;
    [self.view addSubview:lblName];
    
    // 1.3 "分析对象"字样
    UILabel* lblAnalysis = [[UILabel alloc] init];
    lblAnalysis.text = @"分析对象:";
    lblAnalysis.Font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblAnalysis.textColor = myGreen;
    CGSize maximumLabelSize2 = CGSizeMake([self.view bounds].size.width - left  - avatarImage.frame.size.width - 10 ,9999);
    CGSize expectedLabelSize2 = [lblAnalysis.text sizeWithFont:lblAnalysis.font
                                             constrainedToSize:maximumLabelSize2
                                                 lineBreakMode:lblAnalysis.lineBreakMode];
    
    CGRect lblAnalysisPos = CGRectMake(lblName.frame.origin.x
                                       , lblName.frame.origin.y - expectedLabelSize.height + 10,
                                       expectedLabelSize2.width,
                                       expectedLabelSize2.height);
    lblAnalysis.frame = lblAnalysisPos;
    [self.view addSubview:lblAnalysis];
    
    lineChart = [[PCLineChartView alloc] initWithFrame:CGRectMake(left,top,[self.view bounds].size.width-20,[self.view bounds].size.height-top-20)];
    [lineChart setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self.view addSubview:lineChart];
    
    
    // 开始抓数据
    fetcher = [self defaultFetcher];
    [fetcher startFetchCommentMan];
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
        type = EntryType_Renren;
    }
    else if(TRUE)
    {
        // TODO
    }
    return resFetcher;

}

- (void)analysisEnemy:(EntryType)tp
{
    name1 = @"";
    name2 = @"";
    name3 = @"";
    
    var1 = 0;
    var2 = 0;
    var3 = 0;
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
        default:
            break;
    }    
    [fetcher startFetchCommentMan];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Fetcher delegate
- (void)fetchComplete:(NSArray*)result
{
    [mapManToCount removeAllObjects];
    [mapManToID removeAllObjects];
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
    if(sortResult.count == 1)
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
    if(sortResult.count == 2)
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



#pragma mark - TTPostControllerDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Sina
    if(buttonIndex == 0)
    {
        //lastSelectPostType = EntryType_SinaWeibo;
        [self analysisEnemy:EntryType_SinaWeibo];
    }
    // Renren
    else if(buttonIndex == 1)
    {
        //lastSelectPostType = EntryType_Renren;
        [self analysisEnemy:EntryType_Renren];
    }
    // Douban
    else if(buttonIndex == 2)
    {
        //lastSelectPostType = EntryType_Douban;
        [self analysisEnemy:EntryType_Douban];
    }
}
@end

@implementation ManToCountPair

@synthesize name;
@synthesize count;

@end
