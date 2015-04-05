//
//  AMSequenceStep.h
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMStave.h"

@protocol AMSequenceStepDelegate <NSObject>

@required

- (void)sequenceStepPropertiesHasBeenChanged;

@end

@interface AMSequenceStep : NSObject

- (void) addStepDelegate: (id<AMSequenceStepDelegate>)delegate;
- (void) removeStepDelegate: (id<AMSequenceStepDelegate>)delegate;

typedef enum{
    PLAY_ONCE,
    REPEAT,
    INFINITE_LOOP
} StepType;

- (id)init;
- (id)initWithSubComponents;

- (void)setStave:(AMStave *)stave;
- (AMStave*)getStave;

- (void)setNextStepType;
- (void)setStepType:(StepType)stepType;
- (StepType)getStepType;

- (void)setName: (NSString*)newName;
- (NSString*)getName;
- (NSString*)getDescription;

- (void)incrementLoop;
- (void)decrementLoop;

- (void)setNumberOfLoops:(NSInteger)numberOfLoops;
- (NSInteger)getNumberOfLoops;

- (NSInteger)stepTypeToInteger:(StepType)stepType;
- (StepType)integerToStepType:(NSInteger)stepTypeValue;

@end
