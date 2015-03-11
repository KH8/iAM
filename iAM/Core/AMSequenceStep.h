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

@property (nonatomic, weak) id <AMSequenceStepDelegate> visualDelegate;

typedef enum{
    PLAY_ONCE,
    REPEAT,
    INFINITE_LOOP
} StepType;

- (id)init;
- (AMStave*)getStave;

- (void)setNextStepType;
- (StepType)getStepType;

- (void)setName: (NSString*)newName;
- (NSString*)getName;
- (NSString*)getDescription;

- (void)incrementLoop;
- (void)decrementLoop;
- (NSInteger)getNumberOfLoops;
- (BOOL)isNumberOfLoopsAvailable;

@end
