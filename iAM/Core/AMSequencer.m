//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"

@interface AMSequencer ()

@property bool kill;
@property bool isRunning;
@property AMStave *mainStave;

@property AMPlayer *mainPlayer;

@end

@implementation AMSequencer

- (void)initializeWithStave:(AMStave *)amStave {
    _kill = false;
    _mainStave = amStave;
    [self performSelectorInBackground:@selector(runSequence) withObject:nil];

    _mainPlayer = [[AMPlayer alloc] init];
}

- (void)startStop {
    _isRunning = !_isRunning;
    if(_isRunning) [_delegate sequencerHasStarted];
    else [_delegate sequencerHasStopped];
}

- (void)runSequence{
    while (!_kill){
        if(_isRunning) {
            for (int i = 0; i < _mainStave.getLength; i++) {
                for (NSMutableArray *line in _mainStave) {
                    AMNote *note = line[i];
                    [note play];
                    [NSThread sleepForTimeInterval:0.01f];
                }
                [_mainPlayer playSound];
            }
        }
        [NSThread sleepForTimeInterval:0.01f];
    }
}

@end