//
//  SetPasswordViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-13.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SetPasswordViewController.h"

@interface SetPasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *txt1;
@property (strong, nonatomic) IBOutlet UITextField *txt2;
@end

@implementation SetPasswordViewController
@synthesize txt1;
@synthesize txt2;
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
    txt1.secureTextEntry = YES;
    txt2.secureTextEntry = YES;

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 这里要先做个判断，如果密码为空，则把是否使用密码的标记改为NO
// 这是因为有时候进入了设置密码页，但是两次输入不一样，或者用户直接啥都不做就返回了
// 这时应该看做没有设置密码
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* testPassword = [defaults objectForKey:@"Global_Password"];
    if(testPassword == nil || testPassword.length == 0)
    {
        [defaults setObject:@"NO" forKey:@"Global_UsePassword"];
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
    if(sec == 0 && row == 2)
    {
        if(txt1.text == nil || txt1.text.length == 0 ||
           txt2.text == nil || txt2.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"输入为空是想闹哪样的喵～" delegate:nil
                                                  cancelButtonTitle:@"寡人喻矣～" otherButtonTitles:nil];
            [alert show];
            return;
        }
        if([txt1.text compare:txt2.text] != NSOrderedSame)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                            message:@"两次输入不一样的喵～" delegate:nil
                                                  cancelButtonTitle:@"寡人喻矣～" otherButtonTitles:nil];
            [alert show];
            return;
        }
        // 好不容易成功了
        else
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:txt1.text forKey:@"Global_Password"];
            [defaults synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextField  delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location >= 8)
        return NO; // return NO to not change text
    return YES;
}
@end
