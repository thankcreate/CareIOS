//
//  SetRSSFeedViewController.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SetRSSFeedViewController.h"
#import "MainViewModel.h"
@interface SetRSSFeedViewController ()
@property (strong, nonatomic) IBOutlet UITextField *txtRSSPath;
@property (strong, nonatomic) IBOutlet UILabel *lblSiteTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblSiteDescription;

@end

@implementation SetRSSFeedViewController
@synthesize feedParser;
@synthesize indicatorAlert;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// 退出去要把它停掉，不然，如果此时仍在做parse会crash
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(feedParser)
    {
        [feedParser stopParsing];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MiscTool setHeader:self];
    [self initUIRSS];
}

- (void)initUIRSS
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* rssPath = [defaults objectForKey:@"RSS_FollowerPath"];
    if(rssPath == nil)
    {
        rssPath = @"";
    }
    self.txtRSSPath.text = rssPath;
    
    NSString* followerSiteTitle = [defaults objectForKey:@"RSS_FollowerSiteTitle"];    
    if(followerSiteTitle == nil)
    {
        followerSiteTitle = @"未关注";
    }
    self.lblSiteTitle.text = followerSiteTitle;
    
    NSString* followerSiteDescription = [defaults objectForKey:@"RSS_FollowerDescription"];
    if(followerSiteDescription == nil)
    {
        followerSiteDescription = @"";
    }
    self.lblSiteDescription.text = followerSiteDescription;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Event handler
- (IBAction)confirmClick:(id)sender {
    [self.txtRSSPath resignFirstResponder];
    if(self.txtRSSPath.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                        message:@"呃～是智商要超过250才能看到您写的字么？" delegate:nil
                                              cancelButtonTitle:@"寡人喻之矣" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if(![self.txtRSSPath.text hasPrefix:@"http"])
    {
        self.txtRSSPath.text = [NSString stringWithFormat:@"http://%@", self.txtRSSPath.text];
    }
    //NSURL *feedURL = [NSURL URLWithString:@"http://www.thankcreate.com/feed"];
    //NSURL *feedURL = [NSURL URLWithString:@"http://blog.csdn.net/cuiran/rss/list"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.txtRSSPath.text forKey:@"RSS_FollowerPath"];
    
    NSURL *feedURL = [NSURL URLWithString:self.txtRSSPath.text];
	feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
	feedParser.delegate = self;
	feedParser.feedParseType = ParseTypeFull; // Parse feed info and all items
	feedParser.connectionType = ConnectionTypeAsynchronously;
	[feedParser parse];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
        
    indicatorAlert = [[UIAlertView alloc] initWithTitle:@"@_@" message:@"正在解析，请稍候…" delegate:self cancelButtonTitle:@"先去做其它事" otherButtonTitles: nil];
    [indicatorAlert show];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    // Adjust the indicator so it is up a few pixels from the bottom of the alert
    CGFloat width = indicator.frame.size.width + 5;
    CGFloat height =  indicator.frame.size.height + 5;
    indicator.center = CGPointMake(width,  height);
    [indicator startAnimating];
    [indicatorAlert addSubview:indicator];
}


- (IBAction)cancelFollowClick:(id)sender {
    [self.txtRSSPath resignFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"RSS_FollowerPath"];
    [defaults removeObjectForKey:@"RSS_FollowerSiteTitle"];
    [defaults removeObjectForKey:@"RSS_FollowerDescription"];
    self.lblSiteDescription.text = @"";
    self.lblSiteTitle.text = @"";
    self.txtRSSPath.text = @"";
    [MainViewModel sharedInstance].isChanged = TRUE;
}



#pragma mark - MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
	NSLog(@"Started Parsing: %@", parser.url);
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
	NSLog(@"Parsed Feed Info: “%@”", info.title);
	self.lblSiteTitle.text = info.title;
    self.lblSiteDescription.text = info.summary;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:parser.url.absoluteString forKey:@"RSS_FollowerPath"];
    [defaults setObject:info.title forKey:@"RSS_FollowerSiteTitle"];
    [defaults setObject:info.summary forKey:@"RSS_FollowerDescription"];
    [MainViewModel sharedInstance].isChanged = TRUE;
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {

}

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if(indicatorAlert != nil)
        [indicatorAlert dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if(indicatorAlert != nil)
        [indicatorAlert dismissWithClickedButtonIndex:0 animated:NO];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"RSS_FollowerPath"];
    [defaults removeObjectForKey:@"RSS_FollowerSiteTitle"];
    [defaults removeObjectForKey:@"RSS_FollowerDescription"];
    self.lblSiteDescription.text = @"";
    self.lblSiteTitle.text = @"";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@">_<"
                                                    message:@"当前指定地址无效，请确保网络畅通" delegate:nil
                                          cancelButtonTitle:@"嗯，朕知道了～" otherButtonTitles:nil];
    [alert show];
    return;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.txtRSSPath resignFirstResponder];
}

@end
