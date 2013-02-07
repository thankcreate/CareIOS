//
//  LabBlessPostViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-7.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "LabBlessPostViewController.h"
#import "MiscTool.h"


@interface LabBlessPostViewController ()
@property (strong, nonatomic) IBOutlet UITextView *txtName;
@property (strong, nonatomic) IBOutlet UITextView *txtContent;
@property (strong, nonatomic) IBOutlet UILabel *lblRemainCount;

@end

@implementation LabBlessPostViewController
NSInteger MAX_COUNT = 60;

@synthesize blessHelper;
@synthesize lblRemainCount;
@synthesize txtName;
@synthesize txtContent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)applyBorderToTextView:(UITextView*)input
{
    [[input layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[input layer] setBorderWidth:1.3];
    [[input layer] setCornerRadius:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBackground];
    
    [self applyBorderToTextView:txtContent];
    [self applyBorderToTextView:txtName];
    
    txtName.text = [MiscTool getMyName];
    
}

-(void)initBackground
{
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"bkg_lab_bless.jpg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    CGFloat he = self.view.bounds.size.height;
    CGFloat wi = self.view.bounds.size.width;
    
    imageView.frame = CGRectMake(0, 0, wi, he);
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    [self refreshCountLable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtContent:nil];
    [self setTxtName:nil];
    [self setLblRemainCount:nil];
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtContent resignFirstResponder];
    [self.txtName resignFirstResponder];
}

- (IBAction)submit:(id)sender
{
    if(blessHelper == nil)
        blessHelper = [[BlessHelper alloc]init];
    if(txtContent.text == nil || txtContent.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"据说要智商超过250才能持到您的心语么？" delegate:nil
                                              cancelButtonTitle:@"唔～" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [blessHelper postBlessItemWithName:txtName.text content:txtContent.text delegate:self];
}

-(void)refreshCountLable
{
    NSInteger remain = MAX_COUNT -  txtContent.text.length;
    
    NSString* remainCountStr = [NSString stringWithFormat:@"剩余字数: %d",remain];
    lblRemainCount.text = remainCountStr;
}


#pragma mark - UITextView  delegate
- (void)textViewDidChange:(UITextView *)textView
{
   [self refreshCountLable];    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView == txtContent)
    {
        if (range.location >= MAX_COUNT)
            return NO; // return NO to not change text        
    }
    return YES;
}


- (void)blessItemPostComplete:(Boolean)isSuccess;
{
    if(isSuccess)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                        message:@"发表成功！" delegate:nil
                                              cancelButtonTitle:@"嗯嗯" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因网络请求失败，请确保网络畅通" delegate:nil
                                              cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
        [alert show];
        return;
    }
}
@end