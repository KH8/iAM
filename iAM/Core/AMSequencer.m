//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"
#import "AMMutableArrayResponder.h"
#import "AMRunner.h"

@interface AMSequencer ()

@property AMRunner *mainRunner;

@property AMSequence *mainSequence;
@property AMSequenceStep *actualStep;
@property AMStave *mainStave;
@property AMBar *actualBar;

@property AMMutableArrayResponder *mainSequenceArrayResponder;
@property AMMutableArrayResponder *mainStaveArrayResponder;

@property NSArray *arrayOfPlayers;

@property bool runningState;
@property bool runTheLoop;

@property NSInteger actualNoteIndex;
@property NSInteger actualBarIndex;

@property (nonatomic, strong) NSHashTable *sequencerDelegates;

@end

@implementation AMSequencer

- (void)addSequencerDelegate: (id<AMSequencerDelegate>)delegate {
    [_sequencerDelegates addObject: delegate];
}

- (void)removeSequencerDelegate: (id<AMSequencerDelegate>)delegate {
    [_sequencerDelegates removeObject: delegate];
}

- (void)delegateSequencerHasStarted {
    for (id<AMSequencerDelegate> delegate in _sequencerDelegates) {
        [delegate sequenceHasStarted];
    }
}

- (void)delegateSequencerHasStopped {
    for (id<AMSequencerDelegate> delegate in _sequencerDelegates) {
        [delegate sequenceHasStopped];
    }
}

- (void)delegateSequenceHasChanged {
    for (id<AMSequencerDelegate> delegate in _sequencerDelegates) {
        [delegate sequenceHasChanged];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        _sequencerDelegates = [NSHashTable weakObjectsHashTable];
        [self initResponders];
        [self initPlayers];
        [self initBasicParameters];
        [self initRunner];
    }
    return self;
}

- (void)initResponders{
    _mainSequenceArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(sequenceArrayHasBeenChanged)
                                                                    andSelectionHasChangedAction:@selector(sequenceSelectionHasBeenChanged)
                                                                       andMaxCountExceededAction:@selector(sequenceMaxCountExceeded)
                                                                                       andTarget:self];
    _mainStaveArrayResponder = [[AMMutableArrayResponder alloc] initWithArrayHasChangedAction:@selector(staveArrayHasBeenChanged)
                                                                 andSelectionHasChangedAction:@selector(staveSelectionHasBeenChanged)
                                                                    andMaxCountExceededAction:@selector(staveMaxCountExceeded)
                                                                                    andTarget:self];
}

- (void)initPlayers{
    AMPlayer *amPlayer0 = [[AMPlayer alloc] initWithFile:@""
                                                  andKey:@""
                                                  ofType:@"aif"];
    AMPlayer *amPlayer1 = [[AMPlayer alloc] initWithFile:@""
                                                  andKey:@""
                                                  ofType:@"aif"];
    AMPlayer *amPlayer2 = [[AMPlayer alloc] initWithFile:@""
                                                  andKey:@""
                                                  ofType:@"aif"];
    _arrayOfPlayers = @[amPlayer0,amPlayer1,amPlayer2];
}

- (void)initBasicParameters {
    _actualNoteIndex = 0;
    _actualBarIndex = 0;
}

- (void)initRunner {
    _mainRunner = [[AMRunner alloc] initWithTickAction:@selector(onTick) andTarget:self];
}

- (void)killBackgroundThread{
    _runningState = NO;
}

- (void)startStop {
    _runningState = !_runningState;
    if(_runningState) {
        [_mainStave setFirstIndexAsActual];
        _runTheLoop = YES;
        [self delegateSequencerHasStarted];
    }
    else {
        [self delegateSequencerHasStopped];
    }
}

- (BOOL)isRunning {
    return _runningState;
}

- (void)clear {
    [_actualBar clear];
}

- (void)setSequence:(AMSequence *)newSequence{
    if(_runningState){
        [self startStop];
    }

    _mainSequence = newSequence;
    [_mainSequence addArrayDelegate:_mainSequenceArrayResponder];

    [self updateComponents];
    [self delegateSequenceHasChanged];
}

- (AMSequence *)getSequence {
    return _mainSequence;
}

- (NSArray*)getArrayOfPlayers {
    return _arrayOfPlayers;
}

- (void)onTick {
    [self playNotes];
}

- (void)playNotes {
    if(_runTheLoop) {
        [self clearTheRow];
        if(!_runningState){
            _runTheLoop = false;
            return;
        }
        [self playTheRow];
        [self incrementActualNoteIndex];
    }
    else {
        _actualNoteIndex = 0;
        _actualBarIndex = 0;
    }
}

- (void)incrementActualNoteIndex {
    _actualNoteIndex++;
    if(_actualNoteIndex >= _actualBar.getLengthToBePlayed) {
        [self incrementActualBarIndex];
        _actualNoteIndex = 0;
    }
}

- (void)incrementActualBarIndex {
    _actualBarIndex++;
    if(_actualBarIndex >= _mainStave.count) {
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
        j++;
    }
}

- (void)tempoHasBeenChanged {
    [self updateTimerInterval];
}

- (void)tempoHasBeenTapped {
    _actualNoteIndex = 0;
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

- (void)sequenceMaxCountExceeded {
    
}

- (void)staveArrayHasBeenChanged {

}

- (void)staveSelectionHasBeenChanged {
    [self updateComponents];
}

- (void)staveMaxCountExceeded {
    
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

- (void)updateTimerInterval{
    NSNumber *interval = [self computeTimeInterval];
    [_mainRunner changeIntervalTime:interval];
}

- (NSNumber*)computeTimeInterval{
    NSNumber *intervalBetweenBeatsInSeconds = @(60.0f / _mainStave.getTempo);
    NSNumber *actualIntervalInGrid = @(intervalBetweenBeatsInSeconds.floatValue / _actualBar.getDensity);
    NSNumber *denominatorFactor = @(_actualBar.getSignatureDenominator / 4.0);
    NSNumber *actualIntervalAdequateToSignatureDenominator = @(actualIntervalInGrid.floatValue / denominatorFactor.floatValue);
    return actualIntervalAdequateToSignatureDenominator;
}

@end