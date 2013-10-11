//
//  PreferenceViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-13.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "PreferenceViewController.h"
#import <Three20UI/Three20UI.h>
@interface PreferenceViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *switchPassword;
@property (strong, nonatomic) IBOutlet UISwitch *switchSound;
@property (strong, nonatomic) IBOutlet UISwitch *switchShowFowardPicture;
@property (strong, nonatomic) IBOutlet UISwitch *switchBless;

@end

@implementation PreferenceViewController
@synthesize switchPassword;
@synthesize switchSound;
@synthesize switchShowFowardPicture;
@synthesize switchBless;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MiscTool setHeader:self];
    [self initUI];
}

-(void)initUI
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* usePassword = [defaults objectForKey:@"Global_UsePassword"];
    // 默认使用密码
    if(usePassword == nil)
    {
        switchPassword.on = NO;
    }
    else if([usePassword compare:@"YES"] == NSOrderedSame)
    {
        switchPassword.on = YES;
    }
    else if([usePassword compare:@"NO"] == NSOrderedSame)
    {
        switchPassword.on = NO;
    }
    
    NSString* useBlessingPage= [defaults objectForKey:@"Global_UseBlessingPage"];
    // 默认开启心语墙
    if(useBlessingPage == nil)
    {
        switchBless.on = YES;
    }
    else if([useBlessingPage compare:@"YES"] == NSOrderedSame)
    {
        switchBless.on = YES;
    }
    else if([useBlessingPage compare:@"NO"] == NSOrderedSame)
    {
        switchBless.on = NO;
    }
    
    NSString* playSound = [defaults objectForKey:@"Global_PlaySound"];
    // 默认开启声音
    if(playSound == nil)
    {
        switchSound.on = YES;
    }
    else if([playSound compare:@"YES"] == NSOrderedSame)
    {
        switchSound.on = YES;
    }
    else if([playSound compare:@"NO"] == NSOrderedSame)
    {
        switchSound.on = NO;
    }
    
    // 默认将转发照片显示在照片墙中
    NSString* useFowardPicture = [defaults objectForKey:@"Global_NeedFetchImageInRetweet"];
    if(useFowardPicture == nil)
    {
        switchShowFowardPicture.on = YES;
    }
    else if([useFowardPicture compare:@"YES"] == NSOrderedSame)
    {
        switchShowFowardPicture.on = YES;
    }
    else if([useFowardPicture compare:@"NO"] == NSOrderedSame)
    {
        switchShowFowardPicture.on = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int sec = indexPath.section;
    int row = indexPath.row;
    if(sec == 1)
    {
        // 访问网站
        if(row == 0)
        {
            TTWebController* controller = [[TTWebController alloc] init];
            NSURL *url = [NSURL URLWithString:@"http://www.care4only1.com"];
            [self.navigationController pushViewController:controller animated:YES];
            [MiscTool setHeader:controller];
            [controller openURL:url];
        }
        // 邮件反馈
        else if (row == 1)
        {
            @try {
                MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                [controller setSubject:@"论改进一下之必要性"];
                [controller setMessageBody:@"" isHTML:NO];
                [MiscTool setHeader:controller];
                
                NSArray *toRecipients = [NSArray arrayWithObject: @"thankcreate@gmail.com"];
                [controller setToRecipients:toRecipients];
                
                [self presentViewController:controller animated:YES completion:nil];
            }
            @catch (NSException *exception) {
                int a  = 1;
                a++;
            }
            @finally {
                int a  = 1;
                a++;
            }
        }
        // 评分
        else if(row == 2)
        {
            [MiscTool gotoReviewPage];
        }
        // 关于
        else if(row == 3)
        {
            [self performSegueWithIdentifier:@"Segue_GotoAboutPage" sender:self];
        }
    }
    
    // 清除选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - switch value changed
- (IBAction)switchPasswordValueChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    if(switchPassword.on)
    {
        [defaults setObject:@"YES" forKey:@"Global_UsePassword"];
        [self performSegueWithIdentifier:@"Segue_GotoSetPasswordPage" sender:self];
    }
    else
    {
        [defaults setObject:@"NO" forKey:@"Global_UsePassword"];
        [defaults removeObjectForKey:@"Global_Password"];
    }
    [defaults synchronize];
}

- (IBAction)switchBlessValueChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(switchBless.on)
    {
        [defaults setObject:@"YES" forKey:@"Global_UseBlessingPage"];
    }
    else
    {
        [defaults setObject:@"NO" forKey:@"Global_UseBlessingPage"];
    }
    [defaults synchronize];
}

- (IBAction)switchSoundValueChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    if(switchSound.on)
    {
        [defaults setObject:@"YES" forKey:@"Global_PlaySound"];
    }
    else
    {
        [defaults setObject:@"NO" forKey:@"Global_PlaySound"];
    }
    [defaults synchronize];
}

- (IBAction)switchShowFowardPictureValueChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];    
    if(switchShowFowardPicture.on)
    {
        [defaults setObject:@"YES" forKey:@"Global_NeedFetchImageInRetweet"];
    }
    else
    {
        [defaults setObject:@"NO" forKey:@"Global_NeedFetchImageInRetweet"];
    }
    [defaults synchronize];
}


//
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)viewDidUnload {
    [self setSwitchBless:nil];
    [super viewDidUnload];
}
@end
