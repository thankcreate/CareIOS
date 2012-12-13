//
//  PasswordViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-13.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigateBar1;

@end

@implementation PasswordViewController

@synthesize input;
@synthesize realPassword;
@synthesize txtPassword;
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
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.navigateBar1.tintColor = [CareConstants headerColor];    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    input = @""; // 这里input必须要初始化，否则nil和任何东西比较都是相等，真奇怪
    realPassword = [defaults objectForKey:@"Global_Password"];
    txtPassword.secureTextEntry = YES;
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    //self.navigateBar1.frame = CGRectZero;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickUnlock:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"#_#"
                                                    message:@"大胆，竟然欺负到朕的头上来了！" delegate:nil
                                          cancelButtonTitle:@"臣罪该万死，求皇上饶命！" otherButtonTitles:nil];
    [alert show];
    return;
}
- (IBAction)clickBack:(id)sender
{
    int length = input.length;
    if(length == 0)
        return;
    
    input = [input substringToIndex:length - 1];
    txtPassword.text = input;
}

-(void)clickWith:(int)num
{
    // 最大输入长度为8
    if(input.length >= 8)
        return;

    input = [input stringByAppendingFormat:@"%d",num];
    txtPassword.text = input;
    if([input compare:realPassword] == NSOrderedSame || realPassword == nil)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [self performSegueWithIdentifier:@"Segue_GotoTabBarController2" sender:self];
    }

}

- (IBAction)click0:(id)sender {
    [self clickWith:0];
}
- (IBAction)click1:(id)sender {
    [self clickWith:1];
}
- (IBAction)click2:(id)sender {
    [self clickWith:2];
}
- (IBAction)click3:(id)sender {
    [self clickWith:3];
}
- (IBAction)click4:(id)sender {
    [self clickWith:4];
}
- (IBAction)click5:(id)sender {
    [self clickWith:5];
}
- (IBAction)click6:(id)sender {
    [self clickWith:6];
}
- (IBAction)click7:(id)sender {
    [self clickWith:7];
}
- (IBAction)click8:(id)sender {
    [self clickWith:8];
}
- (IBAction)click9:(id)sender {
    [self clickWith:9];
}
@end
