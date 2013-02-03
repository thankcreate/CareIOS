//
//  LocalStorageHelper.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-16.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "LocalStorageHelper.h"
#import "MainViewModel.h"
@implementation LocalStorageHelper
+ (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"archive"];
}

+(void)loadFromLocalStorage
{
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    NSMutableArray* cacheItems = [unarchiver decodeObjectForKey:@"items"];
    if(cacheItems != nil)
        [MainViewModel sharedInstance].items = cacheItems;
    NSMutableArray* pictureCacheItems = [unarchiver decodeObjectForKey:@"pictureItems"];
    if(cacheItems != nil)
        [MainViewModel sharedInstance].pictureItems = pictureCacheItems;
    [unarchiver finishDecoding];
}

+(void)saveToLoaclStorage
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:[MainViewModel sharedInstance].items forKey:@"items"];
    [archiver encodeObject:[MainViewModel sharedInstance].pictureItems forKey:@"pictureItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


@end
