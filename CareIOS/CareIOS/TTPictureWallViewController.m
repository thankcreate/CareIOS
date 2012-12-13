//
//  TTPictureWallViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTPictureWallViewController.h"
#import "MainViewModel.h"
@implementation TTPictureWallViewController

- (void)viewDidLoad {
    self.tableView.sectionHeaderHeight = 0;
    MainViewModel* mainViewModel = [MainViewModel sharedInstance];
    self.photoSource = mainViewModel;
}

//- (BOOL)shouldReload {
//    static bool firstIn = true;
//    if(firstIn)
//    {
//        firstIn = false;
//        return true;
//    }
//    else
//    {
//        return false;
//    }
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [CareConstants headerColor];
    MainViewModel* mainViewModel = [MainViewModel sharedInstance];
    if(mainViewModel.isChanged)
    {
        [mainViewModel load:TTURLRequestCachePolicyNetwork more:NO];
    }
}

- (void)updateTableLayout
{
    // 这里有个奇怪的bug，如果不写下面两句的话，会出现一个空白header
    self.tableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - Event

- (IBAction)refreshClick:(id)sender
{
    [[MainViewModel sharedInstance] load:TTURLRequestCachePolicyNetwork more:NO];
}
@end
