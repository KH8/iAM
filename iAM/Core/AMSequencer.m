//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"

@interface AMSequencer ()

@property BOOL debug;

@property NSTimer *mainTimer;
@property NSDate *auxTimeStamp;
@property NSRunLoop *runner;

@property AMSequence *mainSequence;
@property AMSequenceStep *actualStep;
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
        _debug = NO;
        
        _mainSequence = [[AMSequence alloc] init];
        _mainSequence.mechanicalDelegate = self;
        
        _actualStep = _mainSequence.getActualStep;
        
        _mainStave = _actualStep.getStave;
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
        [self initRunner];
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
    _auxTimeStamp = [NSDate date];
    [self updateTimerInterval];
}

- (void)initRunner{
    _runner = [NSRunLoop currentRunLoop];
    [_runner addTimer:_mainTimer forMode: NSRunLoopCommonModes];
}

- (void)killBackgroundThread{
    _runningState = NO;
}

- (void)startStop{
    _runningState = !_runningState;
    if(_runningState) {
        [_mainStave setFirstBarAsActual];
        [_sequencerDelegate sequenceHasStarted];
    }
    else {
        [_sequencerDelegate sequenceHasStopped];
    }
}

- (BOOL)isRunning {
    return _runningState;
}

- (void)clear {
    [_actualBar clear];
}

- (AMStave *)getStave {
    return _mainStave;
}

- (AMSequence *)getSequence{
    return _mainSequence;
}

-(void)onTick {
    if(_debug){
        NSLog(@"Interval: %f", [_auxTimeStamp timeIntervalSinceNow]);
        _auxTimeStamp = [NSDate date];
    }
    if(_runningState){
    [self performSelectorInBackground:@selector(playTheRow)
                           withObject:nil];
    }
    [self performSelectorInBackground:@selector(clearTheRow)
                           withObject:nil];
}

- (void)playTheRow {
    NSInteger incrementValue = (NSInteger) (4.0 / _actualBar.getDensity);
    NSInteger index = _actualNoteIndex % _actualBar.getLengthToBePlayed;
    index = index * incrementValue;
    [self handlePlayOnStave:_actualBar
               atPosition:(NSUInteger) index];

    dispatch_async(dispatch_get_main_queue(), ^{
        [_notesToBeClearedIndex addObject:@(index)];
    });
    _actualNoteIndex++;
}

- (void)clearTheRow {
    if(_actualNoteIndex == _actualBar.getLengthToBePlayed) {
        [_mainStave setNextBarAsActual];
        _actualNoteIndex = 0;
    }
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
        [note changeTriggerMarker:NO];
        if(note.isPlaying){
            [_arrayOfPlayers[j] stopSound];
        }
        j++;
    }
}

- (void)updateTimerInterval{
    [_mainTimer invalidate];
    _mainTimer = [self getTimer];
}

- (NSTimer*)getTimer{
    NSNumber *intervalBetweenBeatsInSeconds = @(60.0f / _mainStave.getTempo);
    NSNumber *actualIntervalInGrid = @(intervalBetweenBeatsInSeconds.floatValue / _actualBar.getDensity);
    NSNumber *denominatorFactor = @(_actualBar.getSignatureDenominator / 4.0);
    NSNumber *actualIntervalAdequateToSignatureDenominator = @(actualIntervalInGrid.floatValue / denominatorFactor.floatValue);
    return [self setTimerWithInterval:actualIntervalAdequateToSignatureDenominator];
}

- (NSTimer*)setTimerWithInterval: (NSNumber*)interval{
    return [NSTimer scheduledTimerWithTimeInterval:interval.floatValue
                                                  target:self selector:@selector(onTick)
                                                userInfo:nil repeats:YES];
}

- (void)tempoHasBeenChanged {
    [self updateTimerInterval];
}

- (void)barHasBeenChanged {
    _actualBar = _mainStave.getActualBar;
    [self updateTimerInterval];
}

- (void)sequenceHasBeenChanged{
}

- (void)stepHasBeenChanged{
    _actualStep = _mainSequence.getActualStep;
    _mainStave = _actualStep.getStave;
    _mainStave.mechanicalDelegate = self;
    [_sequencerDelegate stepHasBeenChanged];
}

- (void)syncronizeParameters;{
    [_sequencerSyncDelegate stepParametersHaveBeenChanged];
}

@end