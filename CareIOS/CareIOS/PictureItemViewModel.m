//
//  PictureItemViewModel.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "PictureItemViewModel.h"
#import "MainViewModel.h"
@implementation PictureItemViewModel
@synthesize size;
///////////////////////////////////////////////////////////////////////////////////////////////////
// TTPhoto
- (NSString*)URLForVersion:(TTPhotoVersion)version {
    if (version == TTPhotoVersionLarge) {
        return self.largeURL;
    } else if (version == TTPhotoVersionMedium) {
        return self.middleURL;
    } else if (version == TTPhotoVersionSmall) {
        return self.smallURL;
    } else if (version == TTPhotoVersionThumbnail) {
        return self.smallURL;
    } else {
        return nil;
    }
}

- (id<TTPhotoSource>)photoSource
{
    return [MainViewModel sharedInstance];
}

//- (CGSize)size;
//{
//    return CGSizeZero;
//}

- (NSString*)caption
{
    return self.description;
}

- (NSInteger)index
{
    return [[MainViewModel sharedInstance].pictureItems indexOfObject:self];
}

@end
