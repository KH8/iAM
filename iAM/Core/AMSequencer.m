//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"
#import "AMLogger.h"

@interface AMSequencer ()

@property NSTimer *mainTimer;

@property AMStave *mainStave;
@property AMBar *actualBar;
@property NSArray *arrayOfPlayers;

@property bool runningState;
@property NSInteger actualTickIndex;
@property NSInteger actualNoteIndex;
@property NSInteger numberOfTicksPerBeat;

@property NSMutableArray *notesToBeClearedIndex;
@property NSMutableArray *indexesCleared;

@end

@implementation AMSequencer

- (id)init {
    self = [super init];
    if (self) {
        _mainStave = [[AMStave alloc] init];
        _mainStave.mechanicalDelegate = self;

        _actualBar = _mainStave.getActualBar;

        [self initBasicParameters];

        AMPlayer *amPlayer0 = [[AMPlayer alloc] initWithFile:@"tickSound"
                                                      ofType:@"aif"];
        AMPlayer *amPlayer1 = [[AMPlayer alloc] initWithFile:@"highStickSound"
                                                      ofType:@"aif"];
        AMPlayer *amPlayer2 = [[AMPlayer alloc] initWithFile:@"lowStickSound"
                                                      ofType:@"aif"];
        _arrayOfPlayers = @[amPlayer0,amPlayer1,amPlayer2];

        [self initTimer];
        [self computeProperInterval];
    }
    return self;
}

- (void)initBasicParameters {
    _actualTickIndex = 0;
    _actualNoteIndex = 0;
    _numberOfTicksPerBeat = 0;

    _notesToBeClearedIndex = [[NSMutableArray alloc] init];
    _indexesCleared = [[NSMutableArray alloc] init];
}

- (void)initTimer {
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:0.002f
                                                  target:self selector:@selector(onTick)
                                                userInfo:nil repeats:YES];
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: _mainTimer forMode: NSRunLoopCommonModes];
}

- (void)killBackgroundThread{
    _runningState = NO;
}

- (void)startStop{
    _runningState = !_runningState;
    if(_runningState) {
        [_mainStave setFirstBarAsActual];
        [_sequencerDelegate sequenceHasStarted];
        [AMLogger logMessage:@("sequence started")];
    }
    else {
        [_sequencerDelegate sequenceHasStopped];
        [AMLogger logMessage:@("sequence stopped")];
    }
}

- (bool)isRunning {
    return _runningState;
}

- (void)clear {
    [_actualBar clear];
}

- (AMStave *)getStave {
    return _mainStave;
}

-(void)onTick {
    if (_runningState) {
        if(_actualTickIndex % _numberOfTicksPerBeat == 0){
            [self performSelectorInBackground:@selector(playTheRow)
                                   withObject:nil];
        }
        if(_actualTickIndex % _numberOfTicksPerBeat == _numberOfTicksPerBeat - 1){
            [self performSelectorInBackground:@selector(clearTheRow)
                                   withObject:nil];
        }
        _actualTickIndex++;
        if(_actualTickIndex == _numberOfTicksPerBeat * 100){
            _actualTickIndex = 0;
        }
    }
    else{
        if(_notesToBeClearedIndex.count != 0){
            [self performSelectorInBackground:@selector(clearTheRow)
                                   withObject:nil];
        }
        _actualTickIndex = 0;
        _actualNoteIndex = 0;
    }
}

- (void)playTheRow {
    NSInteger index = _actualNoteIndex % _actualBar.getLengthToBePlayed;
    [self handlePlayOnStave:_actualBar
               atPosition:(NSUInteger) index];

    dispatch_async(dispatch_get_main_queue(), ^{
        [_notesToBeClearedIndex addObject:@(index)];
    });

    _actualNoteIndex++;
    if(_actualNoteIndex == _actualBar.getLengthToBePlayed) {
        [_mainStave setNextBarAsActual];
        _actualNoteIndex = 0;
    }
}

- (void)clearTheRow {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSNumber *index in _notesToBeClearedIndex){
            [self handleStopOnStave:_actualBar
                         atPosition:(NSUInteger) index.integerValue];
            [_indexesCleared addObject:index];
        }
        for (NSNumber *index in _indexesCleared){
            [_notesToBeClearedIndex removeObject:index];
        }
    });
}

- (void)handlePlayOnStave: (AMBar *)aStave
         atPosition: (NSUInteger)aPosition{
    NSUInteger j = 0;
    for (NSMutableArray *line in aStave) {
        AMNote *note = line[aPosition];
        [note trigger];
        if(note.isPlaying){
            [_arrayOfPlayers[j] playSound];
        }
        j++;
    }
}

- (void)handleStopOnStave: (AMBar *)aStave
               atPosition: (NSUInteger)aPosition{
    NSUInteger j = 0;
    for (NSMutableArray *line in aStave) {
        AMNote *note = line[aPosition];
        [note clearTriggerMarker];
        if(note.isPlaying){
            [_arrayOfPlayers[j] stopSound];
        }
        j++;
    }
}

- (void)computeProperInterval{
    NSNumber *intervalBetweenBeatsInMilliseconds = @(60000.0f / _mainStave.getTempo);
    NSNumber *actualIntervalInGrid = @(intervalBetweenBeatsInMilliseconds.floatValue / 4.0f);
    NSNumber *numberOfTicksFloat = @(actualIntervalInGrid.floatValue / 2.0f);
    _numberOfTicksPerBeat = numberOfTicksFloat.integerValue;
}

- (void)tempoHasBeenChanged {
    [self computeProperInterval];
}

- (void)barHasBeenChanged {
    _actualBar = _mainStave.getActualBar;
    [self computeProperInterval];
}

@end