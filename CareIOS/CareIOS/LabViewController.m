//
//  LabViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LabViewController.h"
#import "MobClick.h"

NSString *const kGlobalYouMiAdAppID     = @"39d26244847fefa6";
NSString *const kGlobalYouMiAdAppSecret = @"aeb32146462b3699";
@interface LabViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation LabViewController
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;
@synthesize btn5;

@synthesize adView1;


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
    
    [MobClick event:@"LabViewController"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile2.png"]];
    
    
    // 1. 有米广告条
    // adView1
    adView1 = [[YouMiView alloc] initWithContentSizeIdentifier:YouMiBannerContentSizeIdentifier320x50 delegate:nil];
    
    ////////////////[必填]///////////////////
    // 设置APP ID 和 APP Secret
    adView1.appID = kGlobalYouMiAdAppID;
    adView1.appSecret = kGlobalYouMiAdAppSecret;
    
    ////////////////[可选]///////////////////
    // 设置您应用的版本信息
    adView1.appVersion = @"1.0";
    
    // 设置您应用的推开渠道号
    // adView1.channelID = 1;
    
    // 设置您应用的广告请求模式
    // adView1.testing = NO;
    
    // 可以设置委托
    // adView1.delegate = self;
    
    // 设置文字广告的属性
    // adView1.indicateBorder = NO;
    // adView1.indicateTranslucency = YES;
    // adView1.indicateRounded = NO;
    
    // adView1.indicateBackgroundColor = [UIColor purpleColor];
    // adView1.textColor = [UIColor whiteColor];
    // adView1.subTextColor = [UIColor yellowColor];
    
    // 添加对应的关键词
    // [adView1 addKeyword:@"女性"];
    // [adView1 addKeyword:@"19岁"];
    
    // 开始请求广告
	[adView1 start];
    
    // 设置位置
    CGRect frame1 = adView1.frame;
    frame1.origin.x = 0;
    frame1.origin.y = 0;
    adView1.frame = frame1;
    
	[self.scrollView addSubview:adView1];
    
    
    
    // 2. lab按钮
    btn1 = [[UIButton alloc] init];
    btn2 = [[UIButton alloc] init];
    btn3 = [[UIButton alloc] init];
    btn4 = [[UIButton alloc] init];
    btn5 = [[UIButton alloc] init];
    
    
    NSArray* listBtn = [NSArray arrayWithObjects:btn1, btn2, btn3, btn4, btn5, nil];
    NSArray* listImage = [NSArray arrayWithObjects:@"1_s.png",@"2_s.png",@"3_s.png",@"4_s.png",@"5_s.png", nil];
    CGFloat leftMargin = 20;
    CGFloat topMargin = 5 + adView1.frame.size.height;
    CGFloat buttonSize = 125;
    CGFloat betweenMargin = 15;
    for (int i = 0; i< listBtn.count; i++)
    {
        UIButton* btn = [listBtn objectAtIndex:i];
        int row = i / 2;
        int col = i % 2;
        CGRect rect = CGRectMake(leftMargin + col * (buttonSize + betweenMargin),
                                 topMargin + row * (buttonSize + betweenMargin),
                                 buttonSize,
                                 buttonSize);
        btn.frame = rect;
        [btn setBackgroundImage:[UIImage imageNamed:[listImage objectAtIndex:i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
    
    UIButton* btnLast = [listBtn objectAtIndex:(listBtn.count - 1)];
    self.scrollView.contentSize = CGSizeMake(320, btnLast.frame.origin.y + btnLast.frame.size.height + 20);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [CareConstants headerColor];

}
- (IBAction)btnClick:(id)sender {
    if(sender == btn1)
    {
        [self performSegueWithIdentifier:@"Segue_GotoTimeSpan" sender:self];        
    }
    else if(sender == btn2)
    {
        [self performSegueWithIdentifier:@"Segue_GotoCharactorAnalysis" sender:self];
    }
    else if(sender == btn3)
    {
        [self performSegueWithIdentifier:@"Segue_GotoEnemy" sender:self];
    }
    else if(sender == btn4)
    {
        [self performSegueWithIdentifier:@"Segue_Gotopercentage" sender:self];
    }
    else if(sender == btn5)
    {
        [self performSegueWithIdentifier:@"Segue_GotoCat" sender:self];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

//    self.scrollView.contentOffset = CGPointMake(0, 70);
//    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.scrollView.contentSize = CGSizeMake(320, 450);    
//    self.scrollView.autoresizesSubviews=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
