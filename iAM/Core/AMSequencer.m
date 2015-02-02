//
// Created by Krzysztof Reczek on 12.01.15.
// Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequencer.h"
#import "AMNote.h"
#import "AMPlayer.h"
#import "AMLogger.h"

@interface AMSequencer ()

@property NSTimer* timer;

@property AMStave *mainStave;
@property NSArray *arrayOfPlayers;

@property bool runnignState;
@property NSInteger actualIndex;

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
        
        [self initTimer];
    }
    return self;
}

- (void)setBasicParameters {
    _lengthToBePlayed = 16;
    _tempo = 120;

    _maxLength = maxLength;
    _minLength = minLength;
    _maxTempo = maxTempo;
    _minTempo = minTempo;

    _actualIndex = 0;
}

- (void)initTimer{
    _timer = [self getTimer];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer: _timer forMode: NSDefaultRunLoopMode];
}

- (NSTimer*)getTimer{
    return [NSTimer scheduledTimerWithTimeInterval:[self getProperIntervalSinceDate]
                                            target:self selector:@selector(onTick)
                                          userInfo:nil repeats:YES];
}

- (void)killBackgroundThread{
    _runnignState = NO;
}

- (void)startStop{
    _runnignState = !_runnignState;
    if(_runnignState) {
        [_sequencerDelegate sequenceHasStarted];
        [AMLogger logMessage:@("sequence started")];
    }
    else {
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
    _timer = [self getTimer];
}

- (NSInteger)getTempo {
    return _tempo;
}

-(void)onTick {
    if(_runnignState) {
        [self performSelectorInBackground:@selector(runSequence)
                               withObject:nil];
    }
    else{
        _actualIndex = 0;
    }
}

- (void)runSequence{
    NSInteger index = _actualIndex % _lengthToBePlayed;
    [self handleStave:_mainStave atPosition:index
           withAction:@selector(playSound)];
    [NSThread sleepForTimeInterval:0.1f];
    [self handleStave:_mainStave atPosition:index
           withAction:@selector(stopSound)];
    _actualIndex++;
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

- (float)getProperIntervalSinceDate{
    NSNumber *intervalBetweenBeatsInMilliseconds = @(60000.0f / _tempo);
    NSNumber *actualIntervalInGrid = @(intervalBetweenBeatsInMilliseconds.floatValue / 8.0f);
    NSNumber *actualIntervalInGridInSeconds = @(actualIntervalInGrid.floatValue / 1000.0f);
    return actualIntervalInGridInSeconds.floatValue;
}

@end