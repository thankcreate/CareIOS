//
//  LabCharactorViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LabCharactorViewController.h"
#import "MiscTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PCPieChart.h"
@interface LabCharactorViewController ()

@end

@implementation LabCharactorViewController
@synthesize pieChart;
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
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height - top - height)/2,width,height)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    
    [self analysisCharacter]; // 分析过程
    NSMutableArray *components = [NSMutableArray array];
    PCPieComponent *component1 = [PCPieComponent pieComponentWithTitle:@"萝莉" value:var1];
    [component1 setColour:PCColorYellow];
    
    PCPieComponent *component2 = [PCPieComponent pieComponentWithTitle:@"女王" value:var2];
    [component2 setColour:PCColorGreen];
    
    PCPieComponent *component3 = [PCPieComponent pieComponentWithTitle:@"天然呆" value:var3];
    [component3 setColour:PCColorOrange];
    
    PCPieComponent *component4 = [PCPieComponent pieComponentWithTitle:@"吃货" value:var4];
    [component4 setColour:PCColorRed];
    
    PCPieComponent *component5 = [PCPieComponent pieComponentWithTitle:@"伪娘" value:var5];
    [component5 setColour:PCColorBlue];

    [components addObject:component1];
    [components addObject:component2];
    [components addObject:component3];
    [components addObject:component4];
    [components addObject:component5];
    [pieChart setComponents:components];
    [self.view addSubview:pieChart];
    top += pieChart.frame.size.height;
    
    // 3 统计文字
    top -= 20;  // 微调
    NSArray *listLabel = [NSArray arrayWithObjects:@"萝莉指数:", @"女王指数:", @"天然呆指数:", @"吃货指数:", @"伪娘指数:", nil];
    NSArray *valueLable = [NSArray arrayWithObjects:
                           [NSNumber numberWithInt:var1],
                           [NSNumber numberWithInt:var2],
                           [NSNumber numberWithInt:var3],
                           [NSNumber numberWithInt:var4],
                           [NSNumber numberWithInt:var5], nil];
    CGFloat leftMargin = 10.0f;
    for (int i = 0; i < 5; ++i)
    {
        UILabel* lb1 = [[UILabel alloc] init];
        lb1.text = [listLabel objectAtIndex:i];
        lb1.textColor = myGreen;
        lb1.Font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        lb1.frame = CGRectMake(left + leftMargin, top, 320, 50);
        [lb1 sizeToFit];
        [self.view addSubview:lb1];
        
        UILabel* lb2 = [[UILabel alloc] init];
        NSNumber* num = [valueLable objectAtIndex:i];
        lb2.text = [num stringValue];
        lb2.textColor = myGreen;
        lb2.frame = CGRectMake(left + leftMargin + lb1.frame.size.width + 10, top, 320, 50);
        [lb2 sizeToFit];
        
        top += lb1.frame.size.height;
        [self.view addSubview:lb2];
    }    
}


- (int)calculateString:(NSString*)str
{    
    int sig = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            sig += (int)(*p);
        }
        else
        {
            p++;
        }
        
    }
    return sig;
}

- (void)analysisCharacter
{
    NSString* hername = [MiscTool getHerName];
    int sig = [self calculateString:hername];
    var1 = (int)(sig * 575 % 87 + 13);
    var2 = (int)(sig * sig % 87 + 13);
    var3 = (int)(sig * 250 % 87 + 13);
    var4 = (int)(sig * 337 % 87 + 13);
    var5 = (int)(sig * 702 % 87 + 13);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
