//
//  AMSequenceStep.h
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMClonableObject.h"
#import "AMStave.h"

@protocol AMSequenceStepDelegate <NSObject>

@required

- (void)sequenceStepPropertiesHasBeenChanged;

@end

@interface AMSequenceStep : AMClonableObject

- (void)addStepDelegate:(id <AMSequenceStepDelegate>)delegate;

- (void)removeStepDelegate:(id <AMSequenceStepDelegate>)delegate;

typedef enum {
    PLAY_ONCE,
    REPEAT,
    INFINITE_LOOP,
    TIMER_LOOP
} StepType;

- (id)init;

- (id)initWithSubComponents;

- (void)setStave:(AMStave *)stave;

- (AMStave *)getStave;

- (void)setNextStepType;

- (void)setStepType:(StepType)stepType;

- (StepType)getStepType;

- (NSString *)getStepTypeName;

- (void)setName:(NSString *)newName;

- (NSString *)getName;

- (NSString *)getDescription;

- (void)incrementSpecificValue;

- (void)decrementSpecificValue;

- (NSString *)getSpecificValueString;

- (void)setNumberOfLoops:(NSInteger)numberOfLoops;

- (NSInteger)getNumberOfLoops;

- (void)setTimerDuration:(NSTimeInterval)timeDuration;

- (NSTimeInterval)getTimerDuration;

- (NSInteger)stepTypeToInteger:(StepType)stepType;

- (StepType)integerToStepType:(NSInteger)stepTypeValue;

@end
