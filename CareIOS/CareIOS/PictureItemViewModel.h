//
//  PictureItemViewModel.h
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-6.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "Three20/Three20.h"
#import "CareConstants.h"

@interface PictureItemViewModel : NSObject<TTPhoto, NSCoding, NSCopying>

@property (nonatomic) CGSize size;

@property (copy, nonatomic) NSString* smallURL;
@property (copy, nonatomic) NSString* middleURL;
@property (copy, nonatomic) NSString* largeURL;

@property (copy, nonatomic) NSString* description;
@property (copy, nonatomic) NSString* title;
@property (copy, nonatomic) NSDate* time;


@property (copy, nonatomic) NSString* ID;
@property (nonatomic) EntryType type;

@end
