//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"
#import "AMMutableArrayResponder.h"

@interface AMSequencer ()

@property BOOL debug;

@property NSTimer *mainTimer;
@property NSDate *auxTimeStamp;
@property NSRunLoop *runner;

@property AMSequence *mainSequence;
@property AMSequenceStep *actualStep;
@property AMStave *mainStave;
@property AMBar *actualBar;

@property AMMutableArrayResponder *mainSequenceArrayResponder;
@property AMMutableArrayResponder *mainStaveArrayResponder;

@property NSArray *arrayOfPlayers;

@property bool runningState;

@property NSInteger actualNoteIndex;
@property NSInteger actualBarIndex;

@end

@implementation AMSequencer

- (id)init {
    self = [super init];
    if (self) {
        _debug = NO;
        [self initResponders];
        [self initPlayers];
        [self initBasicParameters];
        [self initTimer];
        [self initRunner];
    }
    return self;
}

- (void)initResponders{
    _mainSequenceArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(sequenceArrayHasBeenChanged)
                                                                    andSelectionHasChangedAction:@selector(sequenceSelectionHasBeenChanged)
                                                                                       andTarget:self];
    _mainStaveArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(staveArrayHasBeenChanged)
                                                                 andSelectionHasChangedAction:@selector(staveSelectionHasBeenChanged)
                                                                                    andTarget:self];
}

- (void)initPlayers{
    AMPlayer *amPlayer0 = [[AMPlayer alloc] initWithFile:@"tickSound"
                                                  ofType:@"aif"];
    AMPlayer *amPlayer1 = [[AMPlayer alloc] initWithFile:@"highStickSound"
                                                  ofType:@"aif"];
    AMPlayer *amPlayer2 = [[AMPlayer alloc] initWithFile:@"lowStickSound"
                                                  ofType:@"aif"];
    _arrayOfPlayers = @[amPlayer0,amPlayer1,amPlayer2];
}

- (void)initBasicParameters {
    _actualNoteIndex = 0;
    _actualBarIndex = 0;
}

- (void)initTimer {
    _auxTimeStamp = [NSDate date];
    _mainTimer = [self setTimerWithInterval:@1];
}

- (void)initRunner {
    _runner = [NSRunLoop currentRunLoop];
    [_runner addTimer:_mainTimer forMode: NSRunLoopCommonModes];
}

- (void)killBackgroundThread{
    _runningState = NO;
}

- (void)startStop {
    _runningState = !_runningState;
    if(_runningState) {
        [_mainStave setFirstIndexAsActual];
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

- (void)setSequence:(AMSequence *)newSequence{
    if(_runningState){
        [self startStop];
    }

    _mainSequence = newSequence;
    [_mainSequence addArrayDelegate:_mainSequenceArrayResponder];

    [self updateComponents];
    [_sequencerDelegate sequenceHasChanged];
}

- (AMSequence *)getSequence {
    return _mainSequence;
}

- (void)onTick {
    if(_debug){
        NSLog(@"Interval: %f", [_auxTimeStamp timeIntervalSinceNow]);
        _auxTimeStamp = [NSDate date];
    }
    [self clearNotes];
    [self playNotes];
}

- (void)playNotes {
    if(_runningState){
        [self playTheRow];
        [self incrementActualNoteIndex];
    }
    else{
        _actualNoteIndex = 0;
        _actualBarIndex = 0;
    }
}

- (void)clearNotes {
    [self clearTheRow];
}

- (void)incrementActualNoteIndex {
    _actualNoteIndex++;
    if(_actualNoteIndex == _actualBar.getLengthToBePlayed) {
        [self incrementActualBarIndex];
        _actualNoteIndex = 0;
    }
}

- (void)incrementActualBarIndex {
    _actualBarIndex++;
    if(_actualBarIndex == _mainStave.count) {
        [_mainSequence getNextStep];
        [_mainStave setFirstIndexAsActual];
        _actualBarIndex = 0;
    }
    else{
        [_mainStave setNextIndexAsActual];
    }
}

- (void)playTheRow {
    [self handlePlayOnStave:_actualBar
                 atPosition:(NSUInteger) [self getIndex]];
}

- (void)clearTheRow {
    for (int i = 0; i < 128; i++) {
        [self handleStopOnStave:_actualBar
                     atPosition:(NSUInteger) i];
    }
}

- (NSInteger)getIndex {
    NSInteger incrementValue = (NSInteger) (4.0 / _actualBar.getDensity);
    NSInteger index = _actualNoteIndex % _actualBar.getLengthToBePlayed;
    return index * incrementValue;
}

- (void)handlePlayOnStave: (AMBar *)aStave
         atPosition: (NSUInteger)aPosition {
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
               atPosition: (NSUInteger)aPosition {
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

- (void)signatureHasBeenChanged {
    [self updateTimerInterval];
}

- (void)sequenceArrayHasBeenChanged {

}

- (void)sequenceSelectionHasBeenChanged {
    [_mainStave setFirstIndexAsActual];
    [self updateComponents];
}

- (void)staveArrayHasBeenChanged {

}

- (void)staveSelectionHasBeenChanged {
    [self updateComponents];
}

- (void)updateComponents{
    _actualStep = (AMSequenceStep *)_mainSequence.getActualObject;
    _mainStave = _actualStep.getStave;

    [_mainStave addStaveDelegate:self];
    [_mainStave addArrayDelegate:_mainStaveArrayResponder];
    
    _actualBar = (AMBar *)_mainStave.getActualObject;
    [_actualBar addBarDelegate:self];
    
    [self updateTimerInterval];
}

@end