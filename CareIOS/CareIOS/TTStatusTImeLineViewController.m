//
//  TTStatusTImeLineViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-4.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "TTStatusTImeLineViewController.h"
#import "MainViewModel.h"
#import "TTStatusTImeDragRefreshDelegate.h"
@interface TTStatusTImeLineViewController ()
@property (strong, nonatomic) MainViewModel* mainViewModel;
@property (strong, nonatomic) RefreshViewerHelper* refreshViewerHelper;
@end

@implementation TTStatusTImeLineViewController
@synthesize refreshViewerHelper;
@synthesize mainViewModel;


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super updateTableDelegate];
    refreshViewerHelper = [[RefreshViewerHelper alloc] initWithDelegate:self];
    mainViewModel = [MainViewModel sharedInstance];
    [mainViewModel.delegates addObject:self];
    self.variableHeightRows = YES;
    
    self.tableViewStyle = UITableViewStylePlain;
 
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if(mainViewModel.isChanged)
    {
        [mainViewModel load:TTURLRequestCachePolicyNetwork more:NO];
    }
}

- (id<UITableViewDelegate>)createDelegate {
    return [[TTStatusTImeDragRefreshDelegate alloc] initWithController:self] ;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelDelegate
- (void)modelDidFinishLoad:(id<TTModel>)model
{  
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    
    
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    for (ItemViewModel* model in mainViewModel.items)
    {
        TTTableMessageItem* item = [TTTableMessageItem itemWithTitle:model.title
                                                             caption:nil
                                                                text:model.content
                                                           timestamp:model.time
                                                            imageURL:model.iconURL
                                                                 URL:nil];
        item.thumbImageURL = model.imageURL;
        item.from = @"来自 新浪微博";
        
        // 转发
        if(model.forwardItem)
        {
            TTTableMessageItem* forwardItem = [TTTableMessageItem itemWithTitle:model.forwardItem.title
                                                                        caption:nil
                                                                           text:model.forwardItem.content
                                                                      timestamp:model.time
                                                                       imageURL:model.forwardItem.iconURL
                                                                            URL:nil];
            forwardItem.thumbImageURL = model.forwardItem.imageURL;
            item.forwardItem = forwardItem;
        }
        [itemsRow addObject: item];
    }
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
}

- (IBAction)ButtonRefresh_Clicked:(id)sender {
    [mainViewModel load:TTURLRequestCachePolicyNetwork more:NO];
}


@end
