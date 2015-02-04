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

@property AMBar *mainStave;
@property NSArray *arrayOfPlayers;

@property bool runningState;
@property NSInteger actualTickIndex;
@property NSInteger actualNoteIndex;
@property NSInteger numberOfTicksPerBeat;

@property NSMutableArray *notesToBeClearedIndex;
@property NSMutableArray *indexesCleared;

@property (nonatomic) NSInteger lengthToBePlayed;
@property (nonatomic) NSInteger tempo;

@end

@implementation AMSequencer

NSUInteger const maxLength = 64;
NSUInteger const minLength = 3;
NSUInteger const maxTempo = 300;
NSUInteger const minTempo = 60;

- (id)init {
    self = [super init];
    if (self) {
        _mainStave = [[AMBar alloc] init];
        [_mainStave configureDefault];

        [self initBasicParameters];

        AMPlayer *amPlayer0 = [[AMPlayer alloc] initWithFile:@"tickSound"
                                                      ofType:@"aif"];
        AMPlayer *amPlayer1 = [[AMPlayer alloc] initWithFile:@"highStickSound"
                                                      ofType:@"aif"];
        AMPlayer *amPlayer2 = [[AMPlayer alloc] initWithFile:@"lowStickSound"
                                                      ofType:@"aif"];
        _arrayOfPlayers = @[amPlayer0,amPlayer1,amPlayer2];

        [self initTimer];
        [self computeProperIntervalSinceDate];
    }
    return self;
}

- (void)initBasicParameters {
    _lengthToBePlayed = 16;
    _tempo = 120;

    _maxLength = maxLength;
    _minLength = minLength;
    _maxTempo = maxTempo;
    _minTempo = minTempo;

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
    [_mainStave clear];
}


- (NSInteger)getNumberOfLines {
    return _mainStave.count;
}

- (NSMutableArray *)getLine: (NSUInteger)index {
    return _mainStave[index];
}

- (void)setLengthToBePlayed:(NSInteger)aLength {
    _lengthToBePlayed = aLength;
}

- (NSInteger)getLengthToBePlayed {
    return _lengthToBePlayed;
}

- (void)setTempo:(NSInteger)aTempo {
    _tempo = aTempo;
    [self computeProperIntervalSinceDate];
}

- (NSInteger)getTempo {
    return _tempo;
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
    NSInteger index = _actualNoteIndex % _lengthToBePlayed;
    [self handleStave:_mainStave atPosition:(NSUInteger) index
           withAction:@selector(playSound)];

    dispatch_async(dispatch_get_main_queue(), ^{
        [_notesToBeClearedIndex addObject:@(index)];
    });

    _actualNoteIndex++;
    if(_actualNoteIndex == _lengthToBePlayed * 100) {
        _actualNoteIndex = 0;
    }
}

- (void)clearTheRow {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSNumber *index in _notesToBeClearedIndex){
            [self handleStave:_mainStave atPosition:(NSUInteger) index.integerValue
                   withAction:@selector(stopSound)];
            [_indexesCleared addObject:index];
        }
        for (NSNumber *index in _indexesCleared){
            [_notesToBeClearedIndex removeObject:index];
        }
    });
}

- (void)handleStave: (AMBar *)aStave
         atPosition: (NSUInteger)aPosition
         withAction: (SEL)aSelector{
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

- (void)computeProperIntervalSinceDate{
    NSNumber *intervalBetweenBeatsInMilliseconds = @(60000.0f / _tempo);
    NSNumber *actualIntervalInGrid = @(intervalBetweenBeatsInMilliseconds.floatValue / 4.0f);
    NSNumber *numberOfTicksFloat = @(actualIntervalInGrid.floatValue / 2.0f);
    _numberOfTicksPerBeat = numberOfTicksFloat.integerValue;
}

@end