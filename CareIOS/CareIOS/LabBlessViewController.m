//
//  LabBlessViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-7.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

#import "LabBlessViewController.h"
#import "BlessItemViewModel.h"
#import "TTTableBlessItem.h"
@interface LabBlessViewController ()

@end

@implementation LabBlessViewController
@synthesize blessList;
@synthesize blessHelper;

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
    [self initBackground];
    blessList = [[NSMutableArray alloc] init];
    self.variableHeightRows = YES;
    
    // 清除额外的分隔线
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    v.backgroundColor = [UIColor clearColor];
    
    [self.tableView setTableFooterView:v];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile1.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
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
}

- (void)viewWillAppear:(BOOL)animated
{
    // 从网络加载items,目前不设缓存
    [self fetchBlessItems];
}

-(void)fetchBlessItems
{
    if(blessHelper == nil)
        blessHelper = [[BlessHelper alloc]init];
    [blessHelper fetchBlessItemWithCount:25 isPassed:NO delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BlessItemFetchDelegate protocol
- (void)blessItemFetchComplete:(NSArray*)result
{
    if(result == nil || result.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"由于未知原因网络请求失败，请确保网络畅通" delegate:nil
                                              cancelButtonTitle:@"拖出去枪毙五分钟～" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableArray* sections = [[NSMutableArray alloc] init];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    [sections addObject:@""];
    NSMutableArray* itemsRow = [[NSMutableArray alloc] init];
    
    blessList = result;
    int index = 0;
    for(BlessItemViewModel* model in blessList)
    {
        if(model != nil)
        {
            TTTableBlessItem* item = [TTTableBlessItem itemWithBlessItemViewModel:model];
            item.index = index++;
            [itemsRow addObject:item];
        }
    }
    [items addObject:itemsRow];
    self.dataSource = [TTSectionedDataSource dataSourceWithItems:items sections:sections];
    [self.tableView reloadData];
    [self.tableView reloadInputViews];
}
@end
