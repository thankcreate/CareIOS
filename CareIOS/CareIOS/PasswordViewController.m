//
//  PasswordViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-13.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "PasswordViewController.h"
#import "CareAppDelegate.h"

@interface PasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigateBar1;

@property (strong, nonatomic) IBOutlet UIImageView *heart;
@property (strong, nonatomic) IBOutlet UIImageView *key;

@end

@implementation PasswordViewController

@synthesize input;
@synthesize realPassword;
@synthesize txtPassword;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isEnterForegroundMode = NO;
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
    
    CareAppDelegate *appDelegate = (CareAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isPasswordPageShowing = YES;
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
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.duration = 0.3f;
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        
        CGMutablePathRef pointPath = CGPathCreateMutable();
        CGPoint origin = CGPointMake(self.key.frame.origin.x + self.key.frame.size.width / 2,
                                     self.key.frame.origin.y + self.key.frame.size.height / 2);
        CGPathMoveToPoint(pointPath, NULL, origin.x, origin.y);
        CGPathAddLineToPoint(pointPath, NULL, origin.x - 28, origin.y);
        pathAnimation.path = pointPath;
        CGPathRelease(pointPath);
        
        [self.key.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
        
        
        pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.duration = 0.3f;
        pathAnimation.calculationMode = kCAAnimationPaced;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        
        pointPath = CGPathCreateMutable();
        origin = CGPointMake(self.heart.frame.origin.x + self.heart.frame.size.width / 2,
                                     self.heart.frame.origin.y + self.heart.frame.size.height / 2);
        CGPathMoveToPoint(pointPath, NULL, origin.x, origin.y);
        CGPathAddLineToPoint(pointPath, NULL, origin.x + 28, origin.y);
        pathAnimation.path = pointPath;
        CGPathRelease(pointPath);
        
        [self.heart.layer addAnimation:pathAnimation forKey:@"pathAnimation"];
        [self performSelector:@selector(gotoNextPage) withObject:self afterDelay:0.3];
        
        
    }
}

-(void)gotoNextPage
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    CareAppDelegate *appDelegate = (CareAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.isPasswordPageShowing = NO;
    if(self.isEnterForegroundMode)
    {

        for (UIView *subView in appDelegate.window.subviews)
        {
            if (subView.tag == 575)
            {
                [subView removeFromSuperview];
                break;
            }
        }
        
    }
    else
    {
        [self performSegueWithIdentifier:@"Segue_GotoTabBarController3" sender:nil];
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
