//
// Created by Krzysztof Reczek on 13.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation AMPlayer

-(void) playSound {
    AVAudioPlayer *audioPlayer;

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"tickSound" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;

    audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    [audioPlayer play];
}

@end
