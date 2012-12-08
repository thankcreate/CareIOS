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
    fetcher = [[SinaWeiboFetcher alloc] initWithDelegate:self];
    [fetcher startFetchCommentMan];
    
//    NSMutableArray *components = [NSMutableArray array];
//    
//    for (ItemViewModel* item in [MainViewModel sharedInstance].items){
//        NSCalendar *gregorian = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
//        NSDateComponents *weekdayComponents = [gregorian components:(NSHourCalendarUnit ) fromDate:item.time];
//        NSInteger hour = [weekdayComponents hour];
//        if (hour >= 8 && hour < 12)
//        {
//            var1++;
//        }
//        else if (hour >= 12 && hour < 18)
//        {
//            var2++;
//        }
//        else if (hour >= 18 && hour < 24)
//        {
//            var3++;
//        }        
//    }
//    
//    int max1 = (var1 > var2) ? var1 : var2;
//    int max2 = (var3 > var4) ? var3 : var4;
//    int max = (max1 > max2) ? max1 : max2;
//    lineChart.minValue = 0;
//    lineChart.maxValue = (max / 10 + 1) * 10;
//    lineChart.interval = max < 46 ? 5 : 10;
//    
//    NSMutableArray *ar = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:var1],
//                          [NSNumber numberWithInt:var2],
//                          [NSNumber numberWithInt:var3],
//                          [NSNumber numberWithInt:var4], nil];
//    NSMutableArray *lb = [NSMutableArray arrayWithObjects:@"上午",
//                          @"下午",
//                          @"晚上",
//                          @"凌晨",nil];
//    
//    
//    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
//    [component setTitle:@""];
//    [component setPoints:ar];
//    [component setShouldLabelValues:NO];
//    [component setColour:PCColorYellow];
//    [components addObject:component];
    
//    lineChart.xLabels = lb;
//    lineChart.components = components;

}

- (void)analysisEnemy:(EntryType)type
{
    name1 = @"";
    name2 = @"";
    name3 = @"";
    
    var1 = 0;
    var2 = 0;
    var3 = 0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BaseFetcher* fetcher;
    switch (type) {
        case EntryType_SinaWeibo:
        {
            fetcher = [[SinaWeiboFetcher alloc] initWithDelegate:self];
            NSURL* url = [NSURL URLWithString:[MiscTool getHerSinaWeiboIcon]];
            [avatarImage setImageWithURL:url];
            lblName.text = [defaults objectForKey:@"SinaWeibo_FollowerNickName"];
            herID = [defaults objectForKey:@"SinaWeibo_FollowerID"];
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

    
}

@end
