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
    // 这里必须要留这么一个全透明的navigateBar，设成红色
    // 不然的话，在后续页面不管怎么设，statusBar都设不成红色
    self.navigateBar1.tintColor = [CareConstants headerColor];    
	// Do any additional setup after loading the view.
         //   [self performSegueWithIdentifier:@"Segue_GotoPasswordPage" sender:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* usePassword = [defaults objectForKey:@"Global_UsePassword"];
    if(usePassword != nil && [usePassword compare:@"YES"] == NSOrderedSame)
    {
        [self performSegueWithIdentifier:@"Segue_GotoPasswordPage" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"Segue_GotoTabBarController" sender:self];        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
