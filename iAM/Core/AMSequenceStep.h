//
//  AMSequenceStep.h
//  iAM
//
//  Created by Krzysztof Reczek on 18.02.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMStave.h"

@interface AMSequenceStep : NSObject

enum {
    PLAY_ONCE,
    REPEAT,
    INFINITE_LOOP
};

typedef NSInteger StepType;

- (id)init;
- (AMStave*)getStave;

- (void)setNextStepType;
- (StepType)getStepType;

@end
