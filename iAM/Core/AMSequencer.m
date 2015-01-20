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

@property (nonatomic) NSInteger lengthToBePlayed;
@property (nonatomic) NSInteger tempo;

@property NSArray *arrayOfPlayers;

@end

@implementation AMSequencer

- (void)setBasicParameters {
    _lengthToBePlayed = 8;
    _tempo = 120;

    _maxLength = 64;
    _minLength = 1;
    _maxTempo = 280;
    _minTempo = 60;
}

- (void)initializeWithStave:(AMStave *)amStave {
    _mainStave = amStave;
    _isBackgroundRunning = YES;

    [self setBasicParameters];
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
        if(_isRunning) {
            for (NSUInteger i = 0; i < _lengthToBePlayed; i++) {
                [self handleStave:_mainStave atPosition:i withAction:@selector(playSound)];
                [self waitProperIntervalSinceDate:lastDate];
                [self handleStave:_mainStave atPosition:i withAction:@selector(stopSound)];
                if(!_isRunning) break;
                lastDate = [NSDate date];
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

- (void)waitProperIntervalSinceDate: (NSDate*)aDate{
    NSInteger intervalBetweenBeatsInMilliseconds = 60000 / _tempo;
    NSInteger actualIntervalInGrid = intervalBetweenBeatsInMilliseconds / 2;
    NSNumber *actualIntervalInGridInSeconds = @(actualIntervalInGrid / 1000.0f);
    NSNumber *timeElapsedSinceLastBeat = @([aDate timeIntervalSinceNow] * -1000.0);
    NSNumber *intervalRemaining = @(actualIntervalInGridInSeconds.floatValue - timeElapsedSinceLastBeat.floatValue);

    [NSThread sleepForTimeInterval:intervalRemaining.floatValue];
}

@end