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
#import "ASIFormDataRequest.h"
#import "BlessItemViewModel.h"
#import "BlessConverter.h"
#import "JSON.h"
@implementation BlessHelper
@synthesize fetchDelegate;
@synthesize postDelegate;
@synthesize listImagePath;
NSString* BLESS_IMAGE_PATH_DOC_URL = @"http://42.96.147.167/thankcreate/images/image_path.txt";
NSString* BLESS_GET_URL = @"http://42.96.147.167:8181/admin/get_blessing";
NSString* BLESS_POST_URL = @"http://42.96.147.167:8181/admin/put_blessing";
NSString* BLESS_BACKGROUND_DIR = @"blessing_bkg_dir";
NSInteger MAX_BKG_COUNT = 3;
NSInteger MIN_BLESS_ITEM_COUNT = 3;

NSString* defaultImages[] = {@"bkg_blessing_1.jpg", @"bkg_blessing_2.jpg", @"bkg_blessing_3.jpg"};
NSString* defaultName[] = {@"tankery", @"豪子", @"一个孤独的散步者"};
NSString* defaultContent[] = {@"生命中最悲哀的事莫过于放弃追逐你所爱的人，看着她远离。无论你追逐多久，你还是要让他走。",
    @"人生为棋，我愿为卒，行动虽慢，可谁曾见我后退一步",
    @"不要期待得到爱，慢慢地等待你的爱在她的心中生根发芽，即使不会，你也当满足，因为你心中已有一片绿洲。"};

NSInteger REQUEST_TAG_IMAGE_LIST = 1;
NSInteger REQUEST_TAG_SINGLE_IMAGE = 2;
NSInteger REQUEST_TAG_GET_BLESS_ITEMS = 3;
NSInteger REQUEST_TAG_POST_BLESS_ITEM = 4;


// 这里偷了个超级大懒，本来应该给fetchListImagePath设一个回调的
// 等它返回来了再做fetchImages，但早由于oc里的回调挺别扭，而且目前
// fetchListImagePath之后必然是fetchImages，故直接写死
-(void)cacheBlessImages
{
    [self fetchListImagePath];
}

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
            @try
            {
                NSString* fullPath = [NSString stringWithFormat:@"%@/%@/%@",documentsDirectory, BLESS_BACKGROUND_DIR,filePath];
                UIImage* image = [UIImage imageWithContentsOfFile:fullPath];
                if(image != nil)
                {
                    [resArray addObject:image];
                }
            }
            @catch (NSException *exception) {
                continue;
            }
        }
    }
    
    int remain = MAX_BKG_COUNT - resArray.count;
    if(remain > 0)
    {
        for (int i = 0; i < remain; i++)
        {
            @try
            {
                UIImage* image = [UIImage imageNamed:defaultImages[i]];
                if(image != nil)
                {
                    [resArray addObject:image];
                }
            }
            @catch (NSException *exception) {
                continue;
            }
            
        }
    }
    
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
    
    NSArray *files = [fileManager subpathsOfDirectoryAtPath: myDir error:nil];
    
    // 如果已经下载过，就不再下载了
    // 直接通过文件名来检测
    for(NSString* url in listImagePath)
    {
        NSString* fileName = [MiscTool getFileName:url];
        if([MiscTool isNilOrEmpty:fileName])
            continue;
        
        if(![self isOneOf:fileName array:files])
            [self fetchImage:url];
    }
    
    // 本地缓存的图中，删掉listImagePath中不存在的内容
    // 这是因为每次都是直接拿本地那个目录中的所有图
    // 如果不删，会一直堆积
    NSMutableArray* listImageName = [[NSMutableArray alloc]initWithCapacity:3];
    for(NSString* fullURL in listImagePath)
    {
        [listImageName addObject:[MiscTool getFileName:fullURL]];
    }
    
    for(NSString* file in files)
    {
        if(![self isOneOf:file array:listImageName])
        {
            NSString* fullFilePath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory,BLESS_BACKGROUND_DIR,file];
            [fileManager removeItemAtPath:fullFilePath error:nil];
        }
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
        NSString* fileName = [MiscTool getFileName:url];
        
        NSString  *filePath = [NSString stringWithFormat:@"%@/%@/%@", documentsDirectory,BLESS_BACKGROUND_DIR,fileName];
        [data writeToFile:filePath atomically:YES];
    }
    else if (request.tag == REQUEST_TAG_GET_BLESS_ITEMS)
    {
        NSString* response = [request responseString];
        if(response != nil)
        {
            NSMutableArray* resList = [[NSMutableArray alloc] initWithCapacity:25];
            @try
            {
                id items = [response JSONValue];
                for(id item in items)
                {
                    BlessItemViewModel* model = [BlessConverter convertToViewModel:item];
                    if(model != nil)
                       [resList addObject:model];
                }
            }
            @catch (NSException *exception) {
                int a = 1;
                a++;
            }
            if(fetchDelegate != nil)
            {
                [fetchDelegate blessItemFetchComplete:resList];
            }
        }
    }
    else if(request.tag == REQUEST_TAG_POST_BLESS_ITEM)
    {
        if(postDelegate != nil)
        {
            [postDelegate blessItemPostComplete:YES];
        }
    }
}


// TODO
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if(request.tag == REQUEST_TAG_GET_BLESS_ITEMS)
    {
        if(fetchDelegate != nil)
        {
            [fetchDelegate blessItemFetchComplete:nil];
        }
    }
    else if(request.tag == REQUEST_TAG_POST_BLESS_ITEM)
    {
        if(postDelegate != nil)
        {
            [postDelegate blessItemPostComplete:NO];
        }
    }
}

-(BOOL)isOneOf:(NSString*)input array:(NSArray*)array
{
    if(array == nil || array.count == 0)
        return false;
    
    if(input == nil)
        return true;
    
    for(NSString* str in array)
    {
        if([input compare:str] == NSOrderedSame)
        {
            return true;
        }
    }
    return false;
}

-(NSArray*)getCachedBlessPassedItems
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* blessItems = [unarchiver decodeObjectForKey:@"blessItems"];
    [unarchiver finishDecoding];
    
    
    if(blessItems == nil)
        blessItems = [NSMutableArray arrayWithCapacity:3];
    int remain = MIN_BLESS_ITEM_COUNT;
    if(remain > 0)
    {
        for(int i = 0; i < remain ; ++i)
        {
            @try {
                BlessItemViewModel* item = [[BlessItemViewModel alloc] init];
                item.title = defaultName[i];
                item.content = defaultContent[i];
                [blessItems addObject:item];
            }
            @catch (NSException *exception) {
                continue;
            }
        }
    }
    return blessItems;
}

-(void)cacheBlessPassedItems
{
    [self fetchBlessItemWithCount:10 isPassed:true delegate:self];
}


// 这里主要是做缓存的, 只由cacheBlessPassedItems这里触发
- (void)blessItemFetchComplete:(NSArray*)result
{
    if(result == nil || result.count == 0 )
        return;
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:result forKey:@"blessItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

-(void)fetchBlessItemWithCount:(NSInteger)count isPassed:(BOOL) isPassed  delegate:(id<BlessItemFetchDelegate>)dele
{

    fetchDelegate = dele;

    
    if(count == 0)
        count = 20;
    NSString* countStr = [NSString stringWithFormat:@"%d", count];
    NSString* needPassedStr = @"0";
    if(isPassed)
        needPassedStr = @"1";

    NSString* finalURL = [NSString stringWithFormat:@"%@?count=%@&needPassed=%@", BLESS_GET_URL, countStr, needPassedStr];
    NSURL *url = [NSURL URLWithString:finalURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    request.tag = REQUEST_TAG_GET_BLESS_ITEMS;
}

-(void)postBlessItemWithName:(NSString*)name content:(NSString*)content delegate:(id<BlessItemPostDelegate>)dele
{
    postDelegate = dele;
    if(content == nil)
        return;
    
    if(name == nil || name.length == 0)
        name = @"匿名";
    
    NSURL *url = [NSURL URLWithString:BLESS_POST_URL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request setPostValue:name forKey:@"name"];
    [request setPostValue:content forKey:@"content"];
    [request setDelegate:self];
    [request startAsynchronous];
    request.tag = REQUEST_TAG_POST_BLESS_ITEM;
    
}


- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"archiveBlessItems"];
}


@end
