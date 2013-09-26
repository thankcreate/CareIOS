//
//  LabPencentageViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LabPencentageViewController.h"
#import "MiscTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MobClick.h"
@interface LabPencentageViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIImageView *herImage;
@property (strong, nonatomic) IBOutlet UIImageView *myImage;
@property (strong, nonatomic) IBOutlet UILabel *lblHerName;
@property (strong, nonatomic) IBOutlet UILabel *lblMyName;


@property (strong, nonatomic) IBOutlet UIScrollView *sv;

@end

@implementation LabPencentageViewController

@synthesize col1;
@synthesize col2;


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
    [MobClick event:@"LabPencentageViewController"];
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile2.png"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    [MiscTool autoAdjuctScrollView:self.sv];
    
    UIColor* myGreen = [UIColor colorWithRed:0.0f green:0.5 blue:0.0f alpha:1.0f ];
    NSString* herStrUrl = [MiscTool getHerIcon];
    NSURL* herUrl = [NSURL URLWithString:herStrUrl];
    [self.herImage setImageWithURL:herUrl];    
    self.herImage.layer.cornerRadius = 9.0;
    self.herImage.layer.masksToBounds = YES;
    self.herImage.layer.borderColor = myGreen.CGColor;
    self.herImage.layer.borderWidth = 0.0;
    self.herImage.contentMode = UIViewContentModeScaleAspectFill;


    
    NSString* myStrUrl = [MiscTool getMyIcon];
    NSURL* myUrl = [NSURL URLWithString:myStrUrl];
    [self.myImage setImageWithURL:myUrl];
    self.myImage.layer.cornerRadius = 9.0;
    self.myImage.layer.masksToBounds = YES;
    self.myImage.layer.borderColor = myGreen.CGColor;
    self.myImage.layer.borderWidth = 0.0;
    self.myImage.contentMode = UIViewContentModeScaleAspectFill;

    
    self.lblHerName.text = [MiscTool getHerName];
    self.lblHerName.Font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    self.lblHerName.textColor = [CareConstants labPink];
    [self.lblHerName sizeToFit];

    
    self.lblMyName.text = [MiscTool getMyName];
    self.lblMyName.Font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    self.lblMyName.textColor = [CareConstants labPink];
 
    
    
    NSMutableArray *temp = [NSMutableArray array];
    for(int j = 0; j < 3; j++)
    {
        for(int i = 0; i < 10 ; ++i)
        {
            [temp addObject:[NSNumber numberWithInt:i]];
        }
    }

    col1 = [NSArray arrayWithArray:temp];
    col2 = [NSArray arrayWithArray:temp];
    
    
    float headerHeight = self.herImage.frame.origin.y + self.herImage.frame.size.height;
    CGRect oriPikcerFrame = self.picker.frame;
    self.picker.frame = CGRectMake(oriPikcerFrame.origin.x,
                                   ([UIScreen mainScreen].bounds.size.height - 64 - headerHeight) / 2 + headerHeight
                                   - oriPikcerFrame.size.height / 2,
                                   oriPikcerFrame.size.width,
                                   oriPikcerFrame.size.height);
    
    self.picker.userInteractionEnabled = NO;
    [self analysisPercentage];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)analysisPercentage
{
    NSString* hername = [MiscTool getHerName];
    unsigned long sig1 = [self calculateString:hername];
    NSString* myname = [MiscTool getMyName];
    unsigned long sig2 = [self calculateString:myname];
    long result = (sig1 + sig2) * 575 % 49 + 50;
    
    int first = result / 10;
    int secoend = result % 10;
    [self.picker selectRow:first + 10 + 5 inComponent:0 animated:YES];
    [self.picker selectRow:secoend + 10 - 5 inComponent:1 animated:YES];
    [self.picker reloadAllComponents];
    
    [self performSelector:@selector(showRight) withObject:self afterDelay:0.3];
    var = result;
}

-(void)showRight
{
    int first = var / 10;
    int secoend = var % 10;

    [self.picker selectRow:first + 10 inComponent:0 animated:YES];
    [self.picker selectRow:secoend + 10 inComponent:1 animated:YES];
}

- (long)calculateString:(NSString*)str
{
    long sig = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (long i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p)
        {
            p++;
            sig += (long)(*p);
        }
        else
        {
            p++;
        }
        
    }
    return sig;
}


#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return [self.col1 count];
    
    return [self.col2 count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 60;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if(component == 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 52)];
        label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        label.textAlignment = NSTextAlignmentRight;
        label.Font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
        label.backgroundColor = [UIColor clearColor];
        return label;
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 52)];
        label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
        label.textAlignment = NSTextAlignmentLeft;
        label.Font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
        label.backgroundColor = [UIColor clearColor];
        return label;
    }

}


#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    NSNumber* num;
    row = row % 10;
    if (component == 0)
    {
        num = [col1 objectAtIndex:row];        
    }
    else
    {
        num = [col2 objectAtIndex:row];
    }
    return [num stringValue];
}


-(NSString*)preLoadShareString
{
    NSString* result = @"";
    if(lastSelectPostType == EntryType_SinaWeibo)
    {
        NSString* herName = [MiscTool getHerSinaWeiboName];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* myName = [defaults objectForKey:@"SinaWeibo_NickName"];
        result = [NSString stringWithFormat:@"经某不靠谱的分析仪测算，@%@ 与 @%@ 的姻缘指数达到惊人的%d。去死去死团众，不管你们信不信，我反正不信了"
                  ,herName, myName, var];
    }
    else if(lastSelectPostType == EntryType_Renren)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* herName = [defaults objectForKey:@"Renren_FollowerNickName"];
        NSString* herID = [defaults objectForKey:@"Renren_FollowerID"];
        NSString* myName = [defaults objectForKey:@"Renren_NickName"];
        NSString* myID = [defaults objectForKey:@"Renren_ID"];
        
        result = [NSString stringWithFormat:@"经某不靠谱的分析仪测算，@%@(%@) 与 @%@(%@) 的姻缘指数达到惊人的%d。去死去死团众，不管你们信不信，我反正不信了"
                  , herName, herID, myName, myID, var];
    }
    else if(lastSelectPostType == EntryType_Douban)
    {
        NSString* herName = [MiscTool getHerDoubanName];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* myName = [defaults objectForKey:@"Douban_NickName"];

        result = [NSString stringWithFormat:@"经某不靠谱的分析仪测算，@%@ 与 @%@ 的姻缘指数达到惊人的%d。去死去死团众，不管你们信不信，我反正不信了"
                  ,herName, myName, var];
    }
    return result;
}

@end
