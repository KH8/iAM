//
// Created by Krzysztof Reczek on 13.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AMPlayer ()

@property AVAudioPlayer *audioPlayer;

@end

@implementation AMPlayer

- (id)initWithFile:(NSString *)aFileName
            ofType: (NSString*)aFileType{
    self = [super init];
    if (self)
    {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:aFileName ofType:aFileType];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;

        _audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    }
    return self;
}

-(void) playSound {
    [_audioPlayer play];
}

-(void) stopSound {
    [_audioPlayer stop];
}

@end
