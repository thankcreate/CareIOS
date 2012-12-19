//
//  LabTimeSpanViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LabTimeSpanViewController.h"
#import "PCPieChart.h"
#import "PCLineChartView.h"
#import "MainViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MiscTool.h"
#import "MobClick.h"
@interface LabTimeSpanViewController ()

@end

@implementation LabTimeSpanViewController
@synthesize lineChart;
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
    
    [MobClick event:@"LabTimeSpanViewController"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile2.png"]];
    UIColor* myGreen = [UIColor colorWithRed:0.0f green:0.5 blue:0.0f alpha:1.0f ];
    // 1 header部分
    // 1.1 头像
    CGFloat top = 10;
    CGFloat left = 10;
    UIImageView *img = [[UIImageView alloc] init];
    CGRect imgPos = CGRectMake(left ,top , 60.0f, 60.0f);
    img.frame = imgPos;
    NSURL* url = [NSURL URLWithString:[MiscTool getHerIcon]];
    [img setImageWithURL:url];
    
    top += img.frame.size.height;
    
    img.layer.cornerRadius = 9.0;
    img.layer.masksToBounds = YES;
    img.layer.borderColor = myGreen.CGColor;
    img.layer.borderWidth = 4.0;
    [self.view addSubview:img];
    
    
    // 1.2 关注者姓名
    UILabel* lblName = [[UILabel alloc] init];
    lblName.text = [MiscTool getHerName];
    lblName.Font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    lblName.textColor = myGreen;
    lblName.backgroundColor = [UIColor clearColor];
    CGSize maximumLabelSize = CGSizeMake([self.view bounds].size.width - left  - img.frame.size.width - 10 ,9999);
    CGSize expectedLabelSize = [lblName.text sizeWithFont:lblName.font
                                                  constrainedToSize:maximumLabelSize
                                                      lineBreakMode:lblName.lineBreakMode];

    CGRect lblNamePos = CGRectMake(left + img.frame.size.width + 10
                                   , top - expectedLabelSize.height,
                                   expectedLabelSize.width,
                                   expectedLabelSize.height);
    lblName.frame = lblNamePos;
    [self.view addSubview:lblName];
    
    // 1.2 "分析对象"字样
    UILabel* lblAnalysis = [[UILabel alloc] init];
    lblAnalysis.text = @"分析对象:";
    lblAnalysis.Font = [UIFont fontWithName:@"Helvetica" size:15.0];
    lblAnalysis.textColor = myGreen;
    lblAnalysis.backgroundColor = [UIColor clearColor];
    CGSize maximumLabelSize2 = CGSizeMake([self.view bounds].size.width - left  - img.frame.size.width - 10 ,9999);
    CGSize expectedLabelSize2 = [lblAnalysis.text sizeWithFont:lblAnalysis.font
                                        constrainedToSize:maximumLabelSize2
                                            lineBreakMode:lblAnalysis.lineBreakMode];
    
    CGRect lblAnalysisPos = CGRectMake(lblName.frame.origin.x
                                   , lblName.frame.origin.y - expectedLabelSize.height + 10,
                                   expectedLabelSize2.width,
                                   expectedLabelSize2.height);
    lblAnalysis.frame = lblAnalysisPos;
    [self.view addSubview:lblAnalysis];
    
    // 2 统计图
    lineChart = [[PCLineChartView alloc] initWithFrame:CGRectMake(left,top,[self.view bounds].size.width-20,[self.view bounds].size.height - top)];
    [lineChart setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    [self.view addSubview:lineChart];
    
    NSMutableArray *components = [NSMutableArray array];

    for (ItemViewModel* item in [MainViewModel sharedInstance].items){
        NSCalendar *gregorian = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *weekdayComponents = [gregorian components:(NSHourCalendarUnit ) fromDate:item.time];
        NSInteger hour = [weekdayComponents hour];
        if (hour >= 8 && hour < 12)
        {
            var1++;
        }
        else if (hour >= 12 && hour < 18)
        {
            var2++;
        }
        else if (hour >= 18 && hour < 24)
        {
            var3++;
        }
        else if (hour >= 0 && hour < 8)
        {
            var4++;
        }
    }
    
    int max1 = (var1 > var2) ? var1 : var2;
    int max2 = (var3 > var4) ? var3 : var4;
    int max = (max1 > max2) ? max1 : max2;
    lineChart.minValue = 0;
    lineChart.maxValue = (max / 10 + 1) * 10;
    lineChart.interval = max < 46 ? 5 : 10;
    
    NSMutableArray *ar = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:var1],
                          [NSNumber numberWithInt:var2],
                          [NSNumber numberWithInt:var3],
                          [NSNumber numberWithInt:var4], nil];
    NSMutableArray *lb = [NSMutableArray arrayWithObjects:@"上午",
                          @"下午",
                          @"晚上",
                          @"凌晨",nil];

    
    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    [component setTitle:@""];
    [component setPoints:ar];
    [component setShouldLabelValues:NO];
    [component setColour:PCColorYellow];
    [components addObject:component];
    
    lineChart.xLabels = lb;
    lineChart.components = components;
	// Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*) GenerateMostActiveTime
{
    if (var1 >= var2 && var1 >= var3 && var1 >= var4)
        return @"上午";
    else if (var2 >= var1 && var2 >= var3 && var2 >= var4)
        return @"下午";
    else if (var3 >= var1 && var3 >= var2 && var2 >= var4)
        return @"晚上";
    else if (var4 >= var1 && var4 >= var2 && var4 >= var3)
        return @"半夜";
    
    return @"你妹的程序出BUG了啊~~~~~~~~~";
}

-(NSString*)GenerateMostActivePercentage
{
    int all = var1 + var2 + var3 + var4;
    int big = 0;
    if (var1 >= var2 && var1 >= var3 && var1 >= var4)
        big = var1;
    else if (var2 >= var1 && var2 >= var3 && var2 >= var4)
        big = var2;
    else if (var3 >= var1 && var3 >= var2 && var2 >= var4)
        big = var3;
    else if (var4 >= var1 && var4 >= var2 && var4 >= var3)
        big = var4;
    
    int percentage = (int)(big * 100 / all);
    return [NSString stringWithFormat:@"%d",percentage];
}

-(NSString*) GenerateAward
{
    if (var1 >= var2 && var1 >= var3 && var1 >= var4)
        return @"这么正常的活动规律我要是你我都不好意思出门";
    else if (var2 >= var1 && var2 >= var3 && var2 >= var4)
        return @"睡完午觉就无所事事的家伙";
    else if (var3 >= var1 && var3 >= var2 && var2 >= var4)
        return @"月色下的呤游者";
    else if (var4 >= var1 && var4 >= var2 && var4 >= var3)
        return @"程序员";
    
    return @"你妹的程序出BUG了啊~~~~~~~~~";
}

-(NSString*)preLoadShareString
{
    NSString* result = @"";
    if(lastSelectPostType == EntryType_SinaWeibo)
    {
        NSString* herName = [MiscTool getHerSinaWeiboName];
        result = [NSString stringWithFormat:@"据消息人士透露，@%@ 最活跃的时间是在%@，此段时间中的发贴量占全部发贴的%@%%, 获得了成就【%@】"
                  ,herName, [self GenerateMostActiveTime], [self GenerateMostActivePercentage], [self GenerateAward]];        
    }
    else if(lastSelectPostType == EntryType_Renren)
    {
        NSString* herName = [MiscTool getHerRenrenName];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* herID = [defaults objectForKey:@"Renren_FollowerID"];
        result = [NSString stringWithFormat:@"据消息人士透露，@%@(%@) 最活跃的时间是在%@，此段时间中的发贴量占全部发贴的%@%%, 获得了成就【%@】"
                  , herName, herID, [self GenerateMostActiveTime], [self GenerateMostActivePercentage], [self GenerateAward]];
    }
    else if(lastSelectPostType == EntryType_Douban)
    {
        NSString* herName = [MiscTool getHerDoubanName];
        result = [NSString stringWithFormat:@"据消息人士透露，@%@ 最活跃的时间是在%@，此段时间中的发贴量占全部发贴的%@%%, 获得了成就【%@】"
                  ,herName, [self GenerateMostActiveTime], [self GenerateMostActivePercentage], [self GenerateAward]];
    } 
    return result;
}

@end
