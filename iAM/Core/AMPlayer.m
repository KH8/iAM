//
// Created by Krzysztof Reczek on 13.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AMPlayer ()

@property AVAudioPlayer *audioPlayer;
@property NSString *fileName;
@property NSString *fileType;

@end

@implementation AMPlayer

- (id)initWithFile:(NSString *)aFileName
            ofType: (NSString*)aFileType{
    self = [super init];
    if (self)
    {
        _fileName = aFileName;
        _fileType = aFileType;
        //[self initNewAudioPlayer];
    }
    return self;
}

- (void) initNewAudioPlayer{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:_fileName ofType:_fileType];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
}

- (void) playSound {
    [self initNewAudioPlayer];
    [_audioPlayer play];
}

- (void) stopSound {
    [_audioPlayer stop];
    _audioPlayer = nil;
}

@end
