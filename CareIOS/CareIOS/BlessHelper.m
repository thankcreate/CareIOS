//
//  BlessHelper.m
//  CareIOS
//
//  Created by Tron Skywalker on 13-2-3.
//  Copyright (c) 2013年 ThankCreate. All rights reserved.
//

// TODO: now all the exception are not handled well! 

#import "BlessHelper.h"
#import "ASIHTTPRequest.h"

@implementation BlessHelper

@synthesize  listImagePath;
NSString* BLESS_IMAGE_PATH_DOC_URL = @"http://42.96.147.167/thankcreate/images/image_path.txt";
NSString* BLESS_GET_URL = @"http://42.96.147.167:8181/admin/get_blessing";
NSString* BLESS_POST_URL = @"http://42.96.147.167:8181/admin/put_blessing";
NSString* BLESS_BACKGROUND_DIR = @"blessing_bkg_dir";


NSInteger REQUEST_TAG_IMAGE_LIST = 1;
NSInteger REQUEST_TAG_SINGLE_IMAGE = 2;

-(void)fetchListImagePath
{
    NSURL *url = [NSURL URLWithString:BLESS_IMAGE_PATH_DOC_URL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request startAsynchronous];
    request.tag = REQUEST_TAG_IMAGE_LIST;
}

-(NSMutableArray*)getBlessImages
{
    NSMutableArray *resArray = [[NSMutableArray alloc]initWithCapacity:3];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *myDir = [documentsDirectory stringByAppendingPathComponent:BLESS_BACKGROUND_DIR];
    if([fileManager fileExistsAtPath:myDir])
    {
        NSArray *files = [fileManager subpathsOfDirectoryAtPath: myDir error:nil];
        for(NSString* filePath in files)
        {
            NSString* fullPath = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory, BLESS_BACKGROUND_DIR,filePath];
            UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
            if(image != nil)
            {
                [resArray addObject:image];
            }
        }
    }
    
    // TODO    
    return resArray;
}


-(void)fetchImages
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *myDir = [documentsDirectory stringByAppendingPathComponent:BLESS_BACKGROUND_DIR];

    if(![fileManager fileExistsAtPath:myDir])
    {
        [fileManager createDirectoryAtPath:myDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    
    // TODO: check if the file already exits
    NSArray *files = [fileManager subpathsOfDirectoryAtPath: myDir error:nil];
    for(NSString* filePath in files)
    {
        NSLog(@"%@",filePath);
    }
    
    for(NSString* url in listImagePath)
    {
        [self fetchImage:url];
    }
}

-(void)fetchImage:(NSString*)netURL
{
    NSURL *url = [NSURL URLWithString:netURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setDelegate:self];
    [request startAsynchronous];
    request.tag = REQUEST_TAG_SINGLE_IMAGE;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    //if([request.url.absoluteString compare:BLESS_IMAGE_PATH_DOC_URL] == NSOrderedSame)
    if(request.tag == REQUEST_TAG_IMAGE_LIST )
    {
        NSString *response = [request responseString];
        if(response != nil)
        {
            NSArray *pathArray = [response componentsSeparatedByString:@";"];
            if(listImagePath == nil)
            {
                listImagePath = [NSMutableArray arrayWithCapacity:3];
            }
            for (NSString *path in pathArray)
            {
                NSString *trimPath = [path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [listImagePath addObject:trimPath];
            }
            [self fetchImages];
        }
    }
    else if (request.tag == REQUEST_TAG_SINGLE_IMAGE)
    {
        NSData* data = [request responseData];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString  *documentsDirectory = [paths objectAtIndex:0];
        
        NSString* url = request.url.absoluteString;
        NSArray *linkSeperated = [url componentsSeparatedByString:@"/"];
        NSString* fileName = [linkSeperated lastObject];        
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory,BLESS_BACKGROUND_DIR,fileName];
        [data writeToFile:filePath atomically:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
 }

@end
