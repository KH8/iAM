//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"
#import "AMLogger.h"

@interface AMSequencer ()

@property bool isBackgroundRunning;
@property bool runnignState;
@property AMStave *mainStave;

@property (nonatomic) NSInteger lengthToBePlayed;
@property (nonatomic) NSInteger tempo;

@property NSArray *arrayOfPlayers;

@end

@implementation AMSequencer

NSUInteger const maxLength = 64;
NSUInteger const minLength = 3;
NSUInteger const maxTempo = 300;
NSUInteger const minTempo = 60;

- (void)setBasicParameters {
    _lengthToBePlayed = 16;
    _tempo = 120;

    _maxLength = maxLength;
    _minLength = minLength;
    _maxTempo = maxTempo;
    _minTempo = minTempo;
}

- (id)init {
    self = [super init];
    if (self) {
        _mainStave = [[AMStave alloc] init];
        [_mainStave configureDefault];

        [self setBasicParameters];

        AMPlayer *amPlayer0 = [[AMPlayer alloc] initWithFile:@"tickSound"
                                                      ofType:@"aif"];
        AMPlayer *amPlayer1 = [[AMPlayer alloc] initWithFile:@"highStickSound"
                                                      ofType:@"aif"];
        AMPlayer *amPlayer2 = [[AMPlayer alloc] initWithFile:@"lowStickSound"
                                                      ofType:@"aif"];

        _arrayOfPlayers = @[amPlayer0,amPlayer1,amPlayer2];
    }
    return self;
}

- (void)killBackgroundThread{
    _isBackgroundRunning = NO;
}

- (void)startStop{
    _runnignState = !_runnignState;
    if(_runnignState) {
        _isBackgroundRunning = YES;
        [self performSelectorInBackground:@selector(runSequence)
                               withObject:nil];
        [_sequencerDelegate sequenceHasStarted];
        [AMLogger logMessage:@("sequence started")];
    }
    else {
        _isBackgroundRunning = NO;
        [_sequencerDelegate sequenceHasStopped];
        [AMLogger logMessage:@("sequence stopped")];
    }
}

- (bool)isRunning {
    return _runnignState;
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
}

- (NSInteger)getTempo {
    return _tempo;
}

- (void)runSequence{
    while (_isBackgroundRunning){
        NSDate *lastDate = [NSDate date];
        if(_runnignState) {
            for (NSUInteger i = 0; i < _lengthToBePlayed; i++) {
                [self handleStave:_mainStave atPosition:i
                       withAction:@selector(playSound)];
                [self waitProperIntervalSinceDate:lastDate];
                [self handleStave:_mainStave atPosition:i
                       withAction:@selector(stopSound)];
                if(!_runnignState) {
                    break;
                }
                [AMLogger logMessage:[NSString stringWithFormat:@"interval since last bar: %f", [lastDate timeIntervalSinceNow] * -1000.f]];
                lastDate = [NSDate date];
            }
        }
    }
}

- (void)handleStave: (AMStave *)aStave
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

- (void)waitProperIntervalSinceDate: (NSDate*)aDate{
    NSNumber *intervalBetweenBeatsInMilliseconds = @(60000.0f / _tempo);
    NSNumber *actualIntervalInGrid = @(intervalBetweenBeatsInMilliseconds.floatValue / 8.0f);
    NSNumber *actualIntervalInGridInSeconds = @(actualIntervalInGrid.floatValue / 1000.0f);
    NSNumber *timeElapsedSinceLastBeat = @([aDate timeIntervalSinceNow] * -1.0f);
    NSNumber *intervalRemaining = @(actualIntervalInGridInSeconds.floatValue - timeElapsedSinceLastBeat.floatValue);

    [NSThread sleepForTimeInterval:intervalRemaining.floatValue];
}

@end