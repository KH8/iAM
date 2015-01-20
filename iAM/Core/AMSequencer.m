//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"

@interface AMSequencer ()

@property bool isBackgroundRunning;
@property bool isRunning;
@property AMStave *mainStave;
@property (nonatomic) int lengthToBePlayed;

@property NSArray *arrayOfPlayers;

@end

@implementation AMSequencer

- (void)initializeWithStave:(AMStave *)amStave {
    _isBackgroundRunning = YES;
    _maxLength = 64;
    _minLength = 1;

    _mainStave = amStave;
    _lengthToBePlayed = amStave.getNumberOfNotesPerLine;

    [self performSelectorInBackground:@selector(runSequence) withObject:nil];

    AMPlayer *amPlayer0 = [[AMPlayer alloc] initWithFile:@"tickSound" ofType:@"aif"];
    AMPlayer *amPlayer1 = [[AMPlayer alloc] initWithFile:@"highStickSound" ofType:@"aif"];
    AMPlayer *amPlayer2 = [[AMPlayer alloc] initWithFile:@"lowStickSound" ofType:@"aif"];

    _arrayOfPlayers = @[amPlayer0,amPlayer1,amPlayer2];
}

- (void)killBackgroundThread{
    _isBackgroundRunning = NO;
}

- (void)startStop{
    _isRunning = !_isRunning;
    if(_isRunning) [_delegate sequencerHasStarted];
    else [_delegate sequencerHasStopped];
}

- (void)setLengthToBePlayed:(int)aLength {
    _lengthToBePlayed = (int) aLength;
}

- (NSUInteger)getLengthToBePlayed {
    return (NSUInteger) _lengthToBePlayed;
}


- (void)runSequence{
    while (_isBackgroundRunning){
        if(_isRunning) {
            for (NSUInteger i = 0; i < _lengthToBePlayed; i++) {
                [self handleStave:_mainStave atPosition:i withAction:@selector(playSound)];
                [NSThread sleepForTimeInterval:0.1f];
                [self handleStave:_mainStave atPosition:i withAction:@selector(stopSound)];
                if(!_isRunning) break;
            }
        }
    }
}

- (void)handleStave: (AMStave *)aStave atPosition: (NSUInteger)aPosition withAction: (SEL)aSelector{
    NSUInteger j = 0;
    for (NSMutableArray *line in aStave) {
        AMNote *note = line[aPosition];
        [note trigger];
        if(note.isPlaying){
            ((void (*)(id, SEL))[_arrayOfPlayers[j] methodForSelector:aSelector])(_arrayOfPlayers[j], aSelector);
        }
        j++;
    }
}

@end