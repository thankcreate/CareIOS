//
//  GuideViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-16.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "GuideViewController.h"

static NSUInteger kNumberOfPages = 5;

@interface GuideViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) UIButton* btnEnter;
@end

@implementation GuideViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize viewControllers;
@synthesize btnEnter;
@synthesize listImageName;

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
    CGFloat width = [ UIScreen mainScreen ].bounds.size.width;
    CGFloat height = [ UIScreen mainScreen ].bounds.size.height;

    if(height > 480)
    {
        // 这里之所以不按12345的顺序来，是因为真机调试时发现，仅改大小写有时bundle里的资源没更新，我要强行把文件名改成不一样的
        listImageName =  [NSArray arrayWithObjects:@"guide1-568h.jpg", @"guide2-568h.jpg",@"guide3-568h.jpg",@"guide4-568h.jpg",@"guide5-568h.jpg", nil];
    }
    else
    {
        listImageName = [NSArray arrayWithObjects:@"guide1.jpg", @"guide2.jpg",@"guide3.jpg",@"guide4.jpg",@"guide5.jpg", nil];
    }

    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
		[controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    // 1.ScrollView初始化
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(width * kNumberOfPages, height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.autoresizesSubviews = NO;
    [self.view addSubview:scrollView];
    
    // 2. 小点点君的初始化
    CGFloat pageControlWidth = 50;
    CGFloat pageControlHeight = 20;
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((width - pageControlWidth) / 2,
                                                                  height - pageControlHeight,
                                                                  pageControlWidth,
                                                                  pageControlHeight)];
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    NSString* imageName = [listImageName objectAtIndex:page];
    UIImageView* imageView = [viewControllers objectAtIndex:page];
    if ((NSNull*)imageView == [NSNull null])
    {
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [viewControllers replaceObjectAtIndex:page withObject:imageView];
    }
    



    // add the controller's view to the scroll view
    if (imageView.superview == nil)
    {
        
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        [scrollView addSubview:imageView];
    }
    
    
    CGFloat width = [ UIScreen mainScreen ].bounds.size.width;
    CGFloat height = [ UIScreen mainScreen ].bounds.size.height;
    if(page == kNumberOfPages - 1)
    {
        if(btnEnter == nil)
        {
            CGFloat btnWidth = 100;
            CGFloat btnHeitht = 50;
            CGFloat btnTop = 150;
            if(height < 568)
            {
                btnTop -= 40;
            }
            btnEnter = [UIButton buttonWithType:UIButtonTypeRoundedRect];;
            btnEnter.frame = CGRectMake((width - btnWidth) / 2 + width * page, btnTop, btnWidth, btnHeitht);
            [btnEnter setTitle:@"进入" forState:UIControlStateNormal];
            btnEnter.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
            [btnEnter addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [scrollView addSubview:btnEnter];
        }
    }

}


-(void)buttonClicked:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self performSegueWithIdentifier:@"Segue_GotoTabBarController" sender:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = self.view.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


@end
