//
//  BlessingPageViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-3.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "BlessingPageViewController.h"
#import "BlessHelper.h"

NSString* defaultImages[] = {@"bkg_blessing_1.jpg", @"bkg_blessing_2.jpg", @"bkg_blessing_3.jpg"};
NSInteger PER_SHOW_TIME = 8;    // 每张图显示的总时间
NSInteger MIX_SHOW_TIME = 2;    // 两张图一起显示的时间(通过alpha混合在一起)
NSInteger SLIDE_TIME = 0.3;

@interface BlessingPageViewController ()

@end

@implementation BlessingPageViewController
@synthesize blessHelper;
@synthesize imageView1;
@synthesize imageView2;
@synthesize mBkgIndex;
@synthesize mItemIndex;
@synthesize timer;
@synthesize activeFlag;
@synthesize listImages;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    imageView1 = [[UIImageView alloc] init];
    imageView2 = [[UIImageView alloc] init];
    [self initImageView:imageView1];
    [self initImageView:imageView2];
    
    mBkgIndex = 0;
    mItemIndex = 0;
    activeFlag = 1;
    
  
    if(blessHelper == nil)
        blessHelper = [[BlessHelper alloc] init];
    //[blessHelper  fetchListImagePath];
    
    listImages = [blessHelper getBlessImages];
    
    if(listImages != nil && listImages.count !=0)
    {
        timer =  [NSTimer scheduledTimerWithTimeInterval:PER_SHOW_TIME - MIX_SHOW_TIME target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [timer fire];
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

}

- (void)timerFired:(NSTimer*)timer
{
    if(activeFlag == 1)
    {

        mBkgIndex = (++mBkgIndex) % listImages.count;
        imageView2.image = [listImages objectAtIndex:mBkgIndex];
        activeFlag = 2;
        [self initImageView:imageView2];
        [self applyAnimationToUIImageView:imageView2];
    }
    else if(activeFlag == 2)
    {
        mBkgIndex = (++mBkgIndex) % listImages.count;
        imageView1.image = [listImages objectAtIndex:mBkgIndex];
        activeFlag = 1;
        [self initImageView:imageView1];
        [self applyAnimationToUIImageView:imageView1];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
