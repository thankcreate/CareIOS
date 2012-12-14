//
//  SoundTool.m
//  CareIOS
//
//  Created by Tron Skywalker on 12-12-14.
//  Copyright (c) 2012年 ThankCreate. All rights reserved.
//

#import "SoundTool.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SoundTool

+(void)playSoundLoadComplete
{
    [self playSoundIfAllowdWithURL:@"LoadComplete" extension:@"mp3"];
}

+(void)playSoundIfAllowdWithURL:(NSString*)url extension:(NSString*)extension
{
    if(url == nil || extension == nil)
        return;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* playSound = [defaults objectForKey:@"Global_PlaySound"];
    // 默认开启声音，只有显式设成了NO，才不播放
    if(playSound != nil && [playSound compare:@"NO"] == NSOrderedSame)
    {
        return;
    }
    
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:url
                                              withExtension:extension];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

@end
