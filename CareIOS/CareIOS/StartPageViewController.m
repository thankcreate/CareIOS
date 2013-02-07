//
//  StartPageViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-13.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "StartPageViewController.h"

@interface StartPageViewController ()
@property (strong, nonatomic) IBOutlet UINavigationBar *navigateBar1;

@end

@implementation StartPageViewController

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
	
    CGFloat width = [ UIScreen mainScreen ].bounds.size.width;
    CGFloat height = [ UIScreen mainScreen ].bounds.size.height;
    UIImageView* imageViewerBkg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];

    UIImage* imgBkg;
    if(height > 480)
    {
        imgBkg = [UIImage imageNamed:@"Default-568h@2x.png"];
    }
    else
    {
        imgBkg = [UIImage imageNamed:@"Default.png"];
    }
    imageViewerBkg.image = imgBkg;
    [self.view addSubview:imageViewerBkg];
    // 这里必须要留这么一个全透明的navigateBar，设成红色
    // 不然的话，在后续页面不管怎么设，statusBar都设不成红色
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.navigateBar1.tintColor = [CareConstants headerColor];    
	// Do any additional setup after loading the view.
         //   [self performSegueWithIdentifier:@"Segue_GotoPasswordPage" sender:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* firstLaunch = [defaults objectForKey:@"Global_FirstLaunch"];
    NSString* usePassword = [defaults objectForKey:@"Global_UsePassword"];
    NSString* useBlessingPage= [defaults objectForKey:@"Global_UseBlessingPage"];
    
    if(firstLaunch == nil)
    {
        [defaults setObject:@"WhatEver" forKey:@"Global_FirstLaunch"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"Segue_GotoGuidePage" sender:self];
    }
    else if(useBlessingPage == nil || [useBlessingPage compare:@"YES"] == NSOrderedSame)
    {
        [self performSegueWithIdentifier:@"Segue_GotoBlessingPage" sender:self];    
    }
    else if(usePassword != nil && [usePassword compare:@"YES"] == NSOrderedSame)
    {
        [self performSegueWithIdentifier:@"Segue_GotoPasswordPage" sender:self];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [self performSegueWithIdentifier:@"Segue_GotoTabBarController" sender:self];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
