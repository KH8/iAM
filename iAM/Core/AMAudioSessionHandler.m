//
//  AMAudioSessionHandler.m
//  iAM
//
//  Created by Krzysztof Reczek on 02.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import "AMAudioSessionHandler.h"
#import "AMPlayer.h"

@import MediaPlayer;

@interface AMAudioSessionHandler () {
}

@property AMViewController *controller;
@property AMSequencer *mainSequencer;
@property AVAudioPlayer *dummyPlayer;
@property MPNowPlayingInfoCenter *nowPlayingInfo;

@end

@implementation AMAudioSessionHandler

- (id)initWithController:(AMViewController *)controller
            andSeguencer:(AMSequencer *)mainSequencer {
    self = [super init];
    if (self) {
        _controller = controller;
        _mainSequencer = mainSequencer;
    }
    return self;
}

- (void)initAudioSession {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryMultiRoute
                                           error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [_controller becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    [self initPlayer];
}

- (void)initPlayer {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"dummy"  ofType:@"aif"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    _dummyPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    [_dummyPlayer setVolume:0.0f];
    [self initPlay];
}

- (void)initPlay {
    [_dummyPlayer setNumberOfLoops:0];
    [_dummyPlayer play];
    [NSThread sleepForTimeInterval:0.1];
    [_dummyPlayer pause];
}

- (void)deinitPlay {
    [_dummyPlayer stop];
    _dummyPlayer = nil;
}

- (void)deinitAudioSession {
    [self deinitPlay];
    [NSThread sleepForTimeInterval:0.2];
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [_controller resignFirstResponder];
}

- (void)updateSession {
    NSString *squenceDescription = [NSString stringWithFormat:@"SEQ: %@", _mainSequencer.getSequence.getName];
    NSNumber *rate = [NSNumber numberWithFloat:(_mainSequencer.isRunning ? 1.0f : 0.0f)];
    MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"icon.png"]];
    
    NSArray *keys = [NSArray arrayWithObjects:MPMediaItemPropertyAlbumTitle,
                     MPNowPlayingInfoPropertyDefaultPlaybackRate,
                     MPNowPlayingInfoPropertyPlaybackRate,
                     MPMediaItemPropertyArtwork, nil];
    NSArray *values = [NSArray arrayWithObjects:squenceDescription, @0.0f, rate, albumArt, nil];
    NSDictionary *mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    
    _nowPlayingInfo = [MPNowPlayingInfoCenter defaultCenter];
    [_nowPlayingInfo setNowPlayingInfo:mediaInfo];
}

- (void)startPlayback {
    [_dummyPlayer setNumberOfLoops:-1];
    [_dummyPlayer play];
    [self updateSession];
}

- (void)stopPlayback {
    [_dummyPlayer pause];
    [self updateSession];
}

- (void)volumeChanged:(NSNotification *)notification {
    float volume = [[[notification userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    [_mainSequencer setGlobalVolume:volume];
}

@end
