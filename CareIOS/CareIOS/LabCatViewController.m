//
//  LabCatViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-9.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "LabCatViewController.h"
#import "SoundTool.h"

@interface LabCatViewController ()
@property (strong, nonatomic) IBOutlet UILabel *txtMiao;

@end

@implementation LabCatViewController
@synthesize inputStack;
@synthesize txtMiao;
const NSInteger UP = 1;
const NSInteger DOWN = 2;
const NSInteger LEFT = 3;
const NSInteger RIGHT = 4;
NSInteger correntArray[] = {UP,  UP, DOWN, DOWN, LEFT, RIGHT, LEFT, RIGHT};


/**
 * 当Egg被触发后，经过REGRET_TIME会使喵喵复原
 * 嗯，喵喵~
 */
NSInteger REGRET_TIME = 3;

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
    
    UIScrollView* rootScrollView = [[UIScrollView alloc] init];
    rootScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:rootScrollView];
    [self.view sendSubviewToBack:rootScrollView];
    
    [self.txtMiao removeFromSuperview];
    [rootScrollView addSubview:self.txtMiao];
    
	// Do any additional setup after loading the view.
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile2.png"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer *oneFingerSwipeUp =[[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(oneFingerSwipeUp:)] ;
    [oneFingerSwipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:oneFingerSwipeUp];
    
    UISwipeGestureRecognizer *oneFingerSwipeDown =[[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(oneFingerSwipeDown:)] ;
    [oneFingerSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:oneFingerSwipeDown];
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft =[[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(oneFingerSwipeLeft:)] ;
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight =[[UISwipeGestureRecognizer alloc]  initWithTarget:self action:@selector(oneFingerSwipeRight:)] ;
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
}

- (void)oneFingerSwipeUp:(UISwipeGestureRecognizer *)recognizer
{
    [self dispatchDirection:UP];
}

- (void)oneFingerSwipeDown:(UISwipeGestureRecognizer *)recognizer
{
    [self dispatchDirection:DOWN];
}

- (void)oneFingerSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    [self dispatchDirection:LEFT];
}
- (void)oneFingerSwipeRight:(UISwipeGestureRecognizer *)recognizer
{
    [self dispatchDirection:RIGHT];
}

- (void)dispatchDirection:(int)type
{
    if(inputStack == nil)
        inputStack = [NSMutableArray arrayWithCapacity:8];
    [inputStack addObject:[NSNumber numberWithInt:type]];
    [self judge];
    NSLog(@"%d", type);
}

- (void) judge
{
    if(inputStack == nil || inputStack.count == 0)
        return;
    for(int i = 0; i < inputStack.count; i++)
    {
        NSNumber* num = [inputStack objectAtIndex:i];
        NSInteger nNum = [num integerValue];
        if(correntArray[i] != nNum)
        {
            [inputStack removeAllObjects];
            return;
        }
    }
    
    // 如果任何一个单字都没有发生不匹配，而且已经到了正确长度
    // 则说明已经完全匹配，开始出效果
    if(inputStack.count == sizeof(correntArray) / sizeof(int))
    {
        [self showEgg];
        [inputStack removeAllObjects];
    }
}

-(void) showEgg
{
    txtMiao.text = @"喵喵~";
    CGRect rect = txtMiao.frame;
    txtMiao.frame = CGRectMake(rect.origin.x - 40, rect.origin.y, rect.size.width, rect.size.height);
    [SoundTool playSoundMiaoMiao];
    [self performSelector:@selector(regret) withObject:nil afterDelay:REGRET_TIME];
}

-(void) regret
{
    txtMiao.text = @"喵~";
    CGRect rect = txtMiao.frame;
    txtMiao.frame = CGRectMake(rect.origin.x + 40, rect.origin.y, rect.size.width, rect.size.height);
}


- (IBAction)helpClick:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"^_^"
                                                    message:@"亲，玩过魂斗罗没？" delegate:nil
                                          cancelButtonTitle:@"关你蛋事喵~" otherButtonTitles:nil];
    [alert show];
    return;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtMiao:nil];
    [super viewDidUnload];
}
@end
