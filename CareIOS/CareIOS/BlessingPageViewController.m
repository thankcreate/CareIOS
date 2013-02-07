//
//  BlessingPageViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-3.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "BlessingPageViewController.h"
#import "BlessHelper.h"
#import "BlessItemViewModel.h"
NSInteger PER_SHOW_TIME = 8;    // 每张图显示的总时间
NSInteger MIX_SHOW_TIME = 2;    // 两张图一起显示的时间(通过alpha混合在一起)
NSInteger SLIDE_TIME = 0.3;

@interface BlessingPageViewController ()

@end

@implementation BlessingPageViewController
@synthesize blessHelper;
@synthesize imageView1;
@synthesize imageView2;
@synthesize imageViewEnter;
@synthesize mBkgIndex;
@synthesize mItemIndex;
@synthesize timer;
@synthesize activeFlag;
@synthesize listImages;
@synthesize listItems;
@synthesize txtName;
@synthesize txtContent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)initImageView:(UIImageView*)inputView
{
    CGFloat he = self.view.bounds.size.height * 1.2;
    CGFloat wi = self.view.bounds.size.width * 1.2;

    inputView.frame = CGRectMake(0, 0, wi, he);
    inputView.contentMode = UIViewContentModeScaleAspectFill;
    inputView.alpha = 0;
    
    [self.view addSubview:inputView];
}

-(void)initTextViews
{
    txtName.lineBreakMode = UILineBreakModeTailTruncation;
    txtName.textColor = [UIColor whiteColor];
    txtName.backgroundColor = [UIColor clearColor];
    txtName.font = [self nameFont];
    txtName.alpha = 0;
    
    txtContent.lineBreakMode = UILineBreakModeTailTruncation;
    txtContent.textColor = [UIColor whiteColor];
    txtContent.backgroundColor = [UIColor clearColor];
    txtContent.font = [self contentFont];
    txtContent.numberOfLines = 100;
    txtContent.alpha = 0;
}

-(UIFont*)nameFont
{
    return [UIFont fontWithName:@"Helvetica" size:12];
}


-(UIFont*)contentFont
{
    return [UIFont fontWithName:@"Helvetica" size:13];
}

// name在下， content在上
// name到下的距离是固定的
// name与content右对齐
-(void)initTextViewsWithItem:(BlessItemViewModel*) item
{
    CGFloat he = self.view.bounds.size.height;
    CGFloat wi = self.view.bounds.size.width;

    if(item == nil)
        return;
    
    CGFloat bottomMargin = 30.0;
    CGFloat leftMargin = 15.0;
    CGFloat marginBetweenNameAndContent = 3;
    
    NSString* name = [NSString stringWithFormat:@"- %@", item.title];
    NSString* content = item.content;
    
    CGSize maximumLabelSize = CGSizeMake(220,9999);
    CGSize nameExpectedLabelSize = [name sizeWithFont:[self nameFont]
                                constrainedToSize:maximumLabelSize
                                    lineBreakMode:UILineBreakModeTailTruncation];
    
    CGSize contentExpectedLabelSize = [content sizeWithFont:[self contentFont]
                                       constrainedToSize:maximumLabelSize
                                           lineBreakMode:UILineBreakModeTailTruncation];
    
    
    CGFloat relativeNameToContent = contentExpectedLabelSize.width - nameExpectedLabelSize.width;
    if(relativeNameToContent < 0)
        relativeNameToContent = 0;
    txtName.text = name;
    txtName.frame = CGRectMake(leftMargin + relativeNameToContent, he - bottomMargin - nameExpectedLabelSize.height,
                               nameExpectedLabelSize.width, nameExpectedLabelSize.height);
    
    txtContent.text = content;
    txtContent.frame = CGRectMake(leftMargin, he - bottomMargin - nameExpectedLabelSize.height - contentExpectedLabelSize.height - marginBetweenNameAndContent
                                  , contentExpectedLabelSize.width, contentExpectedLabelSize.height);
}

-(void)initEnterImage
{
    CGFloat he = self.view.bounds.size.height;
    CGFloat wi = self.view.bounds.size.width;
    
    CGFloat enterSize = 40;
    CGFloat rightMargin = 35;
    CGFloat bottomMargin = 200;
    
    imageViewEnter.userInteractionEnabled = YES;
    imageViewEnter.frame = CGRectMake(wi - enterSize - rightMargin, he - enterSize - bottomMargin, enterSize, enterSize);
    imageViewEnter.contentMode = UIViewContentModeScaleToFill;
    imageViewEnter.alpha = 1;
    imageViewEnter.image = [UIImage imageNamed:@"enter.png"];
    
    [self.view addSubview:imageViewEnter];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    imageView1 = [[UIImageView alloc] init];
    imageView2 = [[UIImageView alloc] init];
    imageViewEnter = [[UIImageView alloc] init];
    txtName = [[UILabel alloc] init];
    txtContent = [[UILabel alloc] init];
    
    [self initImageView:imageView1];
    [self initImageView:imageView2];
    [self initEnterImage];
    [self.view addSubview:txtName];
    [self.view addSubview:txtContent];
    [self initTextViews];
    
    mBkgIndex = 0;
    mItemIndex = 0;
    activeFlag = 1;
  
    if(blessHelper == nil)
        blessHelper = [[BlessHelper alloc] init];
    
    listImages = [blessHelper getBlessImages];
    listItems = [blessHelper getCachedBlessPassedItems];
    
    if(listImages != nil && listImages.count !=0)
    {
        timer =  [NSTimer scheduledTimerWithTimeInterval:PER_SHOW_TIME - MIX_SHOW_TIME target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [timer fire];
    }
    
    
    

    [blessHelper  cacheBlessImages];
    [blessHelper  cacheBlessPassedItems];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    id test  = [touch view];
    
    if ([touch view] == imageViewEnter)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* usePassword = [defaults objectForKey:@"Global_UsePassword"];
        if(usePassword != nil && [usePassword compare:@"YES"] == NSOrderedSame)
        {
            [self performSegueWithIdentifier:@"Segue_GotoPasswordPage" sender:self];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
            [self performSegueWithIdentifier:@"Segue_GotoTabBarController" sender:self];
        }

    }

    
}

- (void)applyAnimationToUIImageView:(UIImageView*)inputView
{
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         inputView.alpha = 0;
                     }
                     completion:^(BOOL completed){
                         [UIView animateWithDuration:2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              inputView.alpha = 1;
                                          }
                                          completion:nil];

                     }];
     
    
    [UIView animateWithDuration:11.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGAffineTransform move = CGAffineTransformMakeTranslation(self.view.bounds.size.width * -0.1, self.view.bounds.size.height * -0.1);
                         CGAffineTransform scale =  CGAffineTransformMakeScale(0.85, 0.85);
                         CGAffineTransform transform = CGAffineTransformConcat(scale, move);
                         inputView.transform = transform;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              inputView.transform = CGAffineTransformIdentity;
                                          }
                                          completion:nil];

                     }];
    
    [UIView animateWithDuration:MIX_SHOW_TIME
                          delay:PER_SHOW_TIME - MIX_SHOW_TIME
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         inputView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         //inputView.transform = CGAffineTransformIdentity;
                     }];
    
    // 必须要在每一个tick里做一次bringSbuviewToFrount
    [self.view bringSubviewToFront:txtContent];
    [self.view bringSubviewToFront:txtName];
    [self.view bringSubviewToFront:imageViewEnter];
}

-(void)applyAnimationToTextView
{
    txtContent.alpha = 0;
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         txtContent.alpha = 1;
                     }
                     completion:^(BOOL completed){
                                                
                     }];
    
    txtName.alpha = 0;
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         txtName.alpha = 1;
                     }
                     completion:^(BOOL completed){
                         
                     }];

}

- (void)timerFired:(NSTimer*)timer
{
    if(activeFlag == 1)
    {
        imageView2.image = [listImages objectAtIndex:mBkgIndex];
        activeFlag = 2;
        [self initImageView:imageView2];
        [self applyAnimationToUIImageView:imageView2];
        mBkgIndex = (++mBkgIndex) % listImages.count;
    }
    else if(activeFlag == 2)
    {       
        imageView1.image = [listImages objectAtIndex:mBkgIndex];
        activeFlag = 1;
        [self initImageView:imageView1];
        [self applyAnimationToUIImageView:imageView1];
         mBkgIndex = (++mBkgIndex) % listImages.count;
    }

    [self initTextViewsWithItem:[listItems objectAtIndex:mItemIndex]];
    [self applyAnimationToTextView];
    mItemIndex = (++mItemIndex) % listItems.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
