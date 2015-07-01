//
// Created by Krzysztof Reczek on 13.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface AMPlayer ()

@property AVAudioPlayer *audioPlayer;

@property NSString *fileName;
@property NSString *fileKey;
@property NSString *fileType;

@property(nonatomic) NSNumber *generalVolumeFactor;
@property(nonatomic) NSNumber *volumeFactor;

//@property NSDate *date;

@end

@implementation AMPlayer

- (id)initWithFile:(NSString *)aFileName
            andKey:(NSString *)aFileKey
            ofType:(NSString *)aFileType {
    self = [super init];
    if (self) {
        _fileName = aFileName;
        _fileKey = aFileKey;
        _fileType = aFileType;
        _generalVolumeFactor = [[NSNumber alloc] initWithFloat:0.0];
        _volumeFactor = [[NSNumber alloc] initWithFloat:0.0];
    }
    return self;
}

- (void)initAudioPlayer {
    if (_audioPlayer == nil) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:_fileName ofType:_fileType];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        _audioPlayer.delegate = nil;
    }
    else {
        [_audioPlayer stop];
    }
    [_audioPlayer setVolume:_generalVolumeFactor.floatValue * _volumeFactor.floatValue];
}

- (void)playSound {
    [self initAudioPlayer];
    [_audioPlayer play];
    /*float interval = -1.0f * [_date timeIntervalSinceNow];
    NSLog([NSString stringWithFormat:@"%.05f", 60.0f / interval]);
    _date = [NSDate date];*/
}

- (void)stopSound {
    [_audioPlayer stop];
}

- (void)setSoundName:(NSString *)newName
             withKey:(NSString *)newKey {
    _fileName = newName;
    _fileKey = newKey;
}

- (NSString *)getSoundName {
    return _fileName;
}

- (NSString *)getSoundKey {
    return _fileKey;
}

- (void)setGeneralVolumeFactor:(NSNumber *)volume {
    _generalVolumeFactor = volume;
}

- (NSNumber *)getGeneralVolumeFactor {
    return _generalVolumeFactor;;
}

- (void)setVolumeFactor:(NSNumber *)volume {
    _volumeFactor = volume;
}

- (NSNumber *)getVolumeFactor {
    return _volumeFactor;
}

@end
