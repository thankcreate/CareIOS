//
//  WebViewController.m
//  DoubanAPIEngineDemo
//
//  Created by Lin GUO on 3/26/12.
//  Copyright (c) 2012 douban Inc. All rights reserved.
//

#import "DoubanLoginWebViewController.h"
#import "DOUAPIEngine.h"


static NSString * const kAPIKey = @"0ed6ec78c3bfd5cb2c84c56a4b3f8161";
static NSString * const kPrivateKey = @"e5cbdd30d10b1c5d";
static NSString * const kRedirectUrl = @"http://thankcreate.github.com/Care/callback.html";


@interface NSString (ParseCategory)
- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue 
                                           outterGlue:(NSString *)outterGlue;
@end

@implementation NSString (ParseCategory)

- (NSMutableDictionary *)explodeToDictionaryInnerGlue:(NSString *)innerGlue 
                                           outterGlue:(NSString *)outterGlue {
  // Explode based on outter glue
  NSArray *firstExplode = [self componentsSeparatedByString:outterGlue];
  NSArray *secondExplode;
  
  // Explode based on inner glue
  NSInteger count = [firstExplode count];
  NSMutableDictionary* returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
  for (NSInteger i = 0; i < count; i++) {
    secondExplode = 
    [(NSString*)[firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
    if ([secondExplode count] == 2) {
      [returnDictionary setObject:[secondExplode objectAtIndex:1] 
                           forKey:[secondExplode objectAtIndex:0]];
    }
  }
  return returnDictionary;
}

@end


@interface DoubanLoginWebViewController ()

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSURL *requestURL;

@end


@implementation DoubanLoginWebViewController
@synthesize delegate;
@synthesize webView = webView_;
@synthesize requestURL = requestURL_;


#pragma mark - View lifecycle

- (id)initWithDelegate:(id<DoubanLoginDelegate>)inputDelegate
{
  self = [super init];
  if (self) {
      delegate = inputDelegate;
      NSString *urlStr = [NSString stringWithFormat:@"https://www.douban.com/service/auth2/auth?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&scope=%@",
                          kAPIKey, kRedirectUrl,@"shuo_basic_r,shuo_basic_w,douban_basic_common"];
      NSURL *url = [NSURL URLWithString:urlStr];
      self.requestURL = url;
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = @"登录";
  
  webView_ = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                         0, 
                                                         self.view.bounds.size.width, 
                                                         self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height)];
  webView_.scalesPageToFit = YES;
  webView_.delegate = self;
  NSURLRequest *request = [NSURLRequest requestWithURL:requestURL_];
  [webView_ loadRequest:request];
  [self.view addSubview:webView_];    

}


- (void)viewDidUnload {
  self.webView = nil;
  self.requestURL = nil;
  [super viewDidUnload];
}





#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView 
    shouldStartLoadWithRequest:(NSURLRequest *)request 
    navigationType:(UIWebViewNavigationType)navigationType {
  
  NSURL *urlObj =  [request URL];
  NSString *url = [urlObj absoluteString];
  


  if ([url hasPrefix:kRedirectUrl]) {
      if([url hasSuffix:@"access_denied"])
      {
          [self.navigationController popViewControllerAnimated:YES];
          return NO;
      }
    
    NSString* query = [urlObj query];
    NSMutableDictionary *parsedQuery = [query explodeToDictionaryInnerGlue:@"=" 
                                                                outterGlue:@"&"];
    
    NSString *code = [parsedQuery objectForKey:@"code"];
    DOUOAuthService *service = [DOUOAuthService sharedInstance];
    service.authorizationURL = kTokenUrl;
    service.delegate = self;
    service.clientId = kAPIKey;
    service.clientSecret = kPrivateKey;
    service.callbackURL = kRedirectUrl;
    service.authorizationCode = code;

    [service validateAuthorizationCode];
    
    return NO;
  }
  
  return YES;
}


- (void)OAuthClient:(DOUOAuthService *)client didAcquireSuccessDictionary:(NSDictionary *)dic {
    if(delegate)
    {
        [delegate doubanDidLogin:client didAcquireSuccessDictionary:dic];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)OAuthClient:(DOUOAuthService *)client didFailWithError:(NSError *)error {
    if(delegate)
    {
        [delegate doubanloginDidFail:client didFailWithError:error];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
