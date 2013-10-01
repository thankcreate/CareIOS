//
//  AboutViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-17.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "AboutViewController.h"
#import "MobClick.h"
@interface AboutViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *rootScrollView;

@end

@implementation AboutViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile1.png"]];
    [MiscTool autoAdjuctScrollView:self.rootScrollView];

    NSString* t1 = [MobClick getConfigParams:@"var1"];
//    int a = 1;
//    a++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
