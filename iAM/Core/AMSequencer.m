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

@property NSArray *arrayOfPlayers;

@end

@implementation AMSequencer

- (void)initializeWithStave:(AMStave *)amStave {
    _kill = false;
    _mainStave = amStave;
    [self performSelectorInBackground:@selector(runSequence) withObject:nil];

    AMPlayer *amPlayer0 = [[AMPlayer alloc] initWithFile:@"tickSound" ofType:@"wav"];
    AMPlayer *amPlayer1 = [[AMPlayer alloc] initWithFile:@"highStickSound" ofType:@"wav"];
    AMPlayer *amPlayer2 = [[AMPlayer alloc] initWithFile:@"lowStickSound" ofType:@"wav"];

    _arrayOfPlayers = @[amPlayer0,amPlayer1,amPlayer2];
}

- (void)startStop {
    _isRunning = !_isRunning;
    if(_isRunning) [_delegate sequencerHasStarted];
    else [_delegate sequencerHasStopped];
}

- (void)runSequence{
    while (!_kill){
        if(_isRunning) {
            for (NSUInteger i = 0; i < _mainStave.getLength; i++) {
                NSUInteger j = 0;
                for (NSMutableArray *line in _mainStave) {
                    AMNote *note = line[i];
                    [note trigger];
                    if(note.isPlaying){
                        [_arrayOfPlayers[j] playSound];
                    }
                    j++;
                }
                [NSThread sleepForTimeInterval:0.1f];
                for (NSMutableArray *line in _mainStave) {
                    AMNote *note = line[i];
                    [note trigger];
                }
            }
        }
    }
}

@end