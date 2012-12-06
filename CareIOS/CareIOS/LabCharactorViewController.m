//
//  LabCharactorViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LabCharactorViewController.h"

@interface LabCharactorViewController ()

@end

@implementation LabCharactorViewController

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
    //    int height = [self.view bounds].size.width/3*2.; // 220;
    //    int width = [self.view bounds].size.width; //320;
    //    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2,width,height)];
    //    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    //    [pieChart setDiameter:width/2];
    //    [pieChart setSameColorLabel:YES];
    //
    //    [self.view addSubview:pieChart];
    //
    //    NSMutableArray *components = [NSMutableArray array];
    //    PCPieComponent *component1 = [PCPieComponent pieComponentWithTitle:@"A"
    //                                                                value:1.0f];
    //    [component1 setColour:PCColorYellow];
    //    PCPieComponent *component2 = [PCPieComponent pieComponentWithTitle:@"B"
    //                                                                 value:1.0f];
    //    [component2 setColour:PCColorGreen];
    //    PCPieComponent *component3 = [PCPieComponent pieComponentWithTitle:@"C"
    //                                                                 value:1.0f];
    //    [component3 setColour:PCColorOrange];
    //    [components addObject:component1];
    //    [components addObject:component2];
    //    [components addObject:component3];
    //    [pieChart setComponents:components];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
