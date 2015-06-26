//
//  AMSequence.m
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import "AMSequence.h"
#import "AMConfig.h"

@interface AMSequence ()

@property(nonatomic) NSString *name;
@property(nonatomic) NSDate *creationDate;
@property(nonatomic) NSString *creationDateString;

@property NSInteger actualStepLoopCounter;

@end

@implementation AMSequence

- (id)init {
    self = [super initWithMaxCount:[AMConfig maxStepCount]];
    if (self) {
        _name = @"NEW SEQUENCE";
        [self setCreationDate:[NSDate date]];
        _actualStepLoopCounter = 0;
    }
    return self;
}

- (id)initWithSubComponents {
    self = [self init];
    if (self) {
        [self addStep];
    }
    return self;
}

- (void)setName:(NSString *)newName {
    _name = newName;
}

- (NSString *)getName {
    return _name;
}

- (void)setCreationDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    _creationDate = date;
    _creationDateString = [formatter stringFromDate:_creationDate];
}

- (NSDate *)getCreationDate {
    return _creationDate;
}

- (NSString *)getCreationDateString {
    return _creationDateString;
}

- (AMSequenceStep *)getNextStep {
    AMSequenceStep *actualStep = (AMSequenceStep *) [self getActualObject];
    switch (actualStep.getStepType) {
        case PLAY_ONCE:
            [self setNextIndexAsActual];
            break;
        case REPEAT:
            _actualStepLoopCounter++;
            if (_actualStepLoopCounter == actualStep.getNumberOfLoops) {
                [self setNextIndexAsActual];
                _actualStepLoopCounter = 0;
                break;
            }
            break;
        case INFINITE_LOOP:
            break;
    }
    return (AMSequenceStep *) [self getActualObject];
}

- (int)getActualLoopCount {
    return (int)_actualStepLoopCounter;
}

- (void)addStep {
    AMSequenceStep *sequenceStep = [[AMSequenceStep alloc] initWithSubComponents];
    [self addObject:sequenceStep];
}

- (void)setOneStepForward {
    [self setNextIndexAsActual];
    _actualStepLoopCounter = 0;
}

- (void)setOneStepBackward {
    [self setPreviousIndexAsActual];
    _actualStepLoopCounter = 0;
}

- (id)clone {
    AMSequence *clone = [[AMSequence alloc] init];
    [clone setBaseArray:[super clone]];
    [clone setName:[NSString stringWithString:_name]];
    [clone setCreationDate:[NSDate date]];
    return clone;
}

@end
